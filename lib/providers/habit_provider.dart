import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/habit.dart';
import '../repositories/habit_repository.dart';
import 'auth_provider.dart';

final habitsProvider = StateNotifierProvider<HabitsNotifier, List<Habit>>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  return HabitsNotifier(userId: currentUser?.id);
});

class HabitsNotifier extends StateNotifier<List<Habit>> {
  final String? userId;

  HabitsNotifier({required this.userId}) : super([]) {
    if (userId != null) {
      _loadHabits();
    }
  }

  void _loadHabits() {
    if (userId == null) {
      state = [];
      return;
    }
    state = HabitRepository.getAllHabits(userId: userId!);
  }

  Future<void> addHabit({
    required String name,
    required String emoji,
    required String period,
    required List<String> scheduledDays,
    String? description,
  }) async {
    if (userId == null) {
      throw Exception('Пользователь не авторизован');
    }

    if (state.length >= 5) {
      throw Exception('Максимум 5 привычек');
    }

    final habit = Habit(
      id: const Uuid().v4(),
      name: name,
      emoji: emoji,
      period: period,
      scheduledDays: scheduledDays,
      createdAt: DateTime.now(),
      description: description,
      userId: userId!,
    );

    await HabitRepository.addHabit(habit);
    // Обновляем состояние после добавления
    await Future.delayed(const Duration(milliseconds: 100));
    _loadHabits();
  }

  Future<void> updateHabit({
    required String habitId,
    required String name,
    required String emoji,
    required String period,
    required List<String> scheduledDays,
    String? description,
  }) async {
    final index = HabitRepository.getHabitIndexById(habitId);
    if (index == null) return;

    final habit = state.firstWhere((h) => h.id == habitId);
    habit.name = name;
    habit.emoji = emoji;
    habit.period = period;
    habit.scheduledDays = scheduledDays;
    habit.description = description;

    await HabitRepository.updateHabit(index, habit);
    _loadHabits();
  }

  Future<void> deleteHabit(String habitId) async {
    final index = HabitRepository.getHabitIndexById(habitId);
    if (index == null) return;

    await HabitRepository.deleteHabit(index);
    _loadHabits();
  }

  Future<void> markHabitCompleted(String habitId, DateTime date) async {
    final index = HabitRepository.getHabitIndexById(habitId);
    if (index == null) return;

    final habit = state.firstWhere((h) => h.id == habitId);
    habit.markCompleted(date);
    await HabitRepository.updateHabit(index, habit);
    _loadHabits();
  }

  Future<void> unmarkHabitCompleted(String habitId, DateTime date) async {
    final index = HabitRepository.getHabitIndexById(habitId);
    if (index == null) return;

    final habit = state.firstWhere((h) => h.id == habitId);
    habit.unmarkCompleted(date);
    await HabitRepository.updateHabit(index, habit);
    _loadHabits();
  }
}

// Провайдер для получения одной привычки по ID
final habitProvider = Provider.family<Habit?, String>((ref, habitId) {
  final habits = ref.watch(habitsProvider);
  try {
    return habits.firstWhere((habit) => habit.id == habitId);
  } catch (e) {
    return null;
  }
});

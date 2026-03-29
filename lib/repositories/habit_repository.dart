import 'package:hive_flutter/hive_flutter.dart';
import '../models/habit.dart';

class HabitRepository {
  static const String habitsBoxName = 'habits';
  static late Box<Habit> _habitsBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(HabitAdapter());
    _habitsBox = await Hive.openBox<Habit>(habitsBoxName);
  }

  static Box<Habit> get habitsBox => _habitsBox;

  // Получить все привычки текущего пользователя
  static List<Habit> getAllHabits({required String userId}) {
    return _habitsBox.values
        .where((habit) => habit.userId == userId)
        .toList();
  }

  // Добавить новую привычку
  static Future<void> addHabit(Habit habit) async {
    await _habitsBox.add(habit);
  }

  // Обновить привычку
  static Future<void> updateHabit(int index, Habit habit) async {
    await _habitsBox.putAt(index, habit);
  }

  // Удалить привычку
  static Future<void> deleteHabit(int index) async {
    await _habitsBox.deleteAt(index);
  }

  // Найти привычку по ID
  static Habit? getHabitById(String id) {
    try {
      return _habitsBox.values.firstWhere((habit) => habit.id == id);
    } catch (e) {
      return null;
    }
  }

  // Получить индекс привычки по ID
  static int? getHabitIndexById(String id) {
    try {
      return _habitsBox.values.toList().indexWhere((habit) => habit.id == id);
    } catch (e) {
      return null;
    }
  }

  // Очистить все данные
  static Future<void> clearAll() async {
    await _habitsBox.clear();
  }
}

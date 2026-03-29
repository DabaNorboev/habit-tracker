import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/habit_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/habit_card.dart';
import '../widgets/confetti_overlay.dart';
import 'create_habit_screen.dart';
import 'profile_screen.dart';
import 'progress_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _showConfetti = false;

  @override
  Widget build(BuildContext context) {
    final habits = ref.watch(habitsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои привычки'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
                child: const Text(
                  '👤',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          habits.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  itemCount: habits.length,
                  itemBuilder: (context, index) {
                    final habit = habits[index];
                    return HabitCard(
                      habit: habit,
                      index: index,
                      onTap: (selectedHabit) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProgressScreen(habitId: selectedHabit.id),
                          ),
                        );
                      },
                      onDayTapped: (habitId, dayIndex) {
                        final now = DateTime.now();
                        final startDate = _getStartDate(now);
                        DateTime targetDate;
                        
                        if (dayIndex == -1) {
                          // Кнопка "Отметить за вчера"
                          targetDate = now.subtract(const Duration(days: 1));
                        } else {
                          targetDate = startDate.add(Duration(days: dayIndex));
                        }
                        
                        if (habit.isCompletedOnDate(targetDate)) {
                          ref.read(habitsProvider.notifier).unmarkHabitCompleted(habitId, targetDate);
                        } else {
                          ref.read(habitsProvider.notifier).markHabitCompleted(habitId, targetDate);
                        }
                      },
                      onDayLongPressed: (habitId, dayIndex) {
                        _showUnmarkConfirmation(context, ref, habitId, dayIndex);
                      },
                    );
                  },
                ),
          if (_showConfetti)
            ConfettiOverlay(
              onComplete: () {
                setState(() {
                  _showConfetti = false;
                });
              },
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateHabitModal(context, ref);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                child: Icon(
                  Icons.add_circle_outline,
                  size: 60,
                  color: AppTheme.primaryGreen,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Ещё нет привычек',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Нажми на кнопку «+» внизу,\nчтобы создать первую привычку\nи начать отслеживать прогресс',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.secondaryText,
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.primaryGreen,
                  width: 1,
                ),
              ),
              child: const Text(
                '💡 Совет: Начни с одной привычки и добавляй новые\nкогда почувствуешь уверенность!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.accentGreen,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateHabitModal(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateHabitScreen(
        onHabitCreated: () {
          Navigator.pop(context);
          // Запустить анимацию конфетти
          setState(() {
            _showConfetti = true;
          });
        },
      ),
    );
  }

  DateTime _getStartDate(DateTime now) {
    final daysToMonday = now.weekday - 1;
    return now.subtract(Duration(days: daysToMonday));
  }

  void _showUnmarkConfirmation(
    BuildContext context,
    WidgetRef ref,
    String habitId,
    int dayIndex,
  ) {
    final now = DateTime.now();
    final startDate = _getStartDate(now);
    final targetDate = startDate.add(Duration(days: dayIndex));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Отменить отметку?'),
        content: const Text('Вы уверены, что хотите отменить отметку за этот день?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(habitsProvider.notifier)
                  .unmarkHabitCompleted(habitId, targetDate);
              Navigator.pop(context);
            },
            child: const Text(
              'Отменить',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

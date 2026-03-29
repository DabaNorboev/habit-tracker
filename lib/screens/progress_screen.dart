import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/progress_bar.dart';

class ProgressScreen extends ConsumerWidget {
  final String habitId;

  const ProgressScreen({Key? key, required this.habitId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habit = ref.watch(habitProvider(habitId));

    if (habit == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Не найдено'),
        ),
        body: const Center(
          child: Text('Привычка не найдена'),
        ),
      );
    }

    final completion = habit.getCompletionPercentage();
    final daysInPeriod = habit.period == 'week' ? 7 : 30;

    return Scaffold(
      appBar: AppBar(
        title: Text('${habit.emoji} ${habit.name}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Основная шкала
          Card(
            color: AppTheme.darkCardBackground,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Прогресс этого периода',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.lightText,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      height: 60,
                      child: ProgressBar(
                        completionMap: habit.completionMap,
                        scheduledDays: habit.scheduledDays,
                        daysInPeriod: daysInPeriod,
                        onDayTapped: (dayIndex) {
                          ref
                              .read(habitsProvider.notifier)
                              .markHabitCompleted(habitId, DateTime.now());
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Процент выполнения: $completion%',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Статистика
          Card(
            color: AppTheme.darkCardBackground,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Статистика',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.lightText,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildStatRow('Текущий стрик', '${habit.streak} дней', '🔥'),
                  const SizedBox(height: 12),
                  _buildStatRow('Выполнений', '${habit.completionMap.values.where((v) => v).length} дней', '✅'),
                  const SizedBox(height: 12),
                  _buildStatRow('Всего очков', '${habit.totalScore}', '⭐'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Бейджи (достижения)
          if (_hasBadges(habit))
            Card(
              color: AppTheme.darkCardBackground,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Достижения',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.lightText,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        if (habit.streak >= 7)
                          _buildBadge('🔥 Fire Streak', '7+ дней подряд'),
                        if (habit.completionMap.length >= 7)
                          _buildBadge('⭐ First Week', 'Первая неделя'),
                        if (habit.totalScore >= 300)
                          _buildBadge('🏆 Perfect', '300+ очков'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 20),

          // Описание (если есть)
          if (habit.description != null && habit.description!.isNotEmpty)
            Card(
              color: AppTheme.darkCardBackground,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Описание',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.lightText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      habit.description!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 20),

          // Кнопка удаления
          ElevatedButton(
            onPressed: () {
              _showDeleteDialog(context, ref, habitId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
            ),
            child: const Text('Удалить привычку'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, String emoji) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.lightText,
          ),
        ),
        Row(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppTheme.accentGreen,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBadge(String title, String description) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.primaryGreen,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppTheme.accentGreen,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            description,
            style: const TextStyle(
              fontSize: 10,
              color: AppTheme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  bool _hasBadges(Habit habit) {
    return habit.streak >= 7 ||
        habit.completionMap.length >= 7 ||
        habit.totalScore >= 300;
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, String habitId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить привычку?'),
        content: const Text('Весь прогресс будет потерян.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              ref.read(habitsProvider.notifier).deleteHabit(habitId);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              'Удалить',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

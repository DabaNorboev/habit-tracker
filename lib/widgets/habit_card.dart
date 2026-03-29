import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../theme/app_theme.dart';
import 'progress_bar.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final int index;
  final Function(Habit) onTap;
  final Function(String, int)? onDayTapped;
  final Function(String, int)? onDayLongPressed;

  const HabitCard({
    Key? key,
    required this.habit,
    required this.index,
    required this.onTap,
    this.onDayTapped,
    this.onDayLongPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundColor = AppTheme.getCardColor(index);
    final daysInPeriod = habit.period == 'week' ? 7 : 30;
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final yesterdayStr =
        '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';
    final isYesterdayCompleted = habit.completionMap[yesterdayStr] ?? false;
    final showYesterdayButton = !isYesterdayCompleted;

    return GestureDetector(
      onTap: () => onTap(habit),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Заголовок с эмодзи
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Text(
                        habit.emoji,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              habit.name,
                              style: const TextStyle(
                                color: Color(0xFF2D2D2D),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (habit.description != null &&
                                habit.description!.isNotEmpty)
                              Text(
                                habit.description!,
                                style: const TextStyle(
                                  color: Color(0xFF666666),
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (habit.streak > 0)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE67E22).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🔥', style: TextStyle(fontSize: 12)),
                        const SizedBox(width: 4),
                        Text(
                          '${habit.streak}',
                          style: const TextStyle(
                            color: Color(0xFFE67E22),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // Прогресс-бар
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                height: 50,
                child: ProgressBar(
                  completionMap: habit.completionMap,
                  scheduledDays: habit.scheduledDays,
                  daysInPeriod: daysInPeriod,
                  onDayTapped: (dayIndex) {
                    if (onDayTapped != null) {
                      onDayTapped!(habit.id, dayIndex);
                    }
                  },
                  onDayLongPressed: (dayIndex) {
                    if (onDayLongPressed != null) {
                      onDayLongPressed!(habit.id, dayIndex);
                    }
                  },
                ),
              ),
            ),
            // Кнопка "Отметить за вчера"
            if (showYesterdayButton)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: ElevatedButton(
                    onPressed: () {
                      if (onDayTapped != null) {
                        onDayTapped!(habit.id, -1); // -1 означает вчера
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.disabledGray,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: const Text(
                      'Вчера',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

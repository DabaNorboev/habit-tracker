import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ProgressBar extends StatefulWidget {
  final Map<String, bool> completionMap;
  final List<String> scheduledDays;
  final Function(int)? onDayTapped;
  final Function(int)? onDayLongPressed;
  final int daysInPeriod;

  const ProgressBar({
    Key? key,
    required this.completionMap,
    required this.scheduledDays,
    this.onDayTapped,
    this.onDayLongPressed,
    this.daysInPeriod = 7,
  }) : super(key: key);

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startDate = _getStartDate(now);

    return Column(
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 12,
          children: List.generate(widget.daysInPeriod, (index) {
            final date = startDate.add(Duration(days: index));
            final dateStr =
                '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
            final isCompleted = widget.completionMap[dateStr] ?? false;
            final isToday = _isSameDay(date, now);

            return GestureDetector(
              onTap: () {
                widget.onDayTapped?.call(index);
              },
              onLongPress: () {
                if (isCompleted) {
                  widget.onDayLongPressed?.call(index);
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppTheme.successGreen
                          : AppTheme.disabledGray,
                      borderRadius: BorderRadius.circular(3),
                      border: isToday
                          ? Border.all(
                              color: const Color(0xFFF1C40F),
                              width: 2,
                            )
                          : null,
                    ),
                    child: isCompleted
                        ? const Center(
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 8,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _getDayLabel(date),
                    style: const TextStyle(
                      color: AppTheme.secondaryText,
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  DateTime _getStartDate(DateTime now) {
    final daysToMonday = now.weekday - 1;
    return now.subtract(Duration(days: daysToMonday));
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _getDayLabel(DateTime date) {
    final days = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    return days[date.weekday - 1];
  }
}

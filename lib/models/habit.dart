import 'package:hive/hive.dart';

part 'habit.g.dart';

@HiveType(typeId: 0)
class Habit extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  String? description;

  @HiveField(3)
  late String emoji;

  @HiveField(4)
  late String period; // 'week' или 'month'

  @HiveField(5)
  late List<String> scheduledDays; // ['Mon', 'Tue', ...]

  @HiveField(6)
  late DateTime createdAt;

  @HiveField(7)
  late int streak;

  @HiveField(8)
  late int totalScore;

  @HiveField(9)
  late Map<String, bool> completionMap; // date -> isCompleted

  @HiveField(10)
  late String userId; // ID пользователя, которому принадлежит привычка

  Habit({
    required this.id,
    required this.name,
    this.description,
    required this.emoji,
    required this.period,
    required this.scheduledDays,
    required this.createdAt,
    this.streak = 0,
    this.totalScore = 0,
    Map<String, bool>? completionMap,
    required this.userId,
  }) {
    this.completionMap = completionMap ?? {};
  }

  // Получить процент выполнения
  int getCompletionPercentage() {
    if (completionMap.isEmpty) return 0;
    final completed = completionMap.values.where((v) => v).length;
    return ((completed / completionMap.length) * 100).toInt();
  }

  // Проверить, выполнена ли привычка в конкретный день
  bool isCompletedOnDate(DateTime date) {
    final dateStr = _formatDateForMap(date);
    return completionMap[dateStr] ?? false;
  }

  // Отметить день как выполненный
  void markCompleted(DateTime date) {
    final dateStr = _formatDateForMap(date);
    completionMap[dateStr] = true;
    totalScore += 10;
    _updateStreak();
  }

  // Отметить день как невыполненный
  void unmarkCompleted(DateTime date) {
    final dateStr = _formatDateForMap(date);
    completionMap[dateStr] = false;
    _updateStreak();
  }

  // Рассчитать стрик
  void _updateStreak() {
    int currentStreak = 0;
    DateTime current = DateTime.now();

    while (true) {
      if (isScheduledForDay(current) && isCompletedOnDate(current)) {
        currentStreak++;
        current = current.subtract(Duration(days: 1));
      } else {
        break;
      }
    }

    streak = currentStreak;
  }

  // Проверить, запланирована ли привычка на этот день
  bool isScheduledForDay(DateTime date) {
    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final dayIndex = date.weekday - 1;
    return scheduledDays.contains(dayNames[dayIndex]);
  }

  static String _formatDateForMap(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

import 'package:hive/hive.dart';

part 'habit_entry.g.dart';

@HiveType(typeId: 1)
class HabitEntry extends HiveObject {
  @HiveField(0)
  late String habitId;

  @HiveField(1)
  late DateTime date;

  @HiveField(2)
  late bool isCompleted;

  HabitEntry({
    required this.habitId,
    required this.date,
    required this.isCompleted,
  });
}

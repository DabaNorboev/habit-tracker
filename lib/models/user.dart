import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String email;

  @HiveField(2)
  late String passwordHash;

  @HiveField(3)
  late String name;

  @HiveField(4)
  late DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.passwordHash,
    required this.name,
    required this.createdAt,
  });

  @override
  String toString() => 'User(id: $id, email: $email, name: $name)';
}

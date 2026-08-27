import 'package:hive/hive.dart';

part 'habit.g.dart';

@HiveType(typeId: 0)
class Habit {

  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  Habit({required this.id, required this.name});
}
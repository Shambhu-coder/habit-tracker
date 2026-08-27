import 'package:hive_flutter/hive_flutter.dart';

part 'completion.g.dart';

@HiveType(typeId: 1)
class Completion extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String habitId;

  @HiveField(2)
  DateTime date;

  Completion({required this.id, required this.habitId, required this.date});
}
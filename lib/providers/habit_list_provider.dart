import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:hive/hive.dart';

class HabitListNotifier extends StateNotifier<List<Habit>> {
  final Box<Habit> habitBox;

  HabitListNotifier(this.habitBox) : super(habitBox.values.toList());

  void addHabit(String name) {
    final habit = Habit(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
    );
    habitBox.put(habit.id, habit);
    state = [...state, habit];
  }

  void removeHabit(String id) {
    habitBox.delete(id);
    state = state.where((h) => h.id != id).toList();
  }
}

final habitListProvider = StateNotifierProvider<HabitListNotifier, List<Habit>>(
  (ref) => HabitListNotifier(Hive.box<Habit>('habits')),
);

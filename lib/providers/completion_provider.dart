import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/models/completion.dart';
import 'package:hive/hive.dart';

class CompletionNotifier extends StateNotifier<List<Completion>> {
  final Box<Completion> completionBox;

  CompletionNotifier(this.completionBox) : super(completionBox.values.toList());

  bool isCompletedOn(String habitId, DateTime date) {
    return state.any((c) => 
      c.habitId == habitId &&
      c.date.year == date.year && 
      c.date.month == date.month && 
      c.date.day == date.day);
  }

  void toggleCompletion(String habitId, DateTime date) {
    final key = _keyFor(habitId, date);
    final exists = isCompletedOn(habitId, date);

    if(exists) {
      completionBox.delete(key);
      state = state.where((c) => _keyFor(c.habitId, c.date) != key).toList();
    } else {
      final completion = Completion(id: key, habitId: habitId, date: date);
      completionBox.put(key, completion);
      state = [...state, completion];
    }
  }

  String _keyFor(String habitId, DateTime date) {
    return '${habitId}_${date.year}-${date.month}-${date.day}';
  }
}

final completionProvider = StateNotifierProvider<CompletionNotifier, List<Completion>>(
  (ref) => CompletionNotifier(Hive.box<Completion>('completions')),
);
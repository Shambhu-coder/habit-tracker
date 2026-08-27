import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/providers/completion_provider.dart';

final habitStreakProvider = Provider.family<int, String>((ref, habitId) {
  final completions = ref.watch(completionProvider);

  final habitCompletions = completions
    .where((c) => c.habitId == habitId)
    .map((c) => DateTime(c.date.year, c.date.month, c.date.day))
    .toSet();

  int streak = 0;
  DateTime checkDate = DateTime.now();
  checkDate = DateTime(checkDate.year, checkDate.month, checkDate.day);

  while (habitCompletions.contains(checkDate)) {
    streak++;
    checkDate = checkDate.subtract(const Duration(days: 1));
  }

  return streak;
});
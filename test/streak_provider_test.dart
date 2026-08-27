// test/streak_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_test/hive_test.dart';
import 'package:hive/hive.dart';
import 'package:habit_tracker/models/completion.dart';
import 'package:habit_tracker/providers/completion_provider.dart';
import 'package:habit_tracker/providers/streak_provider.dart';

void main() {
  late ProviderContainer container;

  setUp(() async {
    await setUpTestHive();
    Hive.registerAdapter(CompletionAdapter());
    await Hive.openBox<Completion>('completions');

    container = ProviderContainer(); // fresh, isolated Riverpod environment
  });

  tearDown(() async {
    container.dispose(); // clean up the container itself
    await tearDownTestHive();
  });

  test('streak is 0 when no completions exist', () {
    final streak = container.read(habitStreakProvider('habit1'));
    expect(streak, 0);
  });

  test('streak counts consecutive days correctly', () {
    final notifier = container.read(completionProvider.notifier);
    final today = DateTime.now();

    // Mark today AND yesterday complete for habit1
    notifier.toggleCompletion('habit1', today);
    notifier.toggleCompletion('habit1', today.subtract(const Duration(days: 1)));

    final streak = container.read(habitStreakProvider('habit1'));
    expect(streak, 2);
  });

  test('streak stops at a gap', () {
    final notifier = container.read(completionProvider.notifier);
    final today = DateTime.now();

    // Complete today, but SKIP yesterday, complete 2 days ago
    notifier.toggleCompletion('habit1', today);
    notifier.toggleCompletion('habit1', today.subtract(const Duration(days: 2)));

    final streak = container.read(habitStreakProvider('habit1'));
    expect(streak, 1); // only today counts — yesterday's gap breaks the streak
  });

  test('different habits have independent streaks', () {
    final notifier = container.read(completionProvider.notifier);
    final today = DateTime.now();

    notifier.toggleCompletion('habit1', today);
    // habit2 has NO completions

    expect(container.read(habitStreakProvider('habit1')), 1);
    expect(container.read(habitStreakProvider('habit2')), 0);
  });
}
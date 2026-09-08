import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/providers/completion_provider.dart';
import 'package:habit_tracker/providers/habit_list_provider.dart';
import 'package:habit_tracker/providers/streak_provider.dart';

class HabitListScreen extends ConsumerStatefulWidget {
  const HabitListScreen({super.key});

  @override
  ConsumerState<HabitListScreen> createState() => _HabitListScreenState();
}

class _HabitListScreenState extends ConsumerState<HabitListScreen> {
  final habitNameController = TextEditingController();

  @override
  void dispose() {
    habitNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final habits = ref.watch(habitListProvider);
    final completionNotifier = ref.read(completionProvider.notifier);
    ref.watch(completionProvider);

    return (Scaffold(
      appBar: AppBar(title: Text('Habits ')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                controller: habitNameController,
                decoration: InputDecoration(
                  hintText: 'Enter new habit here...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (habitNameController.text.trim().isNotEmpty) {
                  ref
                      .read(habitListProvider.notifier)
                      .addHabit(habitNameController.text);
                  habitNameController.clear();
                }
              },
              child: Text('Add Habit'),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: habits.length,
                itemBuilder: (context, index) {
                  final habit = habits[index];
                  final streak = ref.watch(habitStreakProvider(habit.id));
                  final isDone = completionNotifier.isCompletedOn(
                    habit.id,
                    DateTime.now(),
                  );

                  return Container(
                    padding: EdgeInsets.only(left: 12.0, right: 8.0),
                    margin: EdgeInsets.only(bottom: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    child: (Row(
                      children: [
                        Checkbox(
                          value: isDone,
                          onChanged: (_) => completionNotifier.toggleCompletion(
                            habit.id,
                            DateTime.now(),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            habit.name,
                            style: TextStyle(
                              color: Colors.black,
                              decoration: isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                        ),
                        Text('🔥 $streak day streak'),
                        IconButton(
                          onPressed: () {
                            ref
                                .read(habitListProvider.notifier)
                                .removeHabit(habit.id);
                          },
                          icon: Icon(Icons.delete, color: Colors.redAccent),
                        ),
                      ],
                    )),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

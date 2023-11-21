import 'package:flutter/material.dart';
import 'package:workout_app/views/workout/workout_add_modal.dart';
import 'package:workout_app/views/workout/workout_delete_modal.dart';
import 'package:workout_model/workout_model.dart';

class WorkoutView extends StatefulWidget {
  const WorkoutView({super.key});

  @override
  State<WorkoutView> createState() => _WorkoutViewState();
}

class _WorkoutViewState extends State<WorkoutView> {
  var exerciseDescriptionFuture = ExerciseDescriptionRepository.instance.list();
  var exerciseFuture = ExerciseRepository.instance.list();
  var workoutFuture = WorkoutRepository.instance.list();

  void updateList() {
    setState(() {
      workoutFuture = WorkoutRepository.instance.list();
    });
  }

  void createWorkout({
    required String name,
    required String description,
  }) {
    final workout = Workout(name: name, description: description);
    WorkoutRepository.instance.create(workout);
    updateList();
  }

  void deleteWorkout(String id) async {
    await WorkoutRepository.instance.delete(id);
    updateList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: workoutFuture,
        builder: (context, snapshot) {
          final result = snapshot.data;

          if (result != null) {
            return Scaffold(
              body: ListView.builder(
                itemCount: result.length,
                itemBuilder: (context, index) {
                  final workout = result[index];
                  return ListTile(
                    onTap: () {},
                    // TODO: Open detailed workout view,
                    //
                    title: Text(workout.name),
                    subtitle: Text(workout.description),
                    tileColor: index % 2 == 0
                        ? Theme.of(context).colorScheme.onTertiary
                        : Theme.of(context).colorScheme.onInverseSurface,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return WorkoutDeleteModal(
                              id: workout.id,
                              deleteWorkout: deleteWorkout,
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    useSafeArea: true,
                    isScrollControlled: true,
                    context: context,
                    constraints:
                        const BoxConstraints(maxWidth: double.infinity),
                    builder: (BuildContext context) {
                      return WorkoutAddModal(
                        createWorkout: createWorkout,
                      );
                    },
                  );
                },
                child: const Icon(Icons.add),
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error'),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}

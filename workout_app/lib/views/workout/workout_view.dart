import 'package:flutter/material.dart';
import 'package:workout_app/views/workout/workout_add_modal.dart';
import 'package:workout_app/views/workout/workout_delete_modal.dart';
import 'package:workout_app/views/workout/workout_detailed.dart';
import 'package:workout_model/workout_model.dart';

// TODO: Add some filtering or something completed, not started... workouts

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
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Empty'),
                  );
                } else {
                  final workout = result[index];
                  return Container(
                    decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide())),
                    child: ListTile(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                WorkoutDetailed(workout: workout),
                          ),
                        );
                        updateList();
                      },
                      title: Text(workout.name),
                      subtitle: Text(workout.status.name.toString()),
                      tileColor: workout.status == WorkoutStatus.completed
                          ? Colors.green[200]
                          : workout.status == WorkoutStatus.paused
                              ? Colors.amber[200]
                              : workout.status == WorkoutStatus.notStarted
                                  ? Colors.orange[200]
                                  : Colors.yellow[200],
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
                    ),
                  );
                }
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  useSafeArea: true,
                  isScrollControlled: true,
                  context: context,
                  constraints: const BoxConstraints(maxWidth: double.infinity),
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
        } else {
          return const Center(
            child: Text('Something went wrong'),
          );
        }
      },
    );
  }
}

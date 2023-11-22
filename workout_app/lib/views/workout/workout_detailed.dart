import 'package:flutter/material.dart';
import 'package:workout_app/views/workout/workout_add_exercise.dart';
import 'package:workout_model/workout_model.dart';

class WorkoutDetailed extends StatefulWidget {
  const WorkoutDetailed({
    super.key,
    required this.workout,
  });

  final Workout workout;

  @override
  State<WorkoutDetailed> createState() => _WorkoutDetailedState();
}

class _WorkoutDetailedState extends State<WorkoutDetailed> {
  bool workoutStatus = false;

  @override
  Widget build(BuildContext context) {
    final exerciseList = widget.workout.exercises;

    void addExerciseToWorkout() async {
      final exercise = await Navigator.of(context).push<Exercise>(
        MaterialPageRoute(
          builder: (ctx) => WorkoutAddExercise(),
        ),
      );
      if (exercise == null) {
        return;
      }

      setState(() {
        exerciseList.add(exercise);
        WorkoutRepository.instance
            .update(workout: widget.workout, exercises: exerciseList);
      });
    }

    return Hero(
      tag: widget.workout.name,
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.workout.name),
            actions: [
              IconButton(
                onPressed: addExerciseToWorkout,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          body: widget.workout.exercises.isEmpty
              ? const Center(child: Text('Empty'))
              : ListView.builder(
                  itemCount: widget.workout.exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = widget.workout.exercises[index];
                    // Change to card or something better to show all info
                    //
                    // Dissmissable?
                    // How should list look like?
                    return Dismissible(
                      background: Container(
                        color: Colors.grey[200],
                      ),
                      key: ValueKey<int>(index),
                      child: Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(exercise.name),
                                Text(exercise.description),
                              ],
                            ),
                            Column(
                              children: [
                                Text('Weight: ${exercise.weight}'),
                                Text('Reps: ${exercise.repetitions}'),
                                Text('Sets: ${exercise.sets}'),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  FloatingActionButton(
                    heroTag: null,
                    onPressed: () {
                      // TODO: Stop workout
                      //
                    },
                    child: const Icon(Icons.stop),
                  ),
                  FloatingActionButton(
                    heroTag: null,
                    onPressed: () {
                      // TODO: start/resume workout
                      //
                    },
                    child: const Icon(Icons.play_arrow),
                  ),
                  FloatingActionButton(
                    heroTag: null,
                    onPressed: () {
                      // TODO: pause workout
                      //
                    },
                    child: const Icon(Icons.pause),
                  ),
                ],
              ))),
    );
  }
}
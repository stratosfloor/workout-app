import 'dart:io';

import 'package:flutter/material.dart';
import 'package:workout_app/views/workout/workout_add_exercise.dart';
import 'package:workout_app/views/workout/workout_set_performence.dart';
import 'package:workout_model/workout_model.dart';

class WorkoutDetailed extends StatefulWidget {
  WorkoutDetailed({
    super.key,
    required this.workout,
  });

  Workout workout;

  @override
  State<WorkoutDetailed> createState() => _WorkoutDetailedState();
}

class _WorkoutDetailedState extends State<WorkoutDetailed> {
  late List<Exercise> exerciseList;
  late WorkoutStatus status;

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

  void removeExerciseFromWorkout({required Exercise exercise}) async {
    final index = exerciseList.indexOf(exercise);

    setState(() {
      exerciseList.remove(exercise);
    });

    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Item removed'),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                exerciseList.insert(index, exercise);
                return;
              });
            }),
      ),
    );
    WorkoutRepository.instance
        .update(workout: widget.workout, exercises: exerciseList);
  }

  void startWorkout() async {
    setState(() {
      status = WorkoutStatus.started;
    });
    widget.workout = await WorkoutRepository.instance
        .updateStatus(workout: widget.workout, status: WorkoutStatus.started);
  }

  void pausWorkout() async {
    setState(() {
      status = WorkoutStatus.paused;
    });
    widget.workout = await WorkoutRepository.instance
        .updateStatus(workout: widget.workout, status: WorkoutStatus.paused);
  }

  void resetWorkout() async {
    setState(() {
      status = WorkoutStatus.notStarted;
    });
    widget.workout = await WorkoutRepository.instance.updateStatus(
        workout: widget.workout, status: WorkoutStatus.notStarted);
  }

  void completeWorkout() async {
    for (var i = 0; i < exerciseList.length; i++) {
      if (exerciseList[i].performence == null) {
        showDialog(
          context: context,
          builder: (BuildContext context) => const AlertDialog(
            title: Text(
              'You must set performence of all exercises to complete workout',
            ),
          ),
        );
        return;
      }
    }

    setState(() {
      status = WorkoutStatus.completed;
    });
    widget.workout = await WorkoutRepository.instance
        .updateStatus(workout: widget.workout, status: WorkoutStatus.completed);
  }

  void setPerformence(Exercise exercise) async {
    final index = exerciseList.indexOf(exercise);

    final performence = await Navigator.of(context).push<double>(
      MaterialPageRoute(
        builder: (ctx) => WorkoutSetPetformenceModal(exercise: exercise),
      ),
    );

    if (performence != null) {
      print(performence);
    }

    exercise.performence = performence;

    setState(() {
      exerciseList.remove(exercise);
      exerciseList.insert(index, exercise);
      WorkoutRepository.instance
          .update(workout: widget.workout, exercises: exerciseList);
    });
  }

  @override
  Widget build(BuildContext context) {
    exerciseList = widget.workout.exercises;
    status = widget.workout.status;

    return Scaffold(
      appBar: AppBar(
        title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(widget.workout.name),
              Expanded(
                child: Center(
                    child: Text(status.toString(),
                        style: const TextStyle(fontSize: 10))),
              ),
            ]),
        actions: [
          status == WorkoutStatus.notStarted
              ? IconButton(
                  onPressed: addExerciseToWorkout,
                  icon: Icon(
                    Icons.add_box,
                    color: Theme.of(context).colorScheme.primary,
                    grade: 20,
                    size: 32,
                  ),
                )
              : IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.add_box,
                    color: Theme.of(context).colorScheme.secondary,
                    grade: 10,
                    size: 20,
                  ),
                )
        ],
      ),
      body: widget.workout.exercises.isEmpty
          ? const Center(child: Text('Empty'))
          : ListView.builder(
              itemCount: widget.workout.exercises.length,
              itemBuilder: (context, index) {
                final exercise = widget.workout.exercises[index];
                return Dismissible(
                  key: UniqueKey(),
                  // Cant dismiss exercise uncless not started workout
                  direction: status == WorkoutStatus.notStarted
                      ? DismissDirection.horizontal
                      : DismissDirection.none,
                  onDismissed: (direction) {
                    removeExerciseFromWorkout(exercise: exercise);
                  },
                  background: Card(
                    color: Colors.red[50],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      status != WorkoutStatus.started
                          ? null
                          : setPerformence(exercise);
                    },
                    child: Card(
                      child: Column(
                        children: [
                          Row(
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
                          Column(
                            children: [
                              Text(
                                  'Performence: ${exercise.performence ?? ''} %'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // STOP // RESTART WORKOUT
            FloatingActionButton(
              heroTag: null,
              onPressed: status == WorkoutStatus.started ||
                      status == WorkoutStatus.paused
                  ? resetWorkout
                  : null,
              child: Icon(
                Icons.restart_alt,
                color: status == WorkoutStatus.started ||
                        status == WorkoutStatus.paused
                    ? Colors.black87
                    : Colors.black12,
              ),
            ),

            // START // RESUME WORKOUT
            FloatingActionButton(
              heroTag: null,
              onPressed: status == WorkoutStatus.notStarted ||
                      status == WorkoutStatus.paused
                  ? startWorkout
                  : null,
              child: Icon(
                Icons.play_arrow,
                color: status == WorkoutStatus.notStarted ||
                        status == WorkoutStatus.paused
                    ? Colors.black87
                    : Colors.black12,
              ),
            ),

            // PAUSE WORKOUT
            FloatingActionButton(
              heroTag: null,
              onPressed: status == WorkoutStatus.started ? pausWorkout : null,
              //
              child: Icon(Icons.pause,
                  color: status == WorkoutStatus.started
                      ? Colors.black87
                      : Colors.black12),
            ),

            // COMPLETE WORKOUT
            FloatingActionButton(
              heroTag: null,
              onPressed: status == WorkoutStatus.started ||
                      status == WorkoutStatus.paused
                  ? completeWorkout
                  : null,
              child: Icon(Icons.done,
                  color: status == WorkoutStatus.started ||
                          status == WorkoutStatus.paused
                      ? Colors.black87
                      : Colors.black12),
            ),
          ],
        ),
      ),
    );
  }
}

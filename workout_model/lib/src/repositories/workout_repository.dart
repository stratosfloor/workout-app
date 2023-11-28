import 'dart:io';

import 'package:hive/hive.dart';
import 'package:workout_model/src/interfaces/workout_interface.dart';

import '../models/exercise_model.dart';
import '../models/workout_model.dart';

class WorkoutRepository implements IWorkoutRepository<Workout> {
  late Box _workoutBox;

  WorkoutRepository() {
    Directory directory = Directory.current;
  }

  WorkoutRepository._();

  static final WorkoutRepository _instance = WorkoutRepository._();

  static WorkoutRepository get instance {
    return _instance;
  }

  Future<void> initalize({required String filePath}) async {
    Hive.init(filePath);
    if (!Hive.isBoxOpen('workouts')) {
      _workoutBox = await Hive.openBox('workouts');
    }
    print('Box is open');
  }

  @override
  Future<Workout?> create(Workout workout) async {
    if (!Hive.isBoxOpen('workouts')) {
      throw StateError('Please await WorkoutRepository initalize method');
    }
    var exisitingWorkout = _workoutBox.get(workout.id);
    if (exisitingWorkout != null) {
      return Future.value(null);
    }
    _workoutBox.put(workout.id, workout.serialize());
    return workout;
  }

  // TODO: serialize array of exercises
  @override
  Future<Workout?> read(String id) async {
    var serialized = _workoutBox.get(id);
    return serialized != null ? Workout.deserialize(serialized) : null;
  }

  // TODO: Should add/remove exercises be here?
  //
  @override
  Future<Workout?> update({
    required Workout workout,
    String? name,
    String? description,
    List<Exercise>? exercises,
    WorkoutStatus? status,
    // TODO: add list of exercises here and add add/remove exercise as method in manager
  }) async {
    var existingWorkout = _workoutBox.get(workout.id);
    if (existingWorkout == null) {
      throw Exception('Workout not found');
    }
    final newWorkout = Workout(
      id: workout.id,
      name: name ?? workout.name,
      description: description ?? workout.description,
      exercises: exercises ?? workout.exercises,
      status: status ?? workout.status,
    );
    _workoutBox.put(workout.id, newWorkout.serialize());
    return newWorkout;
  }

  Future<Workout> updateStatus({
    required Workout workout,
    required WorkoutStatus status,
  }) async {
    var existingWorkout = _workoutBox.get(workout.id);
    if (existingWorkout == null) {
      throw Exception('Workout not found');
    }

    final newWorkout = Workout(
      id: workout.id,
      name: workout.name,
      description: workout.description,
      exercises: workout.exercises,
      status: status,
    );
    await _workoutBox.put(workout.id, newWorkout.serialize());
    return newWorkout;
  }

  @override
  Future<bool> delete(String id) {
    var existingWorkout = _workoutBox.get(id);
    if (existingWorkout != null) {
      _workoutBox.delete(id);
      return Future.value(true);
    }
    return Future.value(false);
  }

  @override
  Future<void> clear() async {
    await _workoutBox.clear();
  }

  @override
  Future<List<Workout>> list() async => _workoutBox.values
      .map((serialized) => Workout.deserialize(serialized))
      .toList();
}

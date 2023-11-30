import 'dart:io';

import 'package:workout_model/src/interfaces/exercise_interface.dart';
import 'package:workout_model/src/models/exercise_model.dart';
import 'package:hive/hive.dart';

class ExerciseRepository implements IExceriseRepository<Exercise> {
  late Box _exerciseBox;

  ExerciseRepository() {
    Directory directory = Directory.current;
    // Hive.initFlutter(directory.path);
  }

  ExerciseRepository._();

  static final ExerciseRepository _instance = ExerciseRepository._();

  static ExerciseRepository get instance {
    return _instance;
  }

  Future<void> initalize({required String filePath}) async {
    Hive.init(filePath);
    if (!Hive.isBoxOpen('exercises')) {
      _exerciseBox = await Hive.openBox<String>('exercises');
    }
    print('Box is open');
  }

  @override
  Future<bool> create(Exercise exercise) async {
    if (!Hive.isBoxOpen('exercises')) {
      // _exerciseBox =  Hive.openBox('exercises');
      throw StateError('Please await ExerciseRepository initalize method');
    }
    var existingExercise = await _exerciseBox.get(exercise.id);
    if (existingExercise != null) {
      return Future.value(false);
    }
    _exerciseBox.put(exercise.id, exercise.serialize());
    return Future.value(true);
  }

  @override
  Future<Exercise?> read(String id) async {
    var serialized = _exerciseBox.get(id);
    return await serialized != null ? Exercise.deserialize(serialized) : null;
  }

  @override
  Future<Exercise> update({
    required Exercise exercise,
    String? name,
    String? description,
    int? repetitions,
    int? restTime,
    int? sets,
    double? weight,
    double? performence,
  }) async {
    var existingExercise = await _exerciseBox.get(exercise.id);
    if (existingExercise == null) {
      throw Exception('Exercise not found');
    }
    final newExercise = Exercise(
      name: name ?? exercise.name,
      description: description ?? exercise.description,
      repetitions: repetitions ?? exercise.repetitions,
      restTime: restTime ?? exercise.restTime,
      sets: sets ?? exercise.sets,
      weight: weight ?? exercise.weight,
      performence: performence ?? exercise.performence,
    );
    await _exerciseBox.put(exercise.id, newExercise.serialize());
    return newExercise;
  }

  @override
  Future<bool> delete(String id) {
    var existingExercise = _exerciseBox.get(id);
    if (existingExercise != null) {
      _exerciseBox.delete(id);
      return Future.value(true);
    }
    return Future.value(false);
  }

  @override
  Future<void> clear() async {
    await _exerciseBox.clear();
  }

  @override
  Future<List<Exercise>> list() async => _exerciseBox.values
      .map((serialized) => Exercise.deserialize(serialized))
      .toList();
}

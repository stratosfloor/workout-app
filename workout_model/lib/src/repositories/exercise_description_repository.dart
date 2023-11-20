import 'dart:io';

import 'package:hive/hive.dart';
import 'package:workout_model/src/interfaces/exercise_interface.dart';
import 'package:workout_model/src/models/exercise_description_model.dart';

class ExerciseDescriptionRepository
    implements IExerciseDescriptionRepository<ExerciseDescription> {
  late Box _exerciseDescriptionBox;

  ExerciseDescriptionRepository() {
    Directory directory = Directory.current;
  }

  ExerciseDescriptionRepository._();

  static final ExerciseDescriptionRepository _instance =
      ExerciseDescriptionRepository._();

  static ExerciseDescriptionRepository get instance {
    return _instance;
  }

  Future<void> initalize({required String filePath}) async {
    Hive.init(filePath);
    if (!Hive.isBoxOpen('exercises-desc')) {
      _exerciseDescriptionBox = await Hive.openBox('exercises-desc');
    }
    print('Box is open');
  }

  @override
  Future<bool> create(ExerciseDescription exercise) async {
    if (!Hive.isBoxOpen('exercises-desc')) {
      throw StateError(
          'Please await ExerciseDescriptionRepository initalize method');
    }
    var existingExercise = _exerciseDescriptionBox.get(exercise.id);
    if (existingExercise != null) {
      return Future.value(false);
    }
    _exerciseDescriptionBox.put(exercise.id, exercise.serialize());
    return Future.value(true);
  }

  @override
  Future<ExerciseDescription?> read(String id) async {
    var serialized = _exerciseDescriptionBox.get(id);
    return serialized != null
        ? ExerciseDescription.deserialize(serialized)
        : null;
  }

  @override
  ExerciseDescription update(
    ExerciseDescription exerciseDescription,
    String? name,
    String? description,
  ) {
    var existingExercise = _exerciseDescriptionBox.get(exerciseDescription.id);
    if (existingExercise == null) {
      throw Exception('Exercise not found');
    }
    final newExercise = ExerciseDescription(
      name: name ?? exerciseDescription.name,
      description: description ?? exerciseDescription.description,
    );
    _exerciseDescriptionBox.put(
        exerciseDescription.id, newExercise.serialize());
    return newExercise;
  }

  @override
  Future<bool> delete(String id) {
    var existingExercise = _exerciseDescriptionBox.get(id);
    if (existingExercise != null) {
      _exerciseDescriptionBox.delete(id);
      return Future.value(true);
    }
    return Future.value(false);
  }

  @override
  void clear() {
    _exerciseDescriptionBox.clear();
  }

  @override
  Future<List<ExerciseDescription>> list() async =>
      _exerciseDescriptionBox.values
          .map((serialized) => ExerciseDescription.deserialize(serialized))
          .toList();
}

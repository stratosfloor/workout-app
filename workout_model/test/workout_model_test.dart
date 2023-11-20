import 'dart:io';

import 'package:test/test.dart';

import 'dart:convert';
import 'package:workout_model/src/models/exercise_model.dart';
import 'package:workout_model/src/models/workout_model.dart';
import 'package:workout_model/src/repositories/exercise_repository.dart';
import 'package:workout_model/src/repositories/workout_repository.dart';

void main() {
  group('Exercise model tests', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('Initalize Exercise ', () {
      final exercise = Exercise(
          id: 'test',
          name: 'name',
          description: 'description',
          repetitions: 10,
          restTime: 60,
          sets: 3,
          weight: 50);
      expect(exercise, isNotNull);
      expect(exercise.id, 'test');
    });

    test('Test uuid', () {
      final ex = Exercise(
          name: 'basic',
          description: 'basic',
          repetitions: 10,
          restTime: 60,
          sets: 3,
          weight: 50);
      expect(ex.id.length, 36);
    });

    test('Test serialize', () {
      final ex = Exercise(
          id: '01',
          name: 'basic',
          description: 'basic',
          repetitions: 10,
          restTime: 60,
          sets: 3,
          weight: 50);
      expect(
          ex.serialize(),
          jsonEncode({
            "id": "01",
            "name": "basic",
            "description": "basic",
            "repetitions": 10,
            "restTime": 60,
            "sets": 3,
            "weight": 50.0
          }));
    });
  });
  group('Exercise repository tests', () async {
    final ExerciseRepository repo = ExerciseRepository.instance;
    await repo.initalize(filePath: Directory.current.path);
    setUp(() {
      // Additional setup goes here.
    });

    test('Test create', () async {
      final exercise = Exercise(
          id: '4654654',
          name: 'Bänkpress',
          description: 'Pressa för faaan',
          repetitions: 10,
          restTime: 60,
          sets: 3,
          weight: 50);
      var res = await repo.create(exercise);
      expect(res, true);
    });

    test('Test read', () async {
      final res = await repo.read('4654654');
      expect(res, isNotNull);
      expect(res?.description, 'Pressa för faaan');
    });

    test('Test listing exercises', () async {
      final list = await repo.list();
      expect(list, isNotEmpty);
      expect(list.length, 1);
    });

    test('Test create 2', () async {
      await repo.create(Exercise(
          id: '01',
          name: 'bänkpress',
          description: 'description',
          repetitions: 10,
          restTime: 60,
          sets: 3,
          weight: 50));
      await repo.create(Exercise(
          id: '02',
          name: 'knäböj',
          description: 'description',
          repetitions: 10,
          restTime: 60,
          sets: 3,
          weight: 50));
      await repo.create(Exercise(
          id: '03',
          name: 'bicepscurl',
          description: 'description',
          repetitions: 10,
          restTime: 60,
          sets: 3,
          weight: 50));
      final list = await repo.list();
      expect(list, isNotNull);
      expect(list.length, 4);
    });

    test('Test create an exercise with existing id', () async {
      final list = await repo.list();
      expect(list, isNotNull);
      expect(list.length, 4);
      await repo.create(Exercise(
          id: '01',
          name: 'bänkpress',
          description: 'description',
          repetitions: 10,
          restTime: 60,
          sets: 3,
          weight: 50));
      expect(list.length, 4);
    });
    test('Test update', () async {
      final ex = await repo.read('01');
      final ex2 = await repo.update(exercise: ex!, name: 'situps');
      expect(ex2.name, 'situps');
    });

    test('Test delete', () async {
      await repo.create(Exercise(
          id: 'test',
          name: 'delete',
          description: 'the doctor must be deleted'));
      expect(await repo.read('test'), isNotNull);
      expect(await repo.delete('test'), true);
      expect(await repo.read('test'), isNull);
    });
  });
  group('Workout repo', () {
    final repo = WorkoutRepository.instance;
    repo.initalize(filePath: Directory.current.path);
    setUp(() {
      // Additional setup goes here.
    });
    test('Test workout model', () {
      final workout = Workout(name: 'name', description: 'description');
      expect(workout.name, 'name');
    });
    test('Test create returns workout', () async {
      final workout = await repo
          .create(Workout(name: 'Biffff', description: 'Kötta för faan'));
      expect(workout!.name, 'Biffff');
    });
    test('Test list() ', () async {
      final list = await repo.list();
      expect(list, isNotNull);
      expect(list, isNotEmpty);
    });
    // Här håller jag på
    test('Test read created workout', () async {
      final workout = await repo.create(
          Workout(name: 'Överkropp', description: 'Träna ööööverkropp'));
      final expectedWorkout = await repo.read(workout!.id);
      print(expectedWorkout?.serialize());
      expect(expectedWorkout is Workout, true);
      // expect(expectedWorkout?.name, 'Överkropp');
    });
  });

  // TODO: Tests for workout model, repository and manager
}

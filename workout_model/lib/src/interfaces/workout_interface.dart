import 'exercise_interface.dart';

enum WorkoutStatus {
  notStarted,
  paused,
  started,
  completed,
}

sealed class Identifiable {
  String get id;
}

abstract interface class IWorkout<T extends IExercise> extends Identifiable {
  String get name;
  String get description;
  List<T> get exercises;
  WorkoutStatus get status;
}

abstract interface class IWorkoutRepository<T extends IWorkout> {
  Future<T?> create(T workout);
  Future<T?> read(String id);
  Future<T?> update({required T workout, String? name, String? description});
  Future<bool> delete(String id);
  Future<void> clear();
  Future<List<T>> list();
}

abstract interface class IWorkoutManager<T extends IWorkout,
    V extends IExercise> {
  T? get currentWorkout;
  startWorkout(T workout);
  pausWorkout(T workout);
  resumeWorkout(T workout);
  addExerciseToWorkout(T workout, V exercise);
  removeExerciseFromWorkout(T workout, V exercise);
  /* Add performence field to IWorkout 
  {
    int? get performenceRepetitions;
    int? get performenceSets;
    double? get performenceWeight; 
  }
   */
  registerPerformance(T workout, V exercise);
  overviewWorkout(T workout);
  endWorkout(T workout);
}

import 'package:workout_model/src/interfaces/workout_interface.dart';
import 'package:workout_model/src/models/exercise_model.dart';
import 'package:workout_model/src/models/workout_model.dart';

class WorkoutManager implements IWorkoutManager<Workout, Exercise> {
  Workout? _currentWorkout;

  @override
  Workout? get currentWorkout => _currentWorkout;

  @override
  startWorkout(Workout workout) {}

  @override
  pausWorkout(Workout workout) {}

  @override
  resumeWorkout(Workout workout) {}

  @override
  addExerciseToWorkout(Workout workout, Exercise exercise) {}

  @override
  removeExerciseFromWorkout(Workout workout, Exercise exercise) {}
  /* TODO: Add performence field to Workout 
  {
    int? get performenceRepetitions;
    int? get performenceSets;
    double? get performenceWeight; 
  }
   */
  @override
  registerPerformance(Workout workout, Exercise exercise) {}
  @override
  overviewWorkout(Workout workout) {}
  @override
  endWorkout(Workout workout) {}
}

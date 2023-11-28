import 'dart:convert';

import 'package:uuid/uuid.dart';
import 'package:workout_model/src/interfaces/workout_interface.dart';

import 'exercise_model.dart';

class Workout implements IWorkout {
  @override
  String id;
  @override
  String name;
  @override
  String description;
  @override
  List<Exercise> exercises;
  @override
  WorkoutStatus status;

  Workout({
    String? id,
    required this.name,
    required this.description,
    List<Exercise>? exercises,
    WorkoutStatus? status,
  })  : id = id ?? const Uuid().v4(),
        exercises = exercises ?? [],
        status = status ?? WorkoutStatus.notStarted;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'exercises': exercises,
        'status': status.index,
      };

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      exercises: (json['exercises'] as List)
          .map((json) => Exercise.fromJson(json))
          .toList(),
      status: WorkoutStatus.values[json['status'] as int],
    );
  }

  String serialize() {
    final json = toJson();
    final string = jsonEncode(json);
    return string;
  }

  factory Workout.deserialize(String serialized) {
    return Workout.fromJson(jsonDecode(serialized));
  }
}

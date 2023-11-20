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

  Workout({
    String? id,
    required this.name,
    required this.description,
    List<Exercise>? exercises,
  })  : id = id ?? const Uuid().v4(),
        exercises = exercises ?? [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'exercises': exercises,
      };

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      exercises: (json['exercises'] as List)
          .map((json) => Exercise.fromJson(json))
          .toList(),
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

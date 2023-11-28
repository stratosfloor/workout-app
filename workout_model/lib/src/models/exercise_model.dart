import 'dart:convert';
import 'package:workout_model/src/interfaces/exercise_interface.dart';
import 'package:uuid/uuid.dart';

class Exercise implements IExercise {
  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final int repetitions;
  @override
  final int? restTime; // in seconds
  @override
  final int sets;
  @override
  final double weight;

  Exercise({
    String? id,
    required this.name,
    required this.description,
    required this.repetitions,
    this.restTime,
    required this.sets,
    required this.weight,
  }) : id = id ?? const Uuid().v4();

  // to json
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'repetitions': repetitions,
        'restTime': restTime,
        'sets': sets,
        'weight': weight,
      };

  // from json
  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'] as String,
      id: json['id'] as String,
      description: json['description'] as String,
      repetitions: json['repetitions'] ?? 0,
      restTime: json['restTime'] ?? 0,
      sets: json['sets'] ?? 0,
      weight: json['weight'] ?? 0,
    );
  }

  // first convert to json, the use built in json encoding to string
  String serialize() {
    final json = toJson();
    final string = jsonEncode(json);
    return string;
  }

  // first convert string to json, then create class from json
  factory Exercise.deserialize(String serialized) {
    return Exercise.fromJson(jsonDecode(serialized));
  }
}

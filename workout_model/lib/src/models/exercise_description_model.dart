import 'dart:convert';

import 'package:uuid/uuid.dart';

import '../interfaces/exercise_interface.dart';

class ExerciseDescription implements IExerciseDescription {
  @override
  final String id;
  @override
  final String name;
  @override
  final String description;

  ExerciseDescription({
    String? id,
    required this.name,
    required this.description,
  }) : id = id ?? const Uuid().v4();

  // to json
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
      };

  // from json
  factory ExerciseDescription.fromJson(Map<String, dynamic> json) {
    return ExerciseDescription(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  // first convert to json, the use built in json encoding to string
  String serialize() {
    final json = toJson();
    final string = jsonEncode(json);
    return string;
  }

  // first convert string to json, then create class from json
  factory ExerciseDescription.deserialize(String serialized) {
    return ExerciseDescription.fromJson(jsonDecode(serialized));
  }
}

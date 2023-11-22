import 'package:flutter/material.dart';
import 'package:workout_model/workout_model.dart';

// TODO: Change to textformfield
// witih validaiton

class WorkoutAddModal extends StatelessWidget {
  WorkoutAddModal({
    super.key,
    required this.createWorkout,
  });

  final _workoutNameController = TextEditingController();
  final _workoutDescriptionController = TextEditingController();
  final void Function({
    required String name,
    required String description,
  }) createWorkout;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
            child: Column(
              children: [
                TextField(
                  controller: _workoutNameController,
                  decoration: InputDecoration(
                    labelText: 'Workout name',
                    helperText: 'Write workout name here',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: TextField(
                    controller: _workoutDescriptionController,
                    maxLines: null,
                    expands: true,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      labelText: 'Workout description',
                      helperText: 'Write workout description here',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel')),
                    ElevatedButton(
                      child: const Text('Create workout'),
                      onPressed: () {
                        createWorkout(
                            name: _workoutNameController.text,
                            description: _workoutDescriptionController.text);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

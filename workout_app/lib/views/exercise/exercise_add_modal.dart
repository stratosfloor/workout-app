import 'package:flutter/material.dart';

class ExerciseAddModal extends StatelessWidget {
  ExerciseAddModal({super.key, req, required this.createExercise});

  final void Function({
    required String name,
    required String description,
  }) createExercise;
  final _exerciseNameController = TextEditingController();
  final _exerciseDescriptionController = TextEditingController();

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
                  controller: _exerciseNameController,
                  decoration: InputDecoration(
                    labelText: 'Exercise name',
                    helperText: 'Write exercise name here',
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
                    controller: _exerciseDescriptionController,
                    maxLines: null,
                    expands: true,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      labelText: 'Exercise description',
                      helperText: 'Write exercise description here',
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
                      child: const Text('Create Exercise'),
                      onPressed: () {
                        createExercise(
                            name: _exerciseNameController.text,
                            description: _exerciseDescriptionController.text);
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

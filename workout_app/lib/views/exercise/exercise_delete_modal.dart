import 'package:flutter/material.dart';

class ExerciseDeleteModal extends StatelessWidget {
  const ExerciseDeleteModal({
    super.key,
    required this.id,
    required this.deleteExercise,
  });

  final String id;
  final void Function(String id) deleteExercise;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete dialog'),
      content: const Text('Press delete to confirm deletion of exercise'),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text('Delete'),
          onPressed: () {
            deleteExercise(id);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

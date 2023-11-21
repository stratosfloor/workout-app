import 'package:flutter/material.dart';

class WorkoutDeleteModal extends StatelessWidget {
  const WorkoutDeleteModal({
    super.key,
    required this.id,
    required this.deleteWorkout,
  });

  final void Function(String id) deleteWorkout;
  final String id;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete dialog'),
      content: const Text('Press delete to confirm deletion of workout'),
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
            deleteWorkout(id);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:workout_app/views/workout/numberPicker.dart';
import 'package:workout_model/workout_model.dart';

class WorkoutSetPetformenceModal extends StatefulWidget {
  const WorkoutSetPetformenceModal({
    super.key,
    required this.exercise,
  });

  final Exercise exercise;

  @override
  State<WorkoutSetPetformenceModal> createState() =>
      _WorkoutSetPetformenceModalState();
}

class _WorkoutSetPetformenceModalState
    extends State<WorkoutSetPetformenceModal> {
  late List<int> performence = [];

  @override
  Widget build(BuildContext context) {
    var performence =
        List<int>.filled(widget.exercise.sets, widget.exercise.repetitions);

    double calculatePerformence() {
      double per = 100;
      for (var i = 0; i < widget.exercise.sets; i++) {
        per = per * (performence[i] / widget.exercise.repetitions);
      }
      return per;
    }

    return SimpleDialog(
      contentPadding: const EdgeInsets.all(20),
      title: Text(widget.exercise.name),
      children: <Widget>[
        const Text('How many reps did you actually do?'),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (var i = 0; i < widget.exercise.sets; i++)
              NumberPicker(
                index: i,
                exercise: widget.exercise,
              )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final per = calculatePerformence();
                // print(performence);
                Navigator.of(context).pop(per);
              },
              child: const Text('Save'),
            ),
          ],
        )
      ],
    );
  }
}

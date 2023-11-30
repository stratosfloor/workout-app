import 'package:flutter/material.dart';
import 'package:workout_model/workout_model.dart';

class NumberPicker extends StatefulWidget {
  const NumberPicker({
    super.key,
    required this.index,
    required this.exercise,
  });

  final int index;
  final Exercise exercise;

  @override
  State<NumberPicker> createState() => _NumberPickerState();
}

class _NumberPickerState extends State<NumberPicker> {
  late int value = widget.exercise.repetitions;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Set #: ${widget.index + 1}'),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                setState(() {
                  value--;
                });
              },
            ),
            Expanded(
                child: Center(
              child: Text(value.toString()),
            )),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                setState(() {
                  value++;
                });
              },
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}

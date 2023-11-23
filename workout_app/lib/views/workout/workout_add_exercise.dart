import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_model/workout_model.dart';

class WorkoutAddExercise extends StatelessWidget {
  WorkoutAddExercise({super.key});

  final exerciseDescriptionFuture =
      ExerciseDescriptionRepository.instance.list();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double weight = 10;
    int repetitions = 10;
    int sets = 3;

    return FutureBuilder(
      future: exerciseDescriptionFuture,
      builder: ((context, snapshot) {
        final result = snapshot.data;

        if (result != null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Tap to add exercise to workout'),
            ),
            body: ListView.builder(
              itemCount: result.length,
              itemBuilder: (context, index) {
                final exercise = result[index];
                return ExpansionTile(
                  title: Text(exercise.name),
                  subtitle: Text(exercise.description),
                  children: <Widget>[
                    ListTile(
                      subtitle: SizedBox(
                          child: Form(
                        key: _formKey,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            SizedBox(
                              width: 60,
                              height: 40,
                              child: TextFormField(
                                initialValue: weight.toString(),
                                onChanged: (value) {
                                  weight = double.parse(value);
                                },
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Text('Weight'),
                                  labelStyle: TextStyle(fontSize: 10),
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.trim().length > 5 ||
                                      double.tryParse(value) == null ||
                                      double.tryParse(value)! < 1 ||
                                      double.tryParse(value)! > 1000) {
                                    return 'Insert valid number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              width: 60,
                              height: 40,
                              child: TextFormField(
                                initialValue: repetitions.toString(),
                                onChanged: (value) {
                                  repetitions = int.parse(value);
                                },
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Text('Reps'),
                                  labelStyle: TextStyle(fontSize: 10),
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.trim().length > 3 ||
                                      int.tryParse(value) == null ||
                                      int.tryParse(value)! < 1 ||
                                      int.tryParse(value)! > 100) {
                                    return 'Insert valid number';
                                  }
                                  return null;
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 60,
                              height: 40,
                              child: TextFormField(
                                initialValue: sets.toString(),
                                onChanged: (value) {
                                  sets = int.parse(value);
                                },
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Text('Sets'),
                                  labelStyle: TextStyle(fontSize: 10),
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.trim().length > 3 ||
                                      int.tryParse(value) == null ||
                                      int.tryParse(value)! < 1 ||
                                      int.tryParse(value)! > 50) {
                                    return 'Insert valid number';
                                  }
                                  return null;
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                      trailing: IconButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // ADD here
                            final ex = Exercise(
                                name: exercise.name,
                                description: exercise.description,
                                repetitions: repetitions,
                                sets: sets,
                                weight: weight);
                            Navigator.of(context).pop(ex);
                          }
                        },
                        icon: Icon(
                          Icons.add_box,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Error"),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }),
    );
  }
}

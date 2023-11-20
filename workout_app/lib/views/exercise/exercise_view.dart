import 'package:flutter/material.dart';
import 'package:workout_model/workout_model.dart';

class ExerciseView extends StatefulWidget {
  const ExerciseView({super.key});

  @override
  State<ExerciseView> createState() => _ExerciseViewState();
}

class _ExerciseViewState extends State<ExerciseView> {
  var exerciseFuture = ExerciseRepository.instance.list();

  void updateList() {
    setState(() {
      exerciseFuture = ExerciseRepository.instance.list();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: exerciseFuture,
      builder: ((context, snapshot) {
        final result = snapshot.data;

        if (result != null) {
          return Scaffold(
            body: ListView.builder(
              itemCount: result.length,
              itemBuilder: (context, index) {
                final exercise = result[index];
                return ListTile(
                  onTap: () {}, // Naviaget to exercise detail view
                  title: Text(exercise.name),
                  subtitle: Text(exercise.description),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await ExerciseRepository.instance.delete(exercise.id);
                      updateList();
                    },
                  ),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                // TODO: Open modal to create exercise
                await ExerciseRepository.instance.create(Exercise(
                    name: 'Bänkpress', description: 'Bänka för faaan'));
                updateList();
              },
              child: const Icon(Icons.add),
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

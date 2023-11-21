import 'package:flutter/material.dart';
import 'package:workout_app/views/exercise/exercise_add_modal.dart';
import 'package:workout_app/views/exercise/exercise_delete_modal.dart';
import 'package:workout_model/workout_model.dart';

class ExerciseView extends StatefulWidget {
  const ExerciseView({super.key});

  @override
  State<ExerciseView> createState() => _ExerciseViewState();
}

class _ExerciseViewState extends State<ExerciseView> {
  var exerciseDescriptionFuture = ExerciseDescriptionRepository.instance.list();

  void updateList() {
    setState(() {
      exerciseDescriptionFuture = ExerciseDescriptionRepository.instance.list();
    });
  }

  void _createExercise({
    required String name,
    required String description,
  }) {
    final exercise = ExerciseDescription(name: name, description: description);
    ExerciseDescriptionRepository.instance.create(exercise);
    updateList();
  }

  void _deleteExercise(String id) async {
    await ExerciseDescriptionRepository.instance.delete(id);
    updateList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: exerciseDescriptionFuture,
      builder: ((context, snapshot) {
        final result = snapshot.data;

        if (result != null) {
          return Scaffold(
            body: ListView.builder(
              itemCount: result.length,
              itemBuilder: (context, index) {
                final exercise = result[index];
                return ListTile(
                  onTap: () {}, //TODO:  Naviaget to exercise detail view
                  title: Text(exercise.name),
                  subtitle: Text(exercise.description),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return ExerciseDeleteModal(
                            id: exercise.id,
                            deleteExercise: _deleteExercise,
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  useSafeArea: true,
                  isScrollControlled: true,
                  context: context,
                  constraints: const BoxConstraints(maxWidth: double.infinity),
                  builder: (BuildContext context) {
                    return ExerciseAddModal(createExercise: _createExercise);
                  },
                );
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

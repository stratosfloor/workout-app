import 'package:flutter/material.dart';
import 'package:workout_model/workout_model.dart';

class ExerciseView extends StatefulWidget {
  const ExerciseView({super.key});

  @override
  State<ExerciseView> createState() => _ExerciseViewState();
}

class _ExerciseViewState extends State<ExerciseView> {
  var exerciseDescriptionFuture = ExerciseDescriptionRepository.instance.list();
  final _exNameController = TextEditingController();
  final _exDescriptionController = TextEditingController();

  void updateList() {
    setState(() {
      exerciseDescriptionFuture = ExerciseDescriptionRepository.instance.list();
    });
  }

  @override
  void dispose() {
    _exNameController.dispose();
    _exDescriptionController.dispose();
    super.dispose();
  }

  void _createExercise() {
    final name = _exNameController.text;
    final description = _exDescriptionController.text;

    final ex = ExerciseDescription(name: name, description: description);
    ExerciseDescriptionRepository.instance.create(ex);
    updateList();
    _exNameController.clear();
    _exDescriptionController.clear();
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
                          return AlertDialog(
                            title: const Text('Delete dialog'),
                            content: const Text(
                                'Press delete to confirm deletion of exercise'),
                            actions: <Widget>[
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge,
                                ),
                                child: const Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              ElevatedButton(
                                style: TextButton.styleFrom(
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge,
                                ),
                                child: const Text('Delete'),
                                onPressed: () {
                                  _deleteExercise(exercise.id);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
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
                    return SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 24),
                            child: Column(
                              children: [
                                TextField(
                                  controller: _exNameController,
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
                                    controller: _exDescriptionController,
                                    maxLines: null,
                                    expands: true,
                                    keyboardType: TextInputType.multiline,
                                    decoration: InputDecoration(
                                      labelText: 'Exercise description',
                                      helperText:
                                          'Write exercise description here',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
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
                                        _createExercise();
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

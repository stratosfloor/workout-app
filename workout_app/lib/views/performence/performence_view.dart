import 'package:flutter/material.dart';
import 'package:workout_model/workout_model.dart';

class PerformenceView extends StatefulWidget {
  const PerformenceView({super.key});

  @override
  State<PerformenceView> createState() => _PerformenceViewState();
}

class _PerformenceViewState extends State<PerformenceView> {
  var workoutFuture = WorkoutRepository.instance.list();

  String totalPerformence(Workout workout) {
    double performence = 1;
    for (var i = 0; i < workout.exercises.length; i++) {
      var per = workout.exercises[i].performence as double;
      performence *= per / 100;
    }
    return (performence * 100).toString();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: workoutFuture,
      builder: (context, snapshot) {
        final result = snapshot.data;
        if (result != null) {
          final completed = result
              .where((workout) => workout.status == WorkoutStatus.completed)
              .toList();
          return Scaffold(
            appBar: AppBar(
              title: const Text('Performence'),
            ),
            body: ListView.builder(
              itemCount: completed.length,
              itemBuilder: (context, index) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Empty'),
                  );
                } else {
                  final workout = completed[index];
                  return Container(
                    decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide())),
                    child: ExpansionTile(
                      title: Text(workout.name),
                      subtitle: Text(workout.status.name.toString()),
                      collapsedBackgroundColor: Colors.grey[100],
                      backgroundColor: Colors.grey[400],
                      children: <Widget>[
                        Text(
                          'Total performence: ${totalPerformence(workout)}%',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        for (var i = 0; i < workout.exercises.length; i++)
                          Column(
                            children: [
                              Text(
                                workout.exercises[i].name,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                  'Weight: ${workout.exercises[i].weight.toString()}'),
                              Text(
                                  'Repetitions: ${workout.exercises[i].repetitions.toString()}'),
                              Text(
                                  'Sets: ${workout.exercises[i].sets.toString()}'),
                              Text(
                                  'Performence: ${workout.exercises[i].performence.toString()}%'),
                              Divider(),
                            ],
                          )
                      ],
                    ),
                  );
                }
              },
            ),
          );
        } else {
          return const Center(
            child: Text('Something went wrong'),
          );
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:workout_app/views/exercise/exercise_view.dart';
import 'package:workout_app/views/performence/performence_view.dart';
import 'package:workout_app/views/workout/workout_view.dart';
import 'package:workout_model/workout_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final ExerciseDescriptionRepository exerciseDescriptionRepository =
      ExerciseDescriptionRepository.instance;
  final ExerciseRepository exerciseRepository = ExerciseRepository.instance;
  final WorkoutRepository workoutRepository = WorkoutRepository.instance;
  final directory = await getApplicationCacheDirectory();

  await exerciseDescriptionRepository.initalize(filePath: directory.path);
  await exerciseRepository.initalize(filePath: directory.path);
  await workoutRepository.initalize(filePath: directory.path);

  runApp(
    MaterialApp(
      title: "Workout app",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WorkoutApp(),
    ),
  );
}

class WorkoutApp extends StatefulWidget {
  const WorkoutApp({super.key});

  @override
  State<WorkoutApp> createState() => _WorkoutAppState();
}

class _WorkoutAppState extends State<WorkoutApp> {
  int currentPageIndex = 0;

  final List<Widget> views = const [
    ExerciseView(),
    WorkoutView(),
    PerformenceView()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) => setState(() {
          currentPageIndex = index;
        }),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.sports_gymnastics), label: 'Exercise'),
          NavigationDestination(
              icon: Icon(Icons.fitness_center), label: 'Workout'),
          NavigationDestination(icon: Icon(Icons.bolt), label: 'Performence'),
        ],
      ),
      body: views[currentPageIndex],
    );
  }
}

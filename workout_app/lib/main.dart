import 'package:flutter/material.dart';
import 'package:workout_app/views/exercise/exercise_view.dart';
import 'package:workout_app/views/workout/workout_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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

  final List<Widget> views = const [ExerciseView(), WorkoutView()];

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
        ],
      ),
      body: views[currentPageIndex],
    );
  }
}

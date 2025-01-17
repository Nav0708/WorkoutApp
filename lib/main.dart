import 'package:flutter/material.dart';
import 'model/exercise.dart';
import 'model/exercise_result.dart';
import 'model/workout.dart';
import 'workouthistorypage.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout History Page',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: WorkoutHistoryPage(),
    );
  }
}





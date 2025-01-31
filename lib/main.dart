import 'package:ecommerce/recentperformance.dart';
import 'package:ecommerce/workoutprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/exercise.dart';
import 'model/exercise_result.dart';
import 'model/workoutplan.dart';
import 'model/workout.dart';
import 'workouthistorypage.dart';
import 'workoutrecordingpage.dart';
void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => WorkoutProvider(),
    child: MyApp(),
  ),
  );
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
      home: Scaffold( body: Column(
        children: [
        RecentPerformanceWidget(),
    Expanded(child: WorkoutHistoryPage()),
    ],
    ),
      )
    );
  }
}





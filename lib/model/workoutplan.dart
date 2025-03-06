import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'exercise.dart';

class WorkoutPlan {
  final String workoutPlan;
  final List<Exercise> exerciseList;

  WorkoutPlan({required this.workoutPlan, required this.exerciseList});

  factory WorkoutPlan.fromFirestore(Map<String, dynamic> data) {
    final String workoutPlanName = data['workoutPlan'] ?? 'Unknown Workout Plan';
    final List<Exercise> exercises = [];
    if (data['exerciseList'] != null && data['exerciseList'] is List<dynamic>) {
      exercises.addAll(
        (data['exerciseList'] as List<dynamic>).map((e) {
            return Exercise.fromJson(e);
        }).toList(),
      );
    }

    return WorkoutPlan(
      workoutPlan: workoutPlanName,
      exerciseList: exercises,
    );
  }
}
// Map<String, dynamic> toMap() {
//   return {
//     'workoutPlan': workoutPlan,
//     'exerciseList': jsonEncode(exerciseList.map((e) => e.toMap()).toList()),
//   };
// }

// Create a WorkoutPlan object from a Map (useful for deserialization)
  // static WorkoutPlan examplePlan() {
  //   return WorkoutPlan(
  //     workoutPlan: "Full Body Strength",
  //     exerciseList: [
  //       Exercise(exerciseName: "Push-ups",  targetOutput: 20, unitMeasurement: "reps"),
  //       Exercise(exerciseName: "Plank", targetOutput: 20,unitMeasurement: "seconds"),
  //       Exercise(exerciseName: "Running", targetOutput: 40,  unitMeasurement: "meters"),
  //       Exercise(exerciseName: "Squats", targetOutput: 30,  unitMeasurement: "reps"),
  //       Exercise(exerciseName: "Burpees", targetOutput: 10,unitMeasurement: "seconds"),
  //       Exercise(exerciseName: "Jogging", targetOutput: 20,  unitMeasurement: "meters"),
  //       Exercise(exerciseName: "Sit-ups", targetOutput: 20,  unitMeasurement: "reps"),
  //     ],
  //   );
  // }

import 'dart:convert';

import 'exercise.dart';

class WorkoutPlan {
  final String workoutPlan;
  final List<Exercise> exerciseList;

  WorkoutPlan({required this.workoutPlan, required this.exerciseList});

  Map<String, dynamic> toMap() {
    return {
      'workoutPlan': workoutPlan,
      'exerciseList': jsonEncode(exerciseList.map((e) => e.toMap()).toList()),
    };
  }

  // Create a WorkoutPlan object from a Map (useful for deserialization)
  factory WorkoutPlan.fromMap(Map<String, dynamic> map) {
    return WorkoutPlan(
      workoutPlan: map['workoutPlan'],
      exerciseList: (jsonDecode(map['exerciseList']) as List)
          .map((e) => Exercise.fromMap(e))
          .toList(),
    );
  }
  static WorkoutPlan examplePlan() {
    return WorkoutPlan(
      workoutPlan: "Full Body Strength",
      exerciseList: [
        Exercise(exerciseName: "Push-ups",  targetOutput: 20, unitMeasurement: "reps"),
        Exercise(exerciseName: "Plank", targetOutput: 20,unitMeasurement: "seconds"),
        Exercise(exerciseName: "Running", targetOutput: 40,  unitMeasurement: "meters"),
        Exercise(exerciseName: "Squats", targetOutput: 30,  unitMeasurement: "reps"),
        Exercise(exerciseName: "Burpees", targetOutput: 10,unitMeasurement: "seconds"),
        Exercise(exerciseName: "Jogging", targetOutput: 20,  unitMeasurement: "meters"),
        Exercise(exerciseName: "Sit-ups", targetOutput: 20,  unitMeasurement: "reps"),
      ],
    );
  }
}
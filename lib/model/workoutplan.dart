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
    if (data['exerciseResults'].first != null && data['exerciseResults'].first is List<dynamic>) {
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
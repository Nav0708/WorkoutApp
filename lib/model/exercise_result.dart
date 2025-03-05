import 'dart:convert';

import 'exercise.dart';
class ExerciseResult {
  final Exercise exercise;
  final int achievedOutput;
  ExerciseResult({required this.exercise, required this.achievedOutput});

  Map<String, dynamic> toJson() {
    return {
      'exercise': exercise.toJson(),
      'achievedOutput': achievedOutput,
    };
  }
  factory ExerciseResult.fromMap(Map<String, dynamic> data) {
    return ExerciseResult(
      exercise: data['exerciseName'] ?? 'Unknown Exercise',
      achievedOutput: data['achievedOutput'] ?? 0,
    );
  }
}
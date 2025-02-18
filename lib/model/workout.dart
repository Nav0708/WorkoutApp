import 'dart:convert';

import 'exercise_result.dart';

class Workout {
  DateTime workoutDate;
  List<ExerciseResult> exerciseResults;

  Workout({required this.workoutDate, required this.exerciseResults});

  Map<String, dynamic> toMap() {
    return {
      'workoutDate': workoutDate.toIso8601String(),
      'exercises': jsonEncode(exerciseResults.map((e) => e.toMap()).toList()),
    };
  }
  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      workoutDate: DateTime.parse(map['workoutDate']),
      exerciseResults: (jsonDecode(map['exercises']) as List)
          .map((item) => ExerciseResult.fromMap(item)) // Deserialize ExerciseResult
          .toList(),
    );
  }
}

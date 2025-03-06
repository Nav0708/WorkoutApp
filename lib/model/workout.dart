import 'package:cloud_firestore/cloud_firestore.dart';

import 'exercise.dart';
import 'exercise_result.dart';

class Workout {
  DateTime workoutDate;
  List<ExerciseResult> exerciseResults;

  Workout({required this.workoutDate, required this.exerciseResults});

  factory Workout.fromFirestore(DocumentSnapshot doc) {
    try {
      final data = doc.data() as Map<String, dynamic>? ?? {};

      final timestamp = (data['timestamp'] as Timestamp?) ?? Timestamp.now();
      final workoutDate = timestamp.toDate();
      final exerciseResults = (data['exerciseResults'] as List<dynamic>? ?? [])
          .map<ExerciseResult>((item) {
        final mapItem = item as Map<String, dynamic>? ?? {};
        return ExerciseResult.fromMap(mapItem);
      })
          .toList();

      return Workout(
        workoutDate: workoutDate,
        exerciseResults: exerciseResults,
      );
    } catch (e) {
      print('Error parsing Workout from Firestore: $e');
      rethrow;
    }
  }

  @override
  String toString() {
    return 'Workout(workoutDate: $workoutDate, exerciseResults: $exerciseResults)';
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

import 'exercise_result.dart';

class Workout {
  DateTime workoutDate;
  List<ExerciseResult> exerciseResults;

  Workout({required this.workoutDate, required this.exerciseResults});

  factory Workout.fromFirestore(DocumentSnapshot doc) {
    try {
      final data = doc.data() as Map<String, dynamic>?;

      if (data == null) {
        throw Exception('Document data is null');
      }

      // Parse workoutDate (timestamp)
      final timestamp = data['timestamp'] as Timestamp?;
      if (timestamp == null) {
        throw Exception('Timestamp field is missing or null');
      }
      final workoutDate = timestamp.toDate();

      // Parse exerciseResults
      final exerciseResultsData = data['exerciseResults'] as List<dynamic>?;
      if (exerciseResultsData == null) {
        throw Exception('exerciseResults field is missing or null');
      }

      final exerciseResults = exerciseResultsData.map((item) {
        return ExerciseResult.fromMap(item as Map<String, dynamic>);
      }).toList();

      return Workout(
        workoutDate: workoutDate,
        exerciseResults: exerciseResults,
      );
    } catch (e) {
      print('Error parsing Workout from Firestore: $e');
      rethrow; // Re-throw the error for debugging
    }
  }

  @override
  String toString() {
    return 'Workout(workoutDate: $workoutDate, exerciseResults: $exerciseResults)';
  }
}
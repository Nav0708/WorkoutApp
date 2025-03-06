import 'exercise.dart';

class ExerciseResult {
  final Exercise exercise;
  final int achievedOutput;

  ExerciseResult({required this.exercise, required this.achievedOutput});

  factory ExerciseResult.fromMap(Map<String, dynamic> data) {
    return ExerciseResult(
      exercise: Exercise.fromJson(
          (data['exercise'] as Map<String, dynamic>?) ?? {}
      ),
      achievedOutput: (data['achievedOutput'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exercise': exercise.toJson(),
      'achievedOutput': achievedOutput,
    };
  }
}
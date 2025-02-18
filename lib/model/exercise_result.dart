import 'exercise.dart';
class ExerciseResult {
  final Exercise exercise;
  final int achievedOutput;
  ExerciseResult({required this.exercise, required this.achievedOutput});

  Map<String, dynamic> toMap() {
    return {
      'exercise': exercise,
      'achievedOutput': achievedOutput,
    };
  }
  factory ExerciseResult.fromMap(Map<String, dynamic> map) {
    return ExerciseResult(
      exercise: Exercise.fromMap(map['exercise']), // Deserialize the Exercise object
      achievedOutput: map['achievedOutput'],
    );
  }
}
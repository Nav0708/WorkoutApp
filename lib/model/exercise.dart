class Exercise {
  final String exerciseName;
  final int targetOutput;
  final String unitMeasurement;

  Exercise({
    required this.exerciseName,
    required this.targetOutput,
    required this.unitMeasurement,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      exerciseName: (json['exerciseName'] as String?) ?? 'Unknown Exercise',
      targetOutput: (json['targetOutput'] as num?)?.toInt() ?? 0,
      unitMeasurement: (json['unitMeasurement'] as String?) ?? 'reps',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exerciseName': exerciseName,
      'targetOutput': targetOutput,
      'unitMeasurement': unitMeasurement,
    };
  }
}
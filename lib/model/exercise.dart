class Exercise {
  final String exerciseName;
  final int targetOutput;
  final String unitMeasurement;
  Exercise({required this.exerciseName, required this.targetOutput, required this.unitMeasurement});
  // Convert Exercise object to a Map for JSON serialization
  Map<String, dynamic> toMap() {
    return {
      'exerciseName': exerciseName,
      'targetOutput': targetOutput,
      'unitMeasurement': unitMeasurement,
    };
  }

  // Create an Exercise object from a Map (useful for deserialization)
  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      exerciseName: map['exerciseName'],
      targetOutput: map['targetOutput'],
        unitMeasurement: map['unitMeasurement'],
    );
  }
}
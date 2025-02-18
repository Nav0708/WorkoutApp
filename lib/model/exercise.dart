class Exercise {
  final String exerciseName;
  final int targetOutput;
  final String unitMeasurement;
  Exercise({required this.exerciseName, required this.targetOutput, required this.unitMeasurement});
  Map<String, dynamic> toMap() {
    return {
      'name': exerciseName,
      'target': targetOutput,
      'unit': unitMeasurement,
    };
  }
  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      exerciseName: map['name'],
      targetOutput: map['target'],
        unitMeasurement: map['unit'],
    );
  }
}
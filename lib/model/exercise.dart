class Exercise {
  //final int? id;
  final String exerciseName;
  final int targetOutput;
  final String unitMeasurement;
  Exercise({required this.exerciseName, required this.targetOutput, required this.unitMeasurement});
  Map<String, dynamic> toJson() {
    return {
      'exerciseName': exerciseName,
      'targetOutput': targetOutput,
      'unitMeasurement': unitMeasurement,
    };
  }
  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      //id: json['id'],
      exerciseName: json['exerciseName'],
      targetOutput: json['targetOutput'],
      unitMeasurement: json['unitMeasurement'],
    );
  }
}
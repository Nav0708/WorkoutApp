enum WorkoutType {
  solo,
  collaborative,
  competitive,
  unknown;

  static WorkoutType fromString(String type) {
    switch (type.toLowerCase()) {
      case 'solo':
        return WorkoutType.solo;
      case 'collaborative':
        return WorkoutType.collaborative;
      case 'competitive':
        return WorkoutType.competitive;
      default:
        return WorkoutType.unknown;
    }
  }

  String toJson() => name;
}

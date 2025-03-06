import 'package:cloud_firestore/cloud_firestore.dart';

enum WorkoutType { solo, collaborative, competitive }

class WorkoutSession {
  final String id;
  final WorkoutType type;
  final List<String> participants;
  final DateTime timestamp;

  WorkoutSession({
    required this.id,
    required this.type,
    required this.participants,
    required this.timestamp,
  });
  factory WorkoutSession.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return WorkoutSession(
      id: doc.id,
      type: _parseWorkoutType(data['type'] as String? ?? 'solo'),
      participants: (data['participants'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
WorkoutType _parseWorkoutType(String typeString) {
  return WorkoutType.values.firstWhere(
        (e) => e.toString().split('.').last == typeString,
    orElse: () => WorkoutType.solo, // Default value
  );
}
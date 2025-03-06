// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
//
// import '../model/exercise.dart';
// import '../model/workout.dart';
//
// class WorkoutFirestoreService with ChangeNotifier {
//   final WorkoutFirestoreService _firestore = WorkoutFirestoreService();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   String generateInviteCode() {
//     const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
//     final random = Random();
//     notifyListeners();
//     return String.fromCharCodes(
//       Iterable.generate(
//         6,
//             (_) => chars.codeUnitAt(random.nextInt(chars.length)),
//       ),
//     );
//
//   }
//
//   //Create a new group workout
//   Future<String?> createGroupWorkout(String name, List<Exercise> exercises, String type) async {
//     try {
//       final User? user = _auth.currentUser;
//       if (user == null) return null;
//
//       final String inviteCode = generateInviteCode();
//
//       final workoutData = {
//         'name': name,
//         'exercises': exercises.map((e) => e.toMap()).toList(),
//         'creatorId': user.uid,
//         'createdAt': FieldValue.serverTimestamp(),
//         'type': type,
//         'inviteCode': inviteCode,
//         'participants': [user.uid],
//       };
//
//       final docRef = await _firestore.collection('workouts').add(workoutData);
//       return docRef.id;
//     } catch (e) {
//       print('Error creating workout: $e');
//       return null;
//     }
//   }
//
//
//   Future<Map<String, dynamic>?> joinWorkoutByCode(String inviteCode) async {
//     try {
//       final User? user = _auth.currentUser;
//       if (user == null) return null;
//
//       // Query for the workout with matching invite code
//       final querySnapshot = await _firestore
//           .collection('workouts')
//           .where('inviteCode', isEqualTo: inviteCode)
//           .limit(1)
//           .get();
//
//       if (querySnapshot.docs.isEmpty) {
//         return null; // No workout found with this invite code
//       }
//
//       final docSnapshot = querySnapshot.docs.first;
//       final String workoutId = docSnapshot.id;
//       final workoutData = docSnapshot.data();
//
//       // Add the current user to the participants list
//       await docSnapshot.reference.update({
//         'participants': FieldValue.arrayUnion([user.uid]),
//       });
//
//       return {
//         'workoutId': workoutId,
//         'workoutType': workoutData['type'],
//         'workout': Workout.fromFirestore(workoutData, workoutId),
//       };
//     } catch (e) {
//       print('Error joining workout: $e');
//       return null;
//     }
//   }
//
//
//
//   // Record an exercise result
//   Future<bool> recordExerciseResult(String workoutId, int exerciseIndex, double value) async {
//     try {
//       final User? user = _auth.currentUser;
//       if (user == null) return false;
//
//       // Query for existing result doc
//       final querySnapshot = await _firestore
//           .collection('workoutResults')
//           .where('workoutId', isEqualTo: workoutId)
//           .where('userId', isEqualTo: user.uid)
//           .limit(1)
//           .get();
//
//       DocumentReference resultRef;
//
//       if (querySnapshot.docs.isEmpty) {
//         // Create new result document
//         resultRef = _firestore.collection('workoutResults').doc();
//         await resultRef.set({
//           'workoutId': workoutId,
//           'userId': user.uid,
//           'exercises': [],
//           'completed': false,
//         });
//       } else {
//         resultRef = querySnapshot.docs.first.reference;
//       }
//
//       // Add exercise result
//       final exerciseResult = {
//         'exerciseIndex': exerciseIndex,
//         'value': value,
//         'completedAt': FieldValue.serverTimestamp(),
//       };
//
//       await resultRef.update({
//         'exercises': FieldValue.arrayUnion([exerciseResult]),
//       });
//
//       return true;
//     } catch (e) {
//       print('Error recording exercise result: $e');
//       return false;
//     }
//   }
//
//   // Mark a workout as complete
//   Future<bool> completeWorkout(String workoutId) async {
//     try {
//       final User? user = _auth.currentUser;
//       if (user == null) return false;
//
//       final querySnapshot = await _firestore
//           .collection('workoutResults')
//           .where('workoutId', isEqualTo: workoutId)
//           .where('userId', isEqualTo: user.uid)
//           .limit(1)
//           .get();
//
//       if (querySnapshot.docs.isEmpty) {
//         return false;
//       }
//
//       await querySnapshot.docs.first.reference.update({
//         'completed': true,
//       });
//
//       return true;
//     } catch (e) {
//       print('Error completing workout: $e');
//       return false;
//     }
//   }
//
//   // Get workout details
//   Future<Workout?> getWorkout(String workoutId) async {
//     try {
//       final docSnapshot = await _firestore
//           .collection('workouts')
//           .doc(workoutId)
//           .get();
//
//       if (!docSnapshot.exists) {
//         return null;
//       }
//
//       return Workout.fromFirestore(docSnapshot.data()!, docSnapshot.id);
//     } catch (e) {
//       print('Error getting workout: $e');
//       return null;
//     }
//   }
//
//   // Get all results for a workout
//   Future<List<WorkoutResult>> getWorkoutResults(String workoutId) async {
//     try {
//       final querySnapshot = await _firestore
//           .collection('workoutResults')
//           .where('workoutId', isEqualTo: workoutId)
//           .get();
//
//       return querySnapshot.docs.map((doc) =>
//           WorkoutResult.fromFirestore(doc.data(), doc.id)
//       ).toList();
//     } catch (e) {
//       print('Error getting workout results: $e');
//       return [];
//     }
//   }
//
//   // Stream workout results for real-time updates
//   Stream<List<WorkoutResult>> streamWorkoutResults(String workoutId) {
//     return _firestore
//         .collection('workoutResults')
//         .where('workoutId', isEqualTo: workoutId)
//         .snapshots()
//         .map((snapshot) =>
//         snapshot.docs.map((doc) =>
//             WorkoutResult.fromFirestore(doc.data(), doc.id)
//         ).toList()
//     );
//   }
// }
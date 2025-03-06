import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'workoutrecordingpage.dart';
import 'model/workoutplan.dart';
import 'model/workouttype.dart';

class JoinWorkoutPage extends StatefulWidget {
  @override
  _JoinWorkoutPageState createState() => _JoinWorkoutPageState();
}

class _JoinWorkoutPageState extends State<JoinWorkoutPage> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _joinWorkoutSession() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    String enteredCode = _codeController.text.trim();
    if (enteredCode.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Please enter a workout code.";
      });
      return;
    }

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('workout_sessions')
          .where('workoutCode', isEqualTo: enteredCode)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Invalid workout code. Please check and try again.";
        });
        return;
      }

      DocumentSnapshot sessionDoc = querySnapshot.docs.first;
      Map<String, dynamic> sessionData = sessionDoc.data() as Map<String, dynamic>;
       print(sessionData);
       final wp=sessionData['workoutPlan'];
      QuerySnapshot querySnapshotWP = await FirebaseFirestore.instance
          .collection('workoutPlans')
          .where('workoutPlan', isEqualTo: wp)
          .limit(1)
          .get();
      print("wp:::::::::::::::::::::${querySnapshotWP.docs.first.data()}");
      // WorkoutPlan workoutPlan = WorkoutPlan(
      //   workoutPlan: sessionData['workoutPlan'],
      //   exerciseList: [],
      // );
      Map<String, dynamic> wp1=querySnapshotWP.docs.first.data() as Map<String, dynamic>;
      WorkoutPlan workoutPlan = WorkoutPlan.fromFirestore(wp1);
      print("workoutPlan:::::::::::::::::::::${workoutPlan.workoutPlan}");

      WorkoutType workoutType = sessionData['type'] == 'collaborative'
          ? WorkoutType.collaborative
          : WorkoutType.competitive;

      String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";
      List<dynamic> participants = sessionData['participants'] ?? [];

      if (!participants.contains(currentUserId)) {
        participants.add(currentUserId);
        await sessionDoc.reference.update({'participants': participants});
      }

      // Navigate to the workout recording page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WorkoutRecordingPage(
            selectedWorkoutPlan: workoutPlan,
            workoutType: workoutType,
            workoutCode: enteredCode,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "An error occurred. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Join Workout Session")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Enter the workout invite code shared with you:",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                labelText: "Workout Code",
                border: OutlineInputBorder(),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _joinWorkoutSession,
              child: Text("Join Workout"),
            ),
          ],
        ),
      ),
    );
  }
}

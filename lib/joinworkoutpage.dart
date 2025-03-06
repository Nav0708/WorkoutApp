// lib/screens/join_workout_screen.dart
import 'package:WorkoutApp/model/exercise.dart';
import 'package:WorkoutApp/workoutrecordingpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/workoutfirestoreservice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/workoutplan.dart';
import 'model/workouttype.dart';
import 'workoutselection.dart';

class JoinWorkoutPage extends StatefulWidget {
  @override
  _JoinWorkoutPageState createState() => _JoinWorkoutPageState();
}



class _JoinWorkoutPageState extends State<JoinWorkoutPage> {
  final _codeController = TextEditingController();
  bool _isJoining = false;

  Future<void> _joinWorkout() async {
    final code = _codeController.text.trim();
    String name='';


    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an invite code')),
      );
      return;
    }

    setState(() {
      _isJoining = true;
    });

    try {
      final workoutCode = code;

      final sessionRef = FirebaseFirestore.instance
          .collection('workout_sessions')
          .doc(code);
      print('Session Ref: $sessionRef');
      final querySnapshot = await FirebaseFirestore.instance
          .collection('workout_results')
          .where('workoutCode', isEqualTo: workoutCode)
          .get();
      final document = querySnapshot.docs.first;
      final data = document.data();

      try {
        if (document.exists) {
          final data = document.data();
          print('we got this data from firestore ${data}');
          //print('Document data: ${data['type']}');
        } else {
          print('Document does not exist');
        }
      } catch (e) {
        print('Error fetching document: $e');
      }
      String typeString = data["workoutType"];
      WorkoutType workoutType = WorkoutType.fromString(typeString);
      print("Workout Type: $typeString");

      final String workoutPlanName = data['workoutPlan'] ?? 'Unknown Workout Plan';
      final List<dynamic> exerciseResults = data['exerciseResults'] ?? [];

      final Map<String, dynamic> workoutData = {
        'workoutPlan': workoutPlanName,
        'exerciseList': exerciseResults.map((result) => result['exercise']).toList(),
      };



        await sessionRef.update({
          'participants': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser?.uid]),
        });

      WorkoutPlan selectedWorkoutPlan = WorkoutPlan.fromFirestore(workoutData);

      print('Workout Plan Name**********************: ${selectedWorkoutPlan}');


      DocumentSnapshot updatedSession = await document.reference.get();
      print('Updated Session: $updatedSession');
      List<dynamic> participants = updatedSession['participants'] ?? [];

      if (participants.contains(FirebaseAuth.instance.currentUser?.uid)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully joined the workout!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WorkoutRecordingPage(selectedWorkoutPlan: selectedWorkoutPlan, workoutType: workoutType, workoutCode: workoutCode),
          ),
        );
      }else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to join the workout')),
        );
      }
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error joining workout: ${e.toString()}')),
      );
      Navigator.pop(context);
    } finally {
      setState(() {
        _isJoining = false;
      });
    }
    setState(() {
      _isJoining = false;
    });

    @override
    void dispose() {
      _codeController.dispose();
      super.dispose();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Workout'),
      ),
      body: _isJoining
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter the workout invite code',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: 'Invite Code',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.characters,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _joinWorkout,
              child: const Text('Join Workout'),

            ),
          ],
        ),
      ),
    );
  }
}
import 'dart:convert';

import 'package:WorkoutApp/workoutselection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/databaseservice.dart';
import 'workoutprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/exercise.dart';
import '../model/workoutplan.dart';
import 'model/exercise_result.dart';
import 'model/workout.dart';
import 'dart:async';

class WorkoutRecordingPage extends StatefulWidget {
  final WorkoutPlan selectedWorkoutPlan;
  const WorkoutRecordingPage({super.key, required this.selectedWorkoutPlan, required WorkoutType workoutType, required String workoutCode});

  get workoutCode => null;

  @override
  _WorkoutRecordingPageState createState() => _WorkoutRecordingPageState();
}

class _WorkoutRecordingPageState extends State<WorkoutRecordingPage> {
  WorkoutPlan? _selectedPlan;
  final Map<Exercise, dynamic> recordedResults = {};
  final _formKey = GlobalKey<FormState>();
  late Map<Exercise, TextEditingController> _controllers;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedPlan = widget.selectedWorkoutPlan;
    if (widget.workoutCode != null && widget.workoutCode.isNotEmpty) {
      _joinWorkoutSession();
    }
    else{
      print('Continuing workout');
    }
  }

  Future<void> _joinWorkoutSession() async {
    final sessionRef = FirebaseFirestore.instance.collection('workout_sessions').doc(widget.workoutCode);

    DocumentSnapshot session = await sessionRef.get();
    if (session.exists) {
      await sessionRef.update({
        'participants': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser?.uid])
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Record Workout")),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: _selectedPlan?.exerciseList.map((exercise) {
                return ListTile(
                  title: Text(exercise.exerciseName),
                  subtitle: _buildInputField(exercise),
                );
              }).toList() ?? [],
            ),
          ),
        ],
      ),
      floatingActionButton: ElevatedButton(
        onPressed: _saveWorkout,
        child: Text("Save Workout"),
      ),
    );
  }

  Widget _buildInputField(Exercise exercise) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
              suffixText: exercise.unitMeasurement,
              filled: true,
              fillColor: Colors.white24,
            ),
            onChanged: (value) {
              recordedResults[exercise] = int.tryParse(value) ?? 0;
            },
          ),
        ),
      ],
    );
  }

  Future<void> _saveWorkout() async {
    if (_selectedPlan == null) return; // Ensure _selectedPlan is not null

    String workoutPlanName = _selectedPlan!.workoutPlan;
    //int workoutPlanId = _selectedPlan!.wp_id!;
    // print("Recorded Results: $recordedResults");
    //
    final results = recordedResults.entries.map((entry) {
      print("Saving exercise result: ${entry.key.exerciseName} - ${entry.value}");
      return ExerciseResult(
        exercise: entry.key,
        achievedOutput: entry.value,
      );
    }).toList();
    final resultsData = results.map((result) {
      return {
        'exerciseName': result.exercise.exerciseName,
        'achievedOutput': result.achievedOutput,
      };
    }).toList();
    print("Saving workout with results: $resultsData");
    //
    // Workout newWorkout = Workout(
    //   workoutId: null,
    //   workoutPlanId: 0,
    //   exerciseId: 0,
    //   workoutDate: DateTime.now(),
    //   workoutPlanName: workoutPlanName,
    //   exerciseResults: results,
    // );
    // if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('workout_results').add({
        'id':0,
        'workoutPlan': widget.selectedWorkoutPlan.workoutPlan,
        'exerciseResults': resultsData,
        'userId': user?.uid,
        'timestamp': DateTime.now(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Workout saved successfully!")),
      );
      Navigator.pop(context);
    } catch (e)
    {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save workout: $e")),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }

  }
}
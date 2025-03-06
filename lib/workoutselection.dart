import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'model/workouttype.dart';
import 'services/databaseservice.dart';
import 'model/workoutplan.dart';
import 'workoutrecordingpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:share_plus/share_plus.dart';

class WorkoutSelectionPage extends StatefulWidget {
  @override
  _WorkoutSelectionPageState createState() => _WorkoutSelectionPageState();
}

class _WorkoutSelectionPageState extends State<WorkoutSelectionPage> {
  List<WorkoutPlan> _workoutPlans = [];
  WorkoutPlan? _selectedWorkoutPlan;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWorkoutPlans();
  }


  Future<void> _fetchWorkoutPlans() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('workoutPlans').get();
      print('Workout plans fetched: $querySnapshot');
      List<WorkoutPlan> workoutPlans = querySnapshot.docs.map((doc) {
        print('Parsing document: ${doc.id}');
        return WorkoutPlan.fromFirestore(doc.data());
      }).toList();

      print("Workout plans fetched: $workoutPlans");
      setState(() {
        _workoutPlans = workoutPlans;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _selectWorkoutPlan(WorkoutPlan? workoutPlan) {
    setState(() {
      _selectedWorkoutPlan = workoutPlan;
    });
  }

  void _navigateToWorkout(BuildContext context, WorkoutType type) async{
    if (_selectedWorkoutPlan == null||type==null) return;
    print('$type');
    String workoutCode='';
    if (type == WorkoutType.solo) {
      workoutCode = '';
    }
    if (type == WorkoutType.collaborative || type == WorkoutType.competitive) {
      workoutCode =  Uuid().v4();
      final sessionData = {
        'type': type == WorkoutType.collaborative ? 'collaborative' : 'competitive',
        'workoutPlan': _selectedWorkoutPlan!.workoutPlan,
        'exercises': _selectedWorkoutPlan!.exerciseList,
        'createdBy': FirebaseAuth.instance.currentUser?.uid,
        'participants': [FirebaseAuth.instance.currentUser?.uid],
        'timestamp': FieldValue.serverTimestamp(),
        'workoutCode': workoutCode,
      };

      if (type == 'WorkoutType.competitive') {
        sessionData['scores'] = {};
      }
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final data=firestore.collection('workout_sessions').add(sessionData);
      print("New workout session created with ID: $data");
      final shareMessage = type == WorkoutType.collaborative
          ? "Join my collaborative workout session using code: $workoutCode"
          : "Compete with me in this workout! Use code: $workoutCode";

      Share.share(shareMessage);
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutRecordingPage(
          selectedWorkoutPlan: _selectedWorkoutPlan!,
          workoutType: type,
          workoutCode: workoutCode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select a Workout Plan")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            DropdownButton<WorkoutPlan>(
              hint: Text("Select a Workout Plan"),
              value: _selectedWorkoutPlan,
              onChanged: _selectWorkoutPlan,
              items: _workoutPlans.map((plan) {
                return DropdownMenuItem<WorkoutPlan>(
                  value: plan,
                  child: Text(plan.workoutPlan),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            if (_selectedWorkoutPlan != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () => _navigateToWorkout(context, WorkoutType.solo),
                    child: Column(
                      children: [
                        Icon(Icons.person, size: 50, color: Theme.of(context).primaryColor),
                        SizedBox(height: 8),
                        Text('Solo Workout')
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _navigateToWorkout(context, WorkoutType.collaborative),
                    child: Column(
                      children: [
                        Icon(Icons.group, size: 50, color: Theme.of(context).primaryColor),
                        SizedBox(height: 8),
                        Text('Collaborative')
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _navigateToWorkout(context, WorkoutType.competitive),
                    child: Column(
                      children: [
                        Icon(Icons.emoji_events, size: 50, color: Theme.of(context).primaryColor),
                        SizedBox(height: 8),
                        Text('Competitive')
                      ],
                    ),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }
}


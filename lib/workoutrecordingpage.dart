import 'package:ecommerce/services/databaseservice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/model/exercise.dart';
import 'package:ecommerce/model/workoutplan.dart';
import 'package:ecommerce/workoutprovider.dart';
import 'model/exercise_result.dart';
import 'model/workout.dart';
import 'dart:async';

class WorkoutRecordingPage extends StatefulWidget {
  @override
  _WorkoutRecordingPageState createState() => _WorkoutRecordingPageState();
}

class _WorkoutRecordingPageState extends State<WorkoutRecordingPage> {
  WorkoutPlan? _selectedPlan; // Track the selected workout plan
  final Map<Exercise, dynamic> recordedResults = {};

  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  double _milesValueRunning = 0.0;
  double _milesValueJogging = 0.0;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    // Load workout plans when the page is initialized
    Provider.of<WorkoutProvider>(context, listen: false).loadWorkoutPlans();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Record Workout")),
      body: Column(
        children: [
          // Dropdown to select a workout plan
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<WorkoutPlan>(
              value: _selectedPlan,
              hint: Text("Select a Workout Plan"),
              onChanged: (WorkoutPlan? newValue) {
                setState(() {
                  _selectedPlan = newValue;
                  recordedResults.clear(); // Clear previous results
                });
              },
              items: workoutProvider.workoutPlans.map((WorkoutPlan plan) {
                return DropdownMenuItem<WorkoutPlan>(
                  value: plan,
                  child: Text(plan.workoutPlan),
                );
              }).toList(),
            ),
          ),
          // Display exercises from the selected plan
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
    if (exercise.unitMeasurement == 'reps') {
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
    } else if (exercise.unitMeasurement == 'seconds') {
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
    } else if (exercise.exerciseName == 'Running') {
      return Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text('Miles', style: TextStyle(fontWeight: FontWeight.bold)),
                Slider(
                  value: _milesValueRunning,
                  min: 0,
                  max: 10,
                  label: _milesValueRunning.toStringAsFixed(1),
                  onChanged: (value) {
                    setState(() {
                      _milesValueRunning = value;
                      recordedResults[exercise] = _milesValueRunning.toInt();
                    });
                  },
                ),
                Text('${_milesValueRunning.toInt().toStringAsFixed(1)} miles'),
              ],
            ),
          ),
        ],
      );
    } else if (exercise.exerciseName == 'Jogging') {
      return Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text('Miles', style: TextStyle(fontWeight: FontWeight.bold)),
                Slider(
                  value: _milesValueJogging,
                  min: 0,
                  max: 10,
                  label: _milesValueJogging.toStringAsFixed(1),
                  onChanged: (value) {
                    setState(() {
                      _milesValueJogging = value;
                      recordedResults[exercise] = _milesValueJogging.toInt();
                    });
                  },
                ),
                Text('${_milesValueJogging.toInt().toStringAsFixed(1)} miles'),
              ],
            ),
          ),
        ],
      );
    }
    return SizedBox();
  }

  Future<void> _saveWorkout() async {
    if (_selectedPlan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a workout plan first.")),
      );
      return;
    }

    List<ExerciseResult> results = recordedResults.entries.map((entry) {
      return ExerciseResult(
        exercise: entry.key,
        achievedOutput: entry.value,
      );
    }).toList();

    Workout newWorkout = Workout(
      workoutDate: DateTime.now(),
      exerciseResults: results,
    );

    await DatabaseService().insertWorkout(newWorkout);

    Provider.of<WorkoutProvider>(context, listen: false).addWorkout(newWorkout);
    Navigator.pop(context);
  }
}
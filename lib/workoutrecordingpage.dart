import 'package:ecommerce/services/databaseservice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/exercise.dart';
import 'model/workoutplan.dart';
import 'package:ecommerce/workoutprovider.dart';
import 'model/exercise_result.dart';
import 'model/workout.dart';
import 'dart:async';

class WorkoutRecordingPage extends StatefulWidget {
  @override
  _WorkoutRecordingPageState createState() => _WorkoutRecordingPageState();
}

class _WorkoutRecordingPageState extends State<WorkoutRecordingPage> {
  final WorkoutPlan workoutPlan = WorkoutPlan.examplePlan();
  final Map<Exercise, dynamic> recordedResults = {};

  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  double _milesValueRunning = 0.0;
  double _milesValueJogging = 0.0;
  int _elapsedSeconds = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Record Workout")),
      body: ListView(
        children: workoutPlan.exerciseList.map((exercise) {
          return ListTile(
            title: Text(exercise.exerciseName),
            subtitle: _buildInputField(exercise),
          );
        }).toList(),
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
    }
    else if (exercise.unitMeasurement == 'seconds') {
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
    // Miles input using slider, max value 10 miles
    else if (exercise.exerciseName == 'Running') {
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
    }
    else if (exercise.exerciseName == 'Jogging') {
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

  String _formatDuration(Duration duration) {
    String hours = duration.inHours.toString().padLeft(2, '0');
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  Future<void> _saveWorkout() async {
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
    await DatabaseService.instance.insertWorkout(newWorkout);

    Provider.of<WorkoutProvider>(context, listen: false).addWorkout(newWorkout);
    Navigator.pop(context);
  }
}
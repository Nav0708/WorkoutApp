import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/exercise.dart';
import 'model/workoutplan.dart';
import 'package:ecommerce/workoutprovider.dart';
import 'model/exercise.dart';
import 'model/exercise_result.dart';
import 'model/workout.dart';
import 'model/workoutplan.dart';
import 'dart:async'; // Import this to use Timer

class WorkoutRecordingPage extends StatefulWidget {
  @override
  _WorkoutRecordingPageState createState() => _WorkoutRecordingPageState();
}

class _WorkoutRecordingPageState extends State<WorkoutRecordingPage> {
  final WorkoutPlan workoutPlan = WorkoutPlan.examplePlan();
  final Map<Exercise, dynamic> recordedResults = {};

  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  double _milesValue = 0.0;

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
      floatingActionButton: FloatingActionButton(
        onPressed: _saveWorkout,
        child: Icon(Icons.save),
      ),
    );
  }

  Widget _buildInputField(Exercise exercise) {
    // Text input for numeric values like weight or reps
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
    // Stopwatch input for time-based exercises (e.g., plank)
    else if (exercise.unitMeasurement == 'seconds') {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_stopwatch.isRunning) {
                    _stopwatch.stop();
                    _timer?.cancel(); // Stop the timer when the stopwatch stops
                  } else {
                    _stopwatch.start();
                    _timer = Timer.periodic(Duration(seconds: 1), (_) {
                      setState(() {}); // Trigger UI update every second
                    });
                  }
                });
              },
              child: Text(_stopwatch.isRunning ? 'Stop Timer' : 'Start Timer'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              _formatDuration(_stopwatch.elapsed),
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      );
    }
    // Miles input using slider, max value 10 miles
    else if (exercise.unitMeasurement == 'meters') {
      return Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text('Miles', style: TextStyle(fontWeight: FontWeight.bold)),
                Slider(
                  value: _milesValue,
                  min: 0,
                  max: 10,
                  label: _milesValue.toStringAsFixed(1),
                  onChanged: (value) {
                    setState(() {
                      _milesValue = value;
                      recordedResults[exercise] = _milesValue.toInt();
                    });
                  },
                ),
                Text('${_milesValue.toInt().toStringAsFixed(1)} miles'),
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

  void _saveWorkout() {
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

    Provider.of<WorkoutProvider>(context, listen: false).addWorkout(newWorkout);
    Navigator.pop(context);
  }
}

import 'package:ecommerce/workoutdetailspage.dart';
import 'package:ecommerce/workoutprovider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'model/exercise.dart';
import 'model/exercise_result.dart';
import 'model/workout.dart';
import 'workoutprovider.dart';
import 'workoutrecordingpage.dart';
import 'package:ecommerce/model/workoutplan.dart';

class WorkoutHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Workout History')),
      body: ListView.builder(
        itemCount: workoutProvider.workouts.length,
        itemBuilder: (context, index) {
          print(workoutProvider.workouts);
          final iworkout = workoutProvider.workouts[index];
          print(iworkout); // Debugging: Prints workout details to console
          return ListTile(
            title: Text('${DateFormat('dd MMM yyyy').format(iworkout.workoutDate)}'), // Corrected for DateTime object
            subtitle: Text('${iworkout.exerciseResults.length} exercises'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkoutDetails(workout: iworkout),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkoutRecordingPage(),
            ),
          );
          print("resutl $result");
          if (result != null && result is Map<String, int>) {

            final workout = Workout(
              workoutDate: DateTime.now(),
              exerciseResults: result.entries.map((entry) {
                print("print entry $entry");
                return ExerciseResult(exercise: Exercise( exerciseName: '', targetOutput: 0, unitMeasurement:entry.key), achievedOutput: entry.value); // Adjust as needed
              }).toList(),
            );
            workoutProvider.addWorkout(workout);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

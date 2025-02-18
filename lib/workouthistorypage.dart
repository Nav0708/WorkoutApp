import 'package:ecommerce/workoutdetailspage.dart';
import 'package:ecommerce/workoutprovider.dart';
import 'package:ecommerce/workoutselection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'downloadworkoutplan.dart';
import 'model/exercise.dart';
import 'model/exercise_result.dart';
import 'model/workout.dart';
import 'package:ecommerce/workoutprovider.dart';
import 'package:ecommerce/workoutrecordingpage.dart';

class WorkoutHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);
    return SafeArea(
          child: Scaffold(
              appBar: AppBar(title: Text('Workout History')),
              body: ListView.builder(
                itemCount: workoutProvider.workouts.length,
                itemBuilder: (context, index) {
                  print(workoutProvider.workouts);
                  final iworkout = workoutProvider.workouts[index];
                  print(iworkout); // Debugging: Prints workout details to console
                  return ListTile(
                    title: Text(
                        '${DateFormat('dd MMM yyyy').format(iworkout.workoutDate)}'),
                    // Corrected for DateTime object
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
              floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: 16),
                  FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => WorkoutSelectionPage()),
                      );
                    },
                    icon: Icon(Icons.new_label_rounded),
                    label: Text("New Workout"),
                  ),
                  SizedBox(height: 16),
                  // FloatingActionButton.extended(
                  //   onPressed: () async {
                  //     final result = await Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => WorkoutRecordingPage(Workout)),
                  //     );
                  //     if (result != null && result is Map<String, int>) {
                  //       final workout = Workout(
                  //         workoutDate: DateTime.now(),
                  //         exerciseResults: result.entries.map((entry) {
                  //           print("print entry $entry");
                  //           return ExerciseResult(exercise: Exercise(exerciseName: '',
                  //               targetOutput: 0,
                  //               unitMeasurement: entry.key),
                  //               achievedOutput: entry.value); // Adjust as needed
                  //         }).toList(),
                  //       );
                  //       workoutProvider.addWorkout(workout);
                  //     }
                  //   },
                  //   icon: Icon(Icons.add),
                  //   label: Text("Record Workout"),
                  // ),
                  SizedBox(height: 16),
                  FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DownloadWorkoutPage()),
                      );
                    },
                    icon: Icon(Icons.download),
                    label: Text("Download New Workout"),
                  ),

                ],
              )
          ),
    );
  }
}
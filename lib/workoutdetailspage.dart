import 'package:flutter/material.dart';
import '../model/workout.dart';

class WorkoutDetails extends StatelessWidget{
  final Workout workout;

  const WorkoutDetails({Key? key, required this.workout}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Workout Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Workout Date: ${workout.workoutDate}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Total Exercises: ${workout.exerciseResults.length}"),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: workout.exerciseResults.length,
                itemBuilder: (context, index) {
                  final exercise = workout.exerciseResults[index];
                  return ListTile(
                    title: Text("${exercise.exercise.exerciseName}- Acheived Output: ${exercise.achievedOutput}"),
                    subtitle: Text("Targeted: ${exercise.exercise.targetOutput}, Sets: ${exercise.exercise.unitMeasurement}"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
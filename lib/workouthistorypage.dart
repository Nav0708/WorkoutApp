import 'package:flutter/material.dart';
import 'workoutdetailspage.dart';
import 'package:ecommerce/model/data.dart';
class WorkoutHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Workout History')),
      body: ListView.builder(
        itemCount: workout.length,
        itemBuilder: (context, index) {
          final iworkout = workout[index];
          final successfulResults = iworkout.exerciseResults
              .where((result) => result.achievedOutput >= result.exercise.targetOutput)
              .length;

          return ListTile(
            title: Text('${iworkout.workoutDate.toLocal()}'.split(' ')[0]),
            subtitle: Text(
              '${iworkout.exerciseResults.length} exercises, $successfulResults successful',
            ),
            onTap: () {
              // Navigate to the WorkoutDetails page
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
    );
  }
}
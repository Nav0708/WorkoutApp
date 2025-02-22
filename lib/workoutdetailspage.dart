import 'package:flutter/material.dart';
import 'package:ecommerce/model/workout.dart';
class WorkoutDetails extends StatelessWidget {
  final Workout workout;

  WorkoutDetails({required this.workout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Workout Details')),
      body: ListView.builder(
        itemCount: workout.exerciseResults.length,
        itemBuilder: (context, index) {
          final result = workout.exerciseResults[index];
          final isSuccess = result.achievedOutput >=
              result.exercise.targetOutput;
          print(result.exercise.exerciseName);
          return ListTile(
            title: Text(result.exercise.exerciseName, style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),),
            subtitle: Text(
              'Target : ${result.exercise.targetOutput} ${result.exercise.unitMeasurement}\n'
                  'Achieved: ${result.achievedOutput} ${result.exercise.unitMeasurement}',
                style: TextStyle(fontSize: 16)
            ),
            trailing: Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: isSuccess ? Colors.green : Colors.red,
            ),
          );
        },
      ),
    );
  }
}

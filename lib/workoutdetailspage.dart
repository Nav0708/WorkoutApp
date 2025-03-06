import 'package:flutter/material.dart';
import '../model/workout.dart';

class WorkoutDetails extends StatelessWidget {
  final Workout workout;

  const WorkoutDetails({Key? key, required this.workout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Workout Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Workout Date: ${workout.workoutDate}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Total Exercises: ${workout.exerciseResults.length}"),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: workout.exerciseResults.length,
                itemBuilder: (context, index) {
                  final exercise = workout.exerciseResults[index];
                  final isGoalAchieved = exercise.achievedOutput >= exercise.exercise.targetOutput;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        exercise.exercise.exerciseName,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            "Achieved: ${exercise.achievedOutput} ${exercise.exercise.unitMeasurement}",
                            style: TextStyle(
                              color: isGoalAchieved ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Target: ${exercise.exercise.targetOutput} ${exercise.exercise.unitMeasurement}",
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isGoalAchieved ? "Goal Achieved" : "Goal Not Met",
                            style: TextStyle(
                              color: isGoalAchieved ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      trailing: Icon(
                        isGoalAchieved ? Icons.check_circle : Icons.warning,
                        color: isGoalAchieved ? Colors.green : Colors.red,
                      ),
                    ),
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
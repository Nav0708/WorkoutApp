import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'workoutprovider.dart';

class RecentPerformanceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutProvider>(
      builder: (context, workoutProvider, child) {
        int workoutCount = workoutProvider.workouts.length;
        final percet = (workoutCount / 7) * 100;
        return Container(
          padding: EdgeInsets.all(10),
          color: Colors.blueGrey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Workouts completion rate for the 7 days: ${percet.toStringAsFixed(1)}%",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10), // Space between text and progress bar
              LinearProgressIndicator(
                value: percet / 100, // Value between 0.0 and 1.0
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(percet >= 100 ? Colors.green : Colors.orange,),
              ),
            ],
          ),
        );
      },
    );
  }
}

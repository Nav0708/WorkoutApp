import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'workoutprovider.dart';

class RecentPerformanceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutProvider>(
      builder: (context, workoutProvider, child) {
        int workoutCount = workoutProvider.workouts.length;
        final percet=(workoutCount/7)*100;
        return Container(
          padding: EdgeInsets.all(10),
          color: Colors.blueAccent,
          child: Text(
            "Workouts completion rate in last 7 days: ${percet.toStringAsFixed(1)}%",
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }
}

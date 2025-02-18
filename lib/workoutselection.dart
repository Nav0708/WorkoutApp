import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'services/databaseservice.dart'; // Import DatabaseService
import 'model/workoutplan.dart';
import 'workoutrecordingpage.dart';

class WorkoutSelectionPage extends StatefulWidget {
  @override
  _WorkoutSelectionPageState createState() => _WorkoutSelectionPageState();
}

class _WorkoutSelectionPageState extends State<WorkoutSelectionPage> {
  List<WorkoutPlan> _workoutPlans = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWorkoutPlans();
  }

  Future<void> _fetchWorkoutPlans() async {
    try {
      final workoutPlans = await DatabaseService().getWorkoutPlans();
      setState(() {
        _workoutPlans = workoutPlans;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching workout plans: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select a Workout Plan")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : Padding(
        padding: EdgeInsets.all(10),
        child: _workoutPlans.isEmpty
            ? Center(child: Text("No workout plans found in the database."))
            : ListView.builder(
          itemCount: _workoutPlans.length,
          itemBuilder: (context, index) {
            final workoutPlan = _workoutPlans[index];
            return Card(
              child: ListTile(
                title: Text(
                  "Workout Plan: ${workoutPlan.workoutPlan}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Exercises: ${workoutPlan.exerciseList.map((exercise) => exercise.exerciseName).join(', ')}"),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to WorkoutRecordingPage with selected workout plan
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkoutRecordingPage(
                        selectedWorkoutPlan: workoutPlan,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:ecommerce/model/workoutplan.dart';
import 'package:ecommerce/services/databaseservice.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/model/workout.dart';

class WorkoutProvider with ChangeNotifier {
  List<Workout> _workouts = [];
  List<WorkoutPlan> _workoutPlans = [];
  List<Workout> get workouts => _workouts;
  List<WorkoutPlan> get workoutPlans => _workoutPlans;

  Future<void> loadWorkouts() async {
    _workouts = await DatabaseService().getWorkouts();
    notifyListeners();
  }

  Future<void> addWorkout(Workout workout) async {
    await DatabaseService().insertWorkout(workout);
    _workouts.add(workout);
    notifyListeners();
  }

  Future<void> loadWorkoutPlans() async {
    _workoutPlans = await DatabaseService().getWorkoutPlans();
    notifyListeners();
  }

  Future<void> addWorkoutPlan(WorkoutPlan workoutPlan) async {
    await DatabaseService().insertWorkoutPlan(workoutPlan);
    _workoutPlans.add(workoutPlan);
    notifyListeners();
  }
}

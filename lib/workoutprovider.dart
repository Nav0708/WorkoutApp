import '../model/workoutplan.dart';
import '../services/databaseservice.dart';
import 'package:flutter/material.dart';
import '../model/workout.dart';

class WorkoutProvider with ChangeNotifier {
  List<Workout> _workouts = [];
  List<WorkoutPlan> _workoutPlans = [];
  List<Workout> get workouts => _workouts;
  List<WorkoutPlan> get workoutPlans => _workoutPlans;

  // Future<void> loadWorkouts() async {
  //   try {
  //   _workouts = await DatabaseService().getWorkouts();
  //   _workouts=workouts;
  //   print("Loaded workouts: $_workouts");
  // } catch (e) {
  // print("Error loading workouts: $e");
  // }
  //   notifyListeners();
  // }
  // Future<void> addWorkout(Workout workout, String workoutPlanName) async {
  //   await DatabaseService().insertWorkout(workout, workoutPlanName);
  //   _workouts.add(workout);
  //   notifyListeners();
  // }
  //
  // Future<void> loadWorkoutPlans() async {
  //   _workoutPlans = await DatabaseService().getWorkoutPlans();
  //   notifyListeners();
  // }
  //
  // Future<void> addWorkoutPlan(WorkoutPlan workoutPlan) async {
  //   await DatabaseService().insertWorkoutPlan(workoutPlan);
  //   _workoutPlans.add(workoutPlan);
  //   notifyListeners();
  // }
}

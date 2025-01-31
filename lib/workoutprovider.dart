import 'package:ecommerce/model/workoutplan.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/model/workout.dart';

class WorkoutProvider with ChangeNotifier {
  final List<Workout> _workouts = [];

  List<Workout> get workouts => _workouts;

  void addWorkout(Workout workout) {
    _workouts.add(workout);

    notifyListeners();
  }
}

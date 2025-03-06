import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../model/workout.dart';
import '../workoutdetailspage.dart';

class WorkoutDetailsRoute extends GoRouteData {
  final Workout workout;

  WorkoutDetailsRoute(this.workout);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return WorkoutDetails(workout: workout);
  }
}
// import 'package:ecommerce/model/exercise.dart';
// import 'package:ecommerce/model/exercise_result.dart';
// import 'package:ecommerce/model/workout.dart';
// import 'package:ecommerce/workoutdetailspage.dart';
// import 'package:ecommerce/workouthistorypage.dart';
// import 'package:ecommerce/workoutprovider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:provider/provider.dart';
//
//
// void main() {
//   testWidgets('WorkoutHistoryPage shows multiple entries', (WidgetTester tester) async {
//     final workoutProvider = WorkoutProvider();
//     //workoutProvider.addWorkout(Workout(workoutDate: DateTime.now(), exerciseResults: [ExerciseResult(exercise: Exercise(exerciseName: 'Running', targetOutput:10,unitMeasurement: 'meters'), achievedOutput: 10)]));
//     //workoutProvider.addWorkout(Workout(workoutDate: DateTime.now(), exerciseResults: [ExerciseResult(exercise: Exercise(exerciseName: 'Push-Ups', targetOutput:20,unitMeasurement: 'reps'), achievedOutput: 20)]));
//     //workoutProvider.addWorkout(Workout(workoutDate: DateTime.now(), exerciseResults: [ExerciseResult(exercise: Exercise(exerciseName: 'Plank', targetOutput:60,unitMeasurement: 'seconds'), achievedOutput: 60)]));
//     await tester.pumpWidget(
//       ChangeNotifierProvider.value(
//         value: workoutProvider,
//         child: MaterialApp(home: WorkoutHistoryPage()),
//       ),
//     );
//
//     expect(find.byType(ListTile), findsWidgets);
//     expect(find.byType(ListTile), findsNWidgets(2));
//   });
//
//   testWidgets('WorkoutDetails shows correct exercise data', (WidgetTester tester) async {
//     final workout = Workout(
//       workoutId: 1,
//       workoutPlanId: 1,
//       exerciseId: 1,
//       workoutDate: DateTime.now(),
//       exerciseResults: [
//         ExerciseResult(exercise: Exercise(exerciseName: 'Push-ups', targetOutput: 30, unitMeasurement: 'repetitions', id: 1), achievedOutput: 10)
//       ], workoutPlanName: 'Strength',
//     );
//
//     await tester.pumpWidget(MaterialApp(home: WorkoutDetails(workout: workout)));
//     expect(find.text('Total Exercise: 5'), findsOneWidget);
//   });
// }

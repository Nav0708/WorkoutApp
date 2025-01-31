import 'package:ecommerce/model/exercise.dart';
import 'package:ecommerce/model/exercise_result.dart';
import 'package:ecommerce/model/workout.dart';
import 'package:ecommerce/workoutdetailspage.dart';
import 'package:ecommerce/workouthistorypage.dart';
import 'package:ecommerce/workoutprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';


void main() {
  testWidgets('WorkoutHistoryPage shows multiple entries', (WidgetTester tester) async {
    final workoutProvider = WorkoutProvider();
    workoutProvider.addWorkout(Workout(workoutDate: DateTime.now(), exerciseResults: []));

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: workoutProvider,
        child: MaterialApp(home: WorkoutHistoryPage()),
      ),
    );

    expect(find.byType(ListTile), findsWidgets);
  });

  testWidgets('WorkoutDetails shows correct exercise data', (WidgetTester tester) async {
    final workout = Workout(
      workoutDate: DateTime.now(),
      exerciseResults: [
        ExerciseResult(exercise: Exercise(exerciseName: 'Push-ups', targetOutput: 10, unitMeasurement: 'reps'), achievedOutput: 12)
      ],
    );

    await tester.pumpWidget(MaterialApp(home: WorkoutDetails(workout: workout)));

    expect(find.text('Push-ups'), findsOneWidget);
    expect(find.text('Target : 10 reps\nAchieved: 12 reps'), findsOneWidget);
  });
}

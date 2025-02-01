import 'package:ecommerce/model/exercise.dart';
import 'package:ecommerce/model/exercise_result.dart';
import 'package:ecommerce/model/workout.dart';
import 'package:ecommerce/model/workoutplan.dart';
import 'package:ecommerce/workoutprovider.dart';
import 'package:ecommerce/workoutrecordingpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  final testExercise = Exercise(exerciseName: 'Push-ups', targetOutput:20, unitMeasurement: 'reps');
  final workoutPlan = WorkoutPlan(workoutPlan:'Saturday morning workout',exerciseList: [testExercise]);

  testWidgets('WorkoutRecordingPage shows input for each exercise', (WidgetTester tester) async {
    final workoutProvider = WorkoutProvider();
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => WorkoutProvider(),
        child: MaterialApp(home: WorkoutRecordingPage()),
      ),
    );


    final textField = find.byType(TextField);
    final progressbar=find.byType(Slider);

    expect(textField, findsWidgets);
    expect(progressbar, findsWidgets);
    //expect(workoutProvider.workouts.length, 1);

  });

  testWidgets('WorkoutRecordingPage adds a Workout to shared state', (WidgetTester tester) async {
    final workoutProvider = WorkoutProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: workoutProvider,
        child: MaterialApp(home: WorkoutRecordingPage()),
      ),
    );
    await tester.enterText(find.byType(TextField).first, '20');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(workoutProvider.workouts.length, 1);
    Workout recordedWorkout = workoutProvider.workouts.first;
    expect(recordedWorkout.exerciseResults.length, 1);

    ExerciseResult testExercise = recordedWorkout.exerciseResults.first;
    expect(testExercise.exercise.exerciseName, 'Push-ups');
    expect(testExercise.achievedOutput, 20);
  });
}

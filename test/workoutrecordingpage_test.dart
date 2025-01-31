import 'package:ecommerce/workoutprovider.dart';
import 'package:ecommerce/workoutrecordingpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('WorkoutRecordingPage shows input for each exercise', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => WorkoutProvider(),
        child: MaterialApp(home: WorkoutRecordingPage()),
      ),
    );

    // Verify each exercise has an input field
    expect(find.byType(TextField), findsWidgets);
  });

  testWidgets('WorkoutRecordingPage adds a Workout to shared state', (WidgetTester tester) async {
    final workoutProvider = WorkoutProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: workoutProvider,
        child: MaterialApp(home: WorkoutRecordingPage()),
      ),
    );

    // Enter values into text fields
    await tester.enterText(find.byType(TextField).first, '30');

    // Tap finish workout button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify workout was added
    expect(workoutProvider.workouts.length, 1);
  });
}

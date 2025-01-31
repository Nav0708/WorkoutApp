import 'package:ecommerce/model/workout.dart';
import 'package:ecommerce/recentperformance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/workoutprovider.dart';

void main() {
  testWidgets('RecentPerformanceWidget displays a metric based on workouts', (WidgetTester tester) async {
    final workoutProvider = WorkoutProvider();
    workoutProvider.addWorkout(Workout(workoutDate: DateTime.now(), exerciseResults: []));

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: workoutProvider,
        child: MaterialApp(home: RecentPerformanceWidget()),
      ),
    );

    expect(find.textContaining('%'), findsOneWidget);
  });

  testWidgets('RecentPerformanceWidget shows default when no workouts', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => WorkoutProvider(),
        child: MaterialApp(home: RecentPerformanceWidget()),
      ),
    );

    expect(find.textContaining('0.0%'), findsOneWidget);
  });
}

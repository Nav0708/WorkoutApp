import 'workout.dart';
import 'exercise_result.dart';
import 'exercise.dart';

final workout =[ Workout(
  workoutDate: DateTime(2025, 1, 16),
  exerciseResults: [
    ExerciseResult(
      exercise: Exercise(
        exerciseName: 'Push-up',
        targetOutput: 50,
        unitMeasurement: 'repetitions',
      ),
      achievedOutput: 45,
    ),
    ExerciseResult(
      exercise: Exercise(
        exerciseName: 'Running',
        targetOutput: 5000,
        unitMeasurement: 'meters',
      ),
      achievedOutput: 4800,
    ),
    ExerciseResult(
      exercise: Exercise(
        exerciseName: 'Running',
        targetOutput: 5000,
        unitMeasurement: 'meters',
      ),
      achievedOutput: 4800,
    ),
  ],
),
Workout(
  workoutDate: DateTime(2025, 1, 15),
  exerciseResults: [
    ExerciseResult(
      exercise: Exercise(
        exerciseName: 'Push-up',
        targetOutput: 50,
        unitMeasurement: 'repetitions',
      ),
      achievedOutput: 50,
    ),
    ExerciseResult(
      exercise: Exercise(
        exerciseName: 'Push-up',
        targetOutput: 50,
        unitMeasurement: 'repetitions',
      ),
      achievedOutput: 110,
    ),
  ]
)
];


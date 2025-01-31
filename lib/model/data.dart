import 'workout.dart';
import 'exercise_result.dart';
import 'exercise.dart';

final workout =[ Workout(
  workoutDate: DateTime(2025, 1, 1),
  exerciseResults: [
    ExerciseResult(exercise: Exercise(exerciseName: 'Squat', targetOutput: 20, unitMeasurement: 'repetitions'),
        achievedOutput: 25),
    ExerciseResult(
      exercise: Exercise(exerciseName: 'Running', targetOutput: 1000, unitMeasurement: 'meters'),
      achievedOutput: 2000,
    ),
    ExerciseResult(
      exercise: Exercise(exerciseName: 'Cycling', targetOutput: 5000, unitMeasurement: 'meters'),
      achievedOutput: 4800,
    ),
    ExerciseResult(
      exercise: Exercise(exerciseName: 'Sit-ups', targetOutput: 15, unitMeasurement: 'repetitions'),
      achievedOutput: 10,
    ),
  ],
),
Workout(
  workoutDate: DateTime(2025, 1, 2),
  exerciseResults: [
    ExerciseResult(
      exercise: Exercise(exerciseName: 'Plank', targetOutput: 30, unitMeasurement: 'repetitions'),
      achievedOutput: 40,
    ),
    ExerciseResult(
      exercise: Exercise(exerciseName: 'Push-up', targetOutput: 20, unitMeasurement: 'repetitions'),
      achievedOutput: 30,
    ),
  ]
),
  Workout(
      workoutDate: DateTime(2025, 1, 3),
      exerciseResults: [
        ExerciseResult(exercise: Exercise(exerciseName: 'Sit-ups', targetOutput: 50, unitMeasurement: 'repetitions'),
          achievedOutput: 40,
        ),
        ExerciseResult(exercise: Exercise(exerciseName: 'Jogging', targetOutput: 800, unitMeasurement: 'meters'),
          achievedOutput: 110,
        ),
        ExerciseResult(exercise: Exercise(exerciseName: 'Plank', targetOutput: 20, unitMeasurement: 'repetitions'),
          achievedOutput: 10,
        ),
      ]
  )
];


import 'exercise.dart';

class WorkoutPlan {
  final String workoutPlan;
  final List<Exercise> exerciseList;

  WorkoutPlan({required this.workoutPlan, required this.exerciseList});

  static WorkoutPlan examplePlan() {
    return WorkoutPlan(
      workoutPlan: "Full Body Strength",
      exerciseList: [
        Exercise(exerciseName: "Push-ups",  targetOutput: 20, unitMeasurement: "reps"),
        Exercise(exerciseName: "Plank", targetOutput: 20,unitMeasurement: "seconds"),
        Exercise(exerciseName: "Running", targetOutput: 40,  unitMeasurement: "meters"),
        Exercise(exerciseName: "Push-ups", targetOutput: 30,  unitMeasurement: "reps"),
        Exercise(exerciseName: "Plank", targetOutput: 10,unitMeasurement: "seconds"),
        Exercise(exerciseName: "Running", targetOutput: 20,  unitMeasurement: "meters"),
        Exercise(exerciseName: "Push-ups", targetOutput: 30,  unitMeasurement: "reps"),
      ],
    );
  }
}
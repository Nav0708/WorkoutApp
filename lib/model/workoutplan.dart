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
        Exercise(exerciseName: "Squats", targetOutput: 30,  unitMeasurement: "reps"),
        Exercise(exerciseName: "Burpees", targetOutput: 10,unitMeasurement: "seconds"),
        Exercise(exerciseName: "Jogging", targetOutput: 20,  unitMeasurement: "meters"),
        Exercise(exerciseName: "Sit-ups", targetOutput: 20,  unitMeasurement: "reps"),
      ],
    );
  }
}
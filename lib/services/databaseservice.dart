// import 'dart:convert';
//
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import '../model/exercise_result.dart';
// import '../model/workout.dart';
// import '../model/exercise.dart';
// import '../model/workoutplan.dart';
//
// class DatabaseService {
//   static final DatabaseService _instance = DatabaseService._internal();
//   factory DatabaseService() => _instance;
//   static Database? _database;
//
//   DatabaseService._internal();
//
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }
//
//   Future<Database> _initDatabase() async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, 'workoutapp.db');
//     return await openDatabase(
//       path,
//       version: 2,
//       onCreate: (db, version) async {
//           // Create exercises table
//           await db.execute('''
//     CREATE TABLE exercises (
//       id INTEGER PRIMARY KEY AUTOINCREMENT,
//       exerciseName TEXT NOT NULL,
//       targetOutput INTEGER NOT NULL,
//       unitMeasurement TEXT NOT NULL
//     )
//   ''');
//           await db.execute('''
//     CREATE TABLE workouts (
//       id INTEGER PRIMARY KEY AUTOINCREMENT,
//       workoutDate TEXT NOT NULL,
//       workoutPlanId INTEGER,
//       exerciseId INTEGER,
//       exerciseResultId INTEGER,
//       excerciseList TEXT,
//       FOREIGN KEY (exerciseId) REFERENCES exercises(id) ON DELETE SET NULL
//       FOREIGN KEY (exerciseResultId) REFERENCES exercise_result(id) ON DELETE SET NULL
//       FOREIGN KEY (workoutPlanId) REFERENCES workout_plan(id) ON DELETE CASCADE
//     )
//   ''');
//           await db.execute('''
//     CREATE TABLE exercise_result (
//       id INTEGER PRIMARY KEY AUTOINCREMENT,
//       workoutId INTEGER,
//       exerciseId INTEGER,
//       workoutPlanId INTEGER,
//       achievedOutput INTEGER NOT NULL,
//       FOREIGN KEY (exerciseId) REFERENCES exercises(id) ON DELETE CASCADE,
//       FOREIGN KEY (workoutId) REFERENCES workouts(id) ON DELETE CASCADE
//     )
//   ''');
//           await db.execute('''
//     CREATE TABLE  workout_plan (
//       id INTEGER PRIMARY KEY AUTOINCREMENT,
//       exerciseId INTEGER,
//       workoutPlan TEXT NOT NULL,
//       exerciseList TEXT,
//       FOREIGN KEY (exerciseId) REFERENCES exercises(id) ON DELETE SET NULL
//     )
//   ''');
//       },
//     );
//   }
//
//   Future<void> insertWorkout(Workout workout, String workoutPlan) async {
//     final db = await database;
//     await db.insert(
//       'workouts',
//       {
//         'workoutDate': workout.workoutDate.toIso8601String(),
//         'workoutPlanId': workout.workoutPlanId,
//       },
//     );
//     for (var res in workout.exerciseResults) {
//       await db.insert(
//         'exercise_result',
//         {
//           'workoutPlanId': workout.workoutPlanId,
//           'achievedOutput': res.achievedOutput,
//           'workoutId': workout.workoutId,
//         },
//       );
//     }
//   }
//
//   Future<List<Workout>> getAllWorkouts() async {
//     final db = await database;
//     final List<Map<String, dynamic>> workoutRows = await db.query('workouts');
//     List<Workout> workouts = [];
//     int workoutPlanId;
//     int workoutId;
//     String workoutDate;
//
//     for (var workoutRow in workoutRows) {
//       workoutId = workoutRow['id'];
//       workoutDate = workoutRow['workoutDate'];
//       workoutPlanId = workoutRow['workoutPlanId'];
//
//       final List<Map<String, dynamic>> workoutPlanRows = await db.query(
//         'workout_plan',
//         where: 'id = ?',
//         whereArgs: [workoutPlanId],
//       );
//
//       String workoutPlanName = workoutPlanRows[0]['exerciseList'];
//
//       List<dynamic> exercisesJson = jsonDecode(workoutPlanRows[0]['exerciseList']);
//
//       final List<Map<String, dynamic>> exerciseResultRows = await db.query(
//         'exercise_result',
//         where: 'workoutPlanId = ?',
//         whereArgs: [workoutPlanId],
//       );
//       List<ExerciseResult> exerciseResults = [];
//       Exercise exer;
//       for (var exercise in exercisesJson) {
//           var resultRow = exerciseResultRows.firstWhere(
//                   (row) => row['workoutPlanId'] == workoutPlanId);
//         Exercise exer = Exercise(
//           exerciseName: exercise['exerciseName'],
//           targetOutput: exercise['targetOutput'],
//           unitMeasurement: exercise['unitMeasurement'],
//         );
//           exerciseResults.add(
//             ExerciseResult(
//               exercise: exer,
//               achievedOutput: resultRow['achievedOutput'],
//             ),
//           );
//       }
//
//       workouts.add(
//         Workout(
//           workoutId: workoutId,
//           exerciseId: 0,
//           workoutPlanId: workoutPlanId,
//           workoutDate: DateTime.parse(workoutDate),
//           workoutPlanName: workoutPlanName,
//           exerciseResults: exerciseResults,
//         ),
//       );
//     }
//
//     return workouts;
//   }
//
//
//   Future<List<Workout>> getWorkouts() async {
//     final db = await database;
//     int workoutId = 0;
//     int workoutplanId = 0;
//     List<dynamic> exercisesJson=[];
//     String workoutDate = '';
//     List<Map<String, dynamic>> workoutRows=[];
//     int achievedOutput = 0;
//
//     workoutRows = await db.query('workouts');
//     List<Workout> workouts = [];
//
//     for (var workoutRow in workoutRows) {
//       workoutId = workoutRow['id'];
//       String workoutDate = workoutRow['workoutDate'];
//       workoutplanId = workoutRow['workoutPlanId'];
//
//       final List<Map<String, dynamic>> exerciseResultRows = await db.query(
//         'exercise_result',
//         where: 'workoutId = ?',
//         whereArgs: [workoutId],
//       );
//       for (var exerciseResultRow in exerciseResultRows) {
//         achievedOutput=exerciseResultRow['achievedOutput'];
//       }
//
//       final List<Map<String, dynamic>> workoutplanRows = await db.query(
//         'workout_plan',
//         where: 'id = ?',
//         whereArgs: [workoutplanId],
//       );
//       for (var workoutplanRow in workoutplanRows) {
//         final List<Map<String, dynamic>> workoutplanJson = await db.query(
//           'workout_plan',
//           where: 'id = ?',
//           whereArgs: [workoutplanRow['id']],
//         );
//         exercisesJson = jsonDecode(workoutplanJson.last['exerciseList']);
//         List<Exercise> exerciseList = exercisesJson.map((e) => Exercise.fromJson(e)).toList();
//         workouts.add(
//           Workout(
//             exerciseId: 0,
//             workoutId: workoutId,
//             workoutDate: DateTime.parse(workoutDate),
//             workoutPlanName: workoutplanRow['workoutPlan'],
//             exerciseResults: exerciseList.map((e) =>
//                 ExerciseResult(exercise: e, achievedOutput: achievedOutput)).toList(), workoutPlanId: 0,
//           ),
//         );
//       }
//     }
//     print("Fetched workouts: $workouts");
//     return workouts;
//   }
//
//   Future<void> insertWorkoutPlan(WorkoutPlan workoutPlan) async {
//     final db = await database;
//     List<Map<String, dynamic>> updatedExerciseList = [];
//     List<int> exerciseIds = [];
//
//     for (var exercise in workoutPlan.exerciseList) {
//       int exerciseId = await db.insert(
//         'exercises',
//         {
//           'exerciseName': exercise.exerciseName,
//           'targetOutput': exercise.targetOutput,
//           'unitMeasurement': exercise.unitMeasurement,
//         },
//       );
//
//       exerciseIds.add(exerciseId);
//       updatedExerciseList.add({
//         'exerciseId': exerciseId,
//         'exerciseName': exercise.exerciseName,
//         'targetOutput': exercise.targetOutput,
//         'unitMeasurement': exercise.unitMeasurement,
//       });
//     }
//
//     await db.insert(
//       'workout_plan',
//       {
//         'exerciseId': jsonEncode(exerciseIds),
//         'workoutPlan': workoutPlan.workoutPlan,
//         'exerciseList': jsonEncode(updatedExerciseList),
//       },
//     );
//   }
//   Future<List<WorkoutPlan>> getWorkoutPlans() async {
//     final db = await database;
//     final List<Map<String, dynamic>> workoutPlanRows = await db.query('workout_plan');
//     return workoutPlanRows.map((row) => WorkoutPlan.fromRow(row)).toList();
//   }
// }
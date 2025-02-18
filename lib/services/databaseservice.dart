import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/workout.dart';
import '../model/workoutplan.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  static Database? _database;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'workoutapp.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE workout_plan (
            workoutPlan TEXT NOT NULL,
            exerciseList TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> insertWorkout(Workout workout) async {
    final db = await database;
    await db.insert(
      'workouts',
      workout.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Workout>> getWorkouts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('workouts');

    return List.generate(maps.length, (i) {
      return Workout.fromMap(maps[i]);
    });
  }

  Future<void> insertWorkoutPlan(WorkoutPlan workoutPlan) async {
    final db = await database;
    await db.insert(
      'workout_plan',
      workoutPlan.toMap()
    );
  }

  Future<List<WorkoutPlan>> getWorkoutPlans() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('workout_plan');
    print("Maps: $maps");
    return List.generate(maps.length, (i) {
      return WorkoutPlan.fromMap(maps[i]);
    });
  }
}
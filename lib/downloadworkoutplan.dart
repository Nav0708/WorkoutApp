import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../model/workoutplan.dart';
import '../services/databaseservice.dart';
import '../workoutprovider.dart';
import 'model/exercise.dart';

class DownloadWorkoutPage extends StatefulWidget {
  @override
  _DownloadWorkoutPageState createState() => _DownloadWorkoutPageState();
}

class _DownloadWorkoutPageState extends State<DownloadWorkoutPage> {
  final TextEditingController _urlController = TextEditingController();
  List<Exercise> _exercises = [];
  bool _isLoading = false;
  String? _error;

  Future<void> _fetchWorkoutPlan() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await http.get(Uri.parse(_urlController.text));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final exercises = (data['exercises'] as List)
            .map((e) => Exercise.fromMap(e))
            .toList();
        setState(() => _exercises = exercises);
      } else {
        setState(() => _error = "Failed to fetch workout plan.");
      }
    } catch (e) {
      setState(() => _error = "Invalid URL or network issue.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveWorkoutPlan() async {
    if (_exercises.isNotEmpty) {
      final workoutPlan = WorkoutPlan(
        workoutPlan: "Downloaded Plan",
        exerciseList: _exercises,
      );

      // Save to database
      await DatabaseService().insertWorkoutPlan(workoutPlan);

      // Notify provider
      final workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
      workoutProvider.addWorkoutPlan(workoutPlan);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Workout Plan Saved!')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Download Workout Plan")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(labelText: "Enter Workout Plan URL"),
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _fetchWorkoutPlan,
              child: _isLoading ? CircularProgressIndicator() : Text("Download"),
            ),
            if (_error != null)
              Text(_error!, style: TextStyle(color: Colors.red)),
            if (_exercises.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _exercises.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_exercises[index].exerciseName),
                      subtitle: Text(
                        "${_exercises[index].targetOutput} ${_exercises[index].unitMeasurement}",
                      ),
                    );
                  },
                ),
              ),
            if (_exercises.isNotEmpty)
              ElevatedButton(
                onPressed: _saveWorkoutPlan,
                child: Text("Save Workout Plan"),
              ),
          ],
        ),
      ),
    );
  }
}
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ecommerce/services/databaseservice.dart';

import 'model/data.dart';

class DownloadWorkoutPage extends StatefulWidget {
  @override
  _DownloadWorkoutPageState createState() => _DownloadWorkoutPageState();
}

class _DownloadWorkoutPageState extends State<DownloadWorkoutPage> {
  final TextEditingController _urlController = TextEditingController();
  List<String> _exercises = [];
  DateTime _workoutDate = DateTime.now();
  bool _isLoading = false;
  String? _error;

  Future<void> fetchWorkout() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await http.get(Uri.parse(_urlController.text));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          _workoutDate = data['workoutDate'];
          _exercises = List<String>.from(data['exercises']);
        });
      } else {
        setState(() => _error = "Failed to fetch workout plan.");
      }
    } catch (e) {
      setState(() => _error = "Invalid URL or network issue.");
    }

    setState(() => _isLoading = false);
  }

  Future<void> saveWorkout() async {
    if (_exercises.isNotEmpty) {
      // await DatabaseService.instance.insertWorkout(
      //   Workout(workoutDate:_workoutDate,
      //   exercises: json.encode(_exercises)),
      // );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Workout Saved!')),
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
              onPressed: fetchWorkout,
              child: Text("Download"),
            ),
            if (_isLoading) CircularProgressIndicator(),
            if (_error != null) Text(_error!, style: TextStyle(color: Colors.red)),
            if (_workoutDate != null && _exercises.isNotEmpty)
              Column(
                children: [
                  Text("Workout: $_workoutDate", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ..._exercises.map((exercise) => Text("- $exercise")).toList(),
                  ElevatedButton(
                    onPressed: saveWorkout,
                    child: Text("Save Workout"),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

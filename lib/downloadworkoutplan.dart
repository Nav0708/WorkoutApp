import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
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
  String _workoutPlanName = '';
  bool _isLoading = false;
  String? _error;
  String _selectedCategory = 'Select a Workout Plan';
  List<String> _categories = [];
  bool _isCategoriesLoading = true;

  Future<void> _fetchCategories() async {
    setState(() {
      _isCategoriesLoading = true;
      _error = null;
    });

    try {
      final String baseUrl = _urlController.text;
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final document = html.parse(response.body);
        final links = document.getElementsByTagName('a');

        List<String> categories = [];
        for (var link in links) {
          final categoryText = link.text.trim();
          if (categoryText.isNotEmpty) {
            categories.add(categoryText);
          }
        }
        setState(() {
          _categories = categories;
        });
      } else {
        setState(() => _error = "Failed to fetch categories.");
      }
    } catch (e) {
      setState(() => _error = "Invalid URL or network issue.");
    } finally {
      setState(() => _isCategoriesLoading = false);
    }
  }

  Future<void> _fetchWorkoutPlan() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _workoutPlanName = '';
      _exercises = [];
    });

    try {
      final String baseUrl = _urlController.text;
      if (_selectedCategory == 'Select a Workout Plan') {
        setState(() => _error = "Please select a category.");
        return;
      }
      final smallcase=_selectedCategory.toLowerCase();
      final String fullUrl = "$baseUrl/$smallcase.json";
      print("Full URL: $fullUrl"); // Correct URL construction
      final response = await http.get(Uri.parse(fullUrl));
      print("Response Status Code: ${response.body}");
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final workoutPlan = WorkoutPlan(
          workoutPlan: data['name'],
          exerciseList: (data['exercises'] as List)
              .map((e) => Exercise(
            exerciseName: e['name'],
            targetOutput: e['target'],
            unitMeasurement: e['unit'],
          ))
              .toList(),
        );

        setState(() {
          _workoutPlanName = workoutPlan.workoutPlan;
          _exercises = workoutPlan.exerciseList;
        });
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
        workoutPlan: _workoutPlanName,
        exerciseList: _exercises,
      );
      try {
        final firestore = FirebaseFirestore.instance;

        final workoutPlanMap = {
          'workoutPlan': workoutPlan.workoutPlan,
          'exerciseList': workoutPlan.exerciseList.map((exercise) =>
          {
            'exerciseName': exercise.exerciseName,
            'targetOutput': exercise.targetOutput,
            'unitMeasurement': exercise.unitMeasurement,
          }).toList(),
        };
        await firestore.collection('workoutPlans').add(workoutPlanMap);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download Success!! Workout Plan saved to Firestore!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save workout plan: $e')),
        );
      }
      Navigator.pop(context);
    }
  }

  void _discardWorkoutPlan() {
    setState(() {
      _workoutPlanName = '';
      _exercises = [];
      _urlController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Workout plan discarded')),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchCategories();
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
              decoration: InputDecoration(labelText: "Enter URL( https://exercise-app-8299a.web.app/exercises/)"),
            ),
            ElevatedButton(
              onPressed: _isCategoriesLoading ? null : _fetchCategories,
              child: _isCategoriesLoading
                  ? CircularProgressIndicator()
                  : Text("Enter a URL for workout plans"),
            ),
            Text("enter url https://exercise-app-8299a.web.app/exercises/"),
            Text("provides a list of catergories from json file"),
            if (_categories.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = _selectedCategory == category;
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: isSelected ? Colors.blueAccent : Colors.transparent,
                          width: 2,
                        ),
                      ),
                        child: ListTile(
                            title: Text(category),
                            trailing: _isLoading && _selectedCategory == category
                                    ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                                    : Icon(Icons.arrow_forward),
                            onTap: () {
                            setState(() {_selectedCategory = category;});
                            if (!_isLoading) {
                              _fetchWorkoutPlan();
                            }
                            child: _isLoading ? CircularProgressIndicator() : Text("View Workout Plan");
                            },
                      ),
                    );
                  },
                ),
              ),
            if (_categories.isEmpty && !_isCategoriesLoading)
              Text("No categories found", style: TextStyle(color: Colors.red)),
            if (_error != null)
              Text(_error!, style: TextStyle(color: Colors.red)),
            if (_workoutPlanName.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Workout Plan: $_workoutPlanName",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            if (_exercises.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = _exercises[index];
                    return Card(
                      child: ListTile(
                        title: Text(exercise.exerciseName),
                        subtitle: Text(
                          "${exercise.targetOutput} ${exercise.unitMeasurement}",
                        ),
                      ),
                    );
                  },
                ),
              ),
            if (_exercises.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _saveWorkoutPlan,
                    child: Text("Download Workout Plan"),
                  ),
                  ElevatedButton(
                    onPressed: _discardWorkoutPlan,
                    child: Text("Discard"),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
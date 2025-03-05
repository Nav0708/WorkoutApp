import 'package:WorkoutApp/qrcode/qrcodepage.dart';
import 'package:WorkoutApp/qrcode/qrcodescannerpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/databaseservice.dart';
import 'package:flutter/material.dart';
import 'model/workout.dart';
import 'package:go_router/go_router.dart';

class WorkoutHistoryPage extends StatefulWidget {
  @override
  _WorkoutHistoryPageState createState() => _WorkoutHistoryPageState();
}

class _WorkoutHistoryPageState extends State<WorkoutHistoryPage> {
  List<Workout> _workout = [];
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchWorkouts();
  }
  Future<void> _fetchWorkouts() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("No authenticated user found.");
        return;
      }
      print("Fetching workouts for user: ${user.uid}");

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('workout_results')
          .where('userId', isEqualTo: user.uid)
          .orderBy('timestamp', descending: true)
          .get();
      print("Fetched workouts: $querySnapshot");
      List<Workout> workouts = querySnapshot.docs.map((doc) {
        return Workout.fromFirestore(doc);
      }).toList();
      print("Fetched workouts: $workouts");
      setState(() {
        _workout = workouts;
      });
  } catch (e) {
  print("Error fetching workouts: $e");
  } finally {
  setState(() {
  _isLoading = false;
  });
  }
}


@override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Workout History')),
        body: _workout.isEmpty
            ? Center(child: Text("Begin a new workout."))
            : ListView.builder(
          itemCount: _workout.length,
          itemBuilder: (context, index) {
            final iworkout = _workout[index];
            return ListTile(
              title: Text('${iworkout.workoutDate}'),
              subtitle: Text('${iworkout.exerciseResults.length} exercises'),
              onTap: () {
                context.push('/workout-details', extra: iworkout);
              },
            );
          },
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(height: 16),
            FloatingActionButton.extended(
              onPressed: () {
                context.push('/workout-selection');
              },
              icon: Icon(Icons.new_label_rounded),
              label: Text("Start a new Workout"),
            ),
            SizedBox(height: 16),
            FloatingActionButton.extended(
              onPressed: () {
                context.push('/download-workout');
              },
              icon: Icon(Icons.download),
              label: Text("Download New Workout"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {context.push('/join-workout');},
              child: const Text('Join Workout'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRCodePage(inviteCode: "123456"),
                  ),
                );
              },
              child: const Text('Generate QR Code'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QRScannerPage(),
                  ),
                );
              },
              child: const Text('Scan QR Code'),
            ),
          ],
        ),
      ),
    );
  }
}
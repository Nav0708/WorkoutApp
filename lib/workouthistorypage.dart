import 'package:WorkoutApp/qrcode/qrcodepage.dart';
import 'package:WorkoutApp/qrcode/qrcodescannerpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
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
              title: Text(
                DateFormat('MMM dd, yyyy - hh:mm a').format(iworkout.workoutDate),
                style: TextStyle(fontWeight: FontWeight.w500)
              ),
              subtitle: Row(
                children: [
                  Icon(Icons.fitness_center, size: 16),
                  Text(' ${iworkout.exerciseResults.length} exercises'),
                  SizedBox(width: 10),
                  Icon(Icons.check_circle, size: 16, color: Colors.green),
                  Text(' ${_calculateCompleted(iworkout)} achieved'),
                ],
              ),
              onTap: () {
                context.push('/workout-details', extra: iworkout);
              },
            );
          },
        ),
        bottomNavigationBar: _buildBottomNavBar(),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavButton(
            icon: Icons.fitness_center,
            label: 'New Workout',
            onPressed: () => context.push('/workout-selection'),
          ),
          _buildNavButton(
            icon: Icons.download,
            label: 'Download',
            onPressed: () => context.push('/download-workout'),
          ),
          _buildNavButton(
            icon: Icons.group_add,
            label: 'Join Group',
            onPressed: () => context.push('/join-workout'),
          ),
          _buildNavButton(
            icon: Icons.qr_code,
            label: 'Generate QR',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QRCodePage(inviteCode: "123456"),
              ),
            ),
          ),
          _buildNavButton(
            icon: Icons.qr_code_scanner,
            label: 'Scan QR',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const QRScannerPage(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: onPressed,
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}
int _calculateCompleted(Workout workout) {
  return workout.exerciseResults.where((result) {
    return result.achievedOutput >= result.exercise.targetOutput;
  }).length;
}
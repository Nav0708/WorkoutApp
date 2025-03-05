import 'package:WorkoutApp/qrcode/qrcodepage.dart';
import 'package:WorkoutApp/qrcode/qrcodescannerpage.dart';
import 'package:WorkoutApp/workoutdetailspage.dart';
import 'package:WorkoutApp/workoutprovider.dart';
import 'package:WorkoutApp/workoutselection.dart';
import 'package:go_router/go_router.dart';

import './services/AuthService.dart';
import './services/workoutfirestoreservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'downloadworkoutplan.dart';
import 'firebase_auth/firebase_options.dart';
import 'joinworkoutpage.dart';
import 'model/workout.dart';
import 'workouthistorypage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'recentperformance.dart';

Future<void> clearAuthState() async {
  await FirebaseAuth.instance.signOut();
  print('User signed out');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    print('Firebase initialized successfully');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  await clearAuthState();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
      ],
      child: MyApp(),
    ),
  );
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => AuthChecker(), // Use AuthChecker as the root
    ),
    GoRoute(
      path: '/workout-details',
      builder: (context, state) {
        final workout = state.extra as Workout;
        return WorkoutDetails(workout: workout);
      },
    ),
    GoRoute(
      path: '/workout-selection',
      builder: (context, state) => WorkoutSelectionPage(),
    ),
    GoRoute(
      path: '/download-workout',
      builder: (context, state) => DownloadWorkoutPage(),
    ),
    GoRoute(
      path: '/join-workout',
      builder: (context, state) => JoinWorkoutPage(),
    ),
    GoRoute(
      path: '/generate-qr',
      builder: (context, state) {
        final inviteCode = state.extra as String;
        return QRCodePage(inviteCode: inviteCode);
      },
    ),
    GoRoute(
      path: '/scan-qr',
      builder: (context, state) => QRScannerPage(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Workout App',
      routerConfig: _router, // Use the GoRouter configuration
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}

class AuthChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return FutureBuilder(
      future: authService.ensureSignedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          body: Column(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: RecentPerformanceWidget(),
              ),
              Expanded(
                child: WorkoutHistoryPage(),
              ),
            ],
          ),
        );
      },
    );
  }
}
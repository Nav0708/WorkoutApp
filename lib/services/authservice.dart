import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService with ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;
  AuthService() {
    _auth.authStateChanges().listen((user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  User? get currentUser => _currentUser;

  Future<User?> signInAnomymously() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        UserCredential result = await FirebaseAuth.instance.signInAnonymously();
        user = result.user;
    }
    if (user != null) {
      print("Signed in anonymously: ${user.uid}");
    }
    return user;
  }
  catch (e) {
    print("Error signing in anonymously: $e");
  return null;
  }
  }
  Future<User?> ensureSignedIn() async {
    if(currentUser == null)  {
      return await signInAnomymously();

    }else{
      return currentUser;
    }
  }

}
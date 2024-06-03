import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../redux/actions/fetchUserData.dart';

class Auth extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? _user;
  final fetch = FetchData();

  User? getUser() {
    return _user;
  }

  Auth() {
    auth.authStateChanges().listen((user) async {
      _user = user;
      notifyListeners();
    });
  }

  Future<bool?> signIn({
    required String username,
    required String password,
    required bool isStudent,
  }) async {
    bool? success;
    try {
      success = await fetch.getUserType(username);

      if (success != null) {
        print(success == isStudent);
        if (isStudent == success) {
          await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: username, password: password)
              .then((UserCredential result) async {
            //we got user
            _user = result.user;
            // _isStudent = success;

            if (success != null) {
              await fetch
                  .fetchStudentData(username)
                  .onError((error, stackTrace) {
                // return false;
              });
            } else {
              await fetch
                  .fetchFacultyData(username)
                  .onError((error, stackTrace) {
                // return false;
              });
            }
          });
          return true;
        } else {
          return false;
        }
      }
      notifyListeners();
      return null;
      // return _userFromCredUser(user);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await auth.signOut().then((_) {
        _user = null;
        notifyListeners();
      });
    } catch (e) {
      // return null;
    }
    // return null;
  }

  Future resetPassword(email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseException {
      return false;
    }
  }

  Future<bool?> createUser(
      {required String username,
      required String password,
      required bool isStudent}) async {
    bool? success;
    try {
      success = await fetch.getUserType(username);

      if (success != null) {
        if (isStudent == success) {
          await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: username, password: password)
              .then((UserCredential result) async {
            //we got user
            _user = result.user;
            // _isStudent = success;

            if (success!) {
              await fetch
                  .fetchStudentData(username)
                  .onError((error, stackTrace) {
                // return false;
              });
            } else {
              await fetch
                  .fetchFacultyData(username)
                  .onError((error, stackTrace) {
                // return false;
              });
            }
            return true;
          });
        }
      }
      notifyListeners();
      return null;
      // return _userFromCredUser(user);
    } on FirebaseAuthException {
      rethrow;
    }
  }
}

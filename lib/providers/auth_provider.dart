import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  AuthProvider() {
    // Listen to auth state changes
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();

      if (_user != null && onUserLoggedIn != null) {
        onUserLoggedIn!();
      }
    });

    // Check for an already signed-in user on app restart
    _initializeCurrentUser();
  }

  Future<void> Function()? onUserLoggedIn;
  void Function()? onUserLoggedOut;

  void _initializeCurrentUser() async {
    _user = _auth.currentUser;
    if (_user != null && onUserLoggedIn != null) {
      await onUserLoggedIn!();
    }
    notifyListeners();
  }

  Future<void> signUpWithEmail(String email, String password) async {
    _setLoading(true);
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (onUserLoggedIn != null) await onUserLoggedIn!();
    } catch (e) {
      debugPrint("Sign Up Error: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loginWithEmail(String email, String password) async {
    _setLoading(true);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (onUserLoggedIn != null) await onUserLoggedIn!();
    } catch (e) {
      debugPrint("Login Error: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await _auth.signOut();
      if (onUserLoggedOut != null) onUserLoggedOut!();
    } catch (e) {
      debugPrint("Logout Error: $e");
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

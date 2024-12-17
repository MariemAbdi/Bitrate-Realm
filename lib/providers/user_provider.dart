import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> fetchUserData(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final docSnapshot = await _firestore.collection('users').doc(userId).get();
      if (docSnapshot.exists) {
        _user = UserModel.fromJson(docSnapshot.data()!);
        debugPrint("user: $_user");
      } else {
        debugPrint('User data not found in Firestore');
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}

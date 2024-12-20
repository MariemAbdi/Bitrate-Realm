import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/firebase_storage_services.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  StreamSubscription<DocumentSnapshot>? _userSubscription;

  /// Listen to Firestore changes in real-time
  void listenToUserChanges(String userId) {
    _isLoading = true;
    notifyListeners();  // Notify listeners that loading has started

    // Cancel any existing subscription to avoid multiple listeners
    _userSubscription?.cancel();

    // Set up a real-time listener to the user's document
    _userSubscription = _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .listen(
          (docSnapshot) {
        if (docSnapshot.exists) {
          _user = UserModel.fromJson(docSnapshot.data()!);
          _isLoading = false;  // Data is fetched, no longer loading
        } else {
          _user = null;  // In case user data does not exist
          _isLoading = false;  // Not loading anymore
        }

        // Notify listeners after state update
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();  // Update UI after the current build cycle
        });
      },
      onError: (error) {
        debugPrint('Error listening to user data: $error');
        _isLoading = false;  // Stop loading on error
        _user = null;  // Ensure no user data on error
        // Notify listeners after state update
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();  // Update UI after the current build cycle
        });
      },
    );
  }

  /// Update the user's profile image in Firestore and Firebase Storage
  Future<void> updateProfileImage(Uint8List pickedImage, String userId) async {
    try {
      // Upload the image to Firebase Storage
      String? photoURL = await FirebaseStorageServices().uploadFile(
        "profile pictures",
        pickedImage,
        userId,
      );

      // Update Firestore with the new image URL
      if(photoURL!=null){
        await _firestore.collection("users").doc(userId).update({
          "pictureURL": photoURL,
        });
      }

      // Since Firestore already reflects the updated data, there's no need for an additional fetch.
      notifyListeners();  // Ensure the UI is updated
    } catch (error) {
      throw Exception("Error updating profile image: $error");
    }
  }

  /// Remove the user's profile image from Firestore and Firebase Storage
  Future<void> removeProfileImage(String userId) async {
    try {
      // Remove the image from Firebase Storage
      FirebaseStorageServices().deleteFile("profile pictures", userId);

      // Update Firestore to remove the image URL
      await _firestore.collection("users").doc(userId).update({
        "pictureURL": FieldValue.delete(),
      });

      // Firestore is updated, so notify listeners to reflect changes in the UI
      notifyListeners();
    } catch (error) {
      throw Exception("Error removing profile image: $error");
    }
  }

  /// Clear user data and stop listening
  void clearUser() {
    _userSubscription?.cancel();
    _user = null;
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
  }
}
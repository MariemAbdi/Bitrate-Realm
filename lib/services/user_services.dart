import 'package:bitrate_realm/config/utils.dart';
import 'package:bitrate_realm/translations/locale_keys.g.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/user.dart';
import 'firebase_auth_services.dart';
class UserServices{
  final CollectionReference<Map<String, dynamic>> _firestoreCollection = FirebaseFirestore.instance.collection('users');

  Future<void> createUser(UserModel user) async {
    final docSnapshot = await _firestoreCollection.doc(user.email).get();

    //IF USER DOESN'T EXIST THEN WE ADD THEM TO THE FIRESTORE
    if(!docSnapshot.exists) {
      await _firestoreCollection.doc(user.email).set(user.toJson());
    }

  }

  Future<void> updateUser(UserModel user) async {
    try{
      await _firestoreCollection.doc(user.email).update(user.toJson());
    }catch(error){
      debugPrint(error.toString());
    }
  }

  Future<UserModel?> getUserData(String userId) async {
    try {
      // Fetch the user's document from the 'users' collection
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      // Check if the document exists
      if (docSnapshot.exists) {
        // Parse the document data into a UserModel
        return UserModel.fromJson(docSnapshot.data()!);
      } else {
        // Return null if the user document doesn't exist
        return null;
      }
    } catch (e) {
      // Handle any errors
      debugPrint("Error fetching user data: $e");
      return null;
    }
  }

  Future<List<UserModel>> getUsersList() async {
    try {
      // Fetch all users excluding the current user
      QuerySnapshot snapshot = await _firestoreCollection
          .where('email', isNotEqualTo: FirebaseAuthServices().user!.email!) // Exclude current user
          .get(); // Using get() instead of snapshots()

      // Convert Firestore docs to UserModel
      List<UserModel> users = snapshot.docs.map((doc) {
        // Safely cast the document data to Map<String, dynamic>
        var data = doc.data() as Map<String, dynamic>;
        return UserModel.fromJson(data); // Use the data to create the UserModel
      })
          .toList();

      // Sort users by username alphabetically
      users.sort((a, b) => a.username.compareTo(b.username));

      return users;
    } catch (error) {
      debugPrint(error.toString());
      return [];
    }
  }

  Stream<List<UserModel>> getAllUsers(String currentUserId) {
    try{
      return _firestoreCollection
          .where('email', isNotEqualTo: currentUserId)  // Exclude current user
          .snapshots()
          .map((snapshot) {
        // Convert Firestore docs to UserModel
        List<UserModel> users = snapshot.docs
            .map((doc) => UserModel.fromJson(doc.data()))
            .toList();

        // Sort users in memory: prioritize isLive, then by username
        users.sort((a, b) {
          // First, compare by isLive (true first)
          int isLiveComparison = (b.isLive ? 1 : 0) - (a.isLive ? 1 : 0);  // b isLive first
          if (isLiveComparison != 0) return isLiveComparison;

          // If isLive is the same, compare by username
          return a.username.compareTo(b.username);  // Alphabetically by username
        });

        return users;
      });
    }catch(error){
      debugPrint(error.toString());
      return const Stream.empty();
    }
  }

  Future<int> getFollowersCount({required String userId, bool getFollowers = true}) async {
    final docSnapshot = await _firestoreCollection.doc(userId).get();

    if (docSnapshot.exists) {
      final user = UserModel.fromJson(docSnapshot.data()!);
      return getFollowers ? user.followers.length : user.following.length;
    } else {
      return 0;
    }
  }
  Future<List<String>> getFollowersList(String userId, bool getFollowers) async {
    final docSnapshot = await _firestoreCollection.doc(userId).get();

    if (docSnapshot.exists) {
      final user = UserModel.fromJson(docSnapshot.data()!);
      return getFollowers ? user.followers : user.following;
    } else {
      throw Exception("User not found");
    }
  }

  Future<List<UserModel>> getFollowersDetails({required String userId, bool getFollowers = true}) async {
    // Get the list of follower IDs
    List<String> followerIds = await getFollowersList(userId, getFollowers);

    // Fetch user details for each follower
    final followers = await Future.wait(followerIds.map((id) async {
      final docSnapshot = await _firestoreCollection.doc(id).get();

      if (docSnapshot.exists) {
        return UserModel.fromJson(docSnapshot.data()!);
      } else {
        return null; // Handle case where user might not exist
      }
    }).toList());

    // Filter out null values (in case some followers don't exist anymore)
    List<UserModel> validFollowers = followers.whereType<UserModel>().toList();

    // Fetch the current user's email from FirebaseAuth
    String currentUserEmail = FirebaseAuthServices().user!.email!;

    // Create a dummy UserModel for the current user if not found in the list
    UserModel currentUser = validFollowers.firstWhere(
            (user) => user.email == currentUserEmail,
        orElse: () => UserModel(email: "", username: "") // Fallback user model
    );

    // Sort the remaining followers based on their username
    validFollowers.sort((a, b) => a.username.compareTo(b.username));

    // If currentUser is found (not the default one), add them to the top of the list
    if (currentUser.email != "") {
      // Remove current user from the list if found
      validFollowers.removeWhere((user) => user.email == currentUserEmail);
      // Add current user to the top of the list
      validFollowers.insert(0, currentUser);
    }

    return validFollowers;
  }

  Future<void> followUnfollow(String firstUserId, String secondUserId, String secondUserName) async {
    try {
      showLoadingPopUp();

      // Determine follow/unfollow action for the following list
      bool isFollowing = await followSomeone(firstUserId, secondUserId, "following");

      // Update the followers list of the second user
      await followSomeone(secondUserId, firstUserId, "followers");

      Get.back();

      // Show appropriate toast message
      showToast(
          toastType: ToastType.info,
          message: isFollowing
              ? "You started following $secondUserName"
              : "You unfollowed $secondUserName"
      );

    } catch (e) {
      Get.back();
      showToast(toastType: ToastType.error, message: LocaleKeys.somethingWentWrong);
    }
  }

  Future<bool> followSomeone(String firstUserId, String secondUserId, String array) async {
    try {
      // Reference to the document of the first user
      DocumentReference userDoc = _firestoreCollection.doc(firstUserId);

      // Use Firestore transactions to ensure atomicity
      return await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(userDoc);

        if (!snapshot.exists) {
          throw Exception("User document does not exist");
        }

        // Get the current list (either 'following' or 'followers') or initialize an empty list
        List<String> currentList = List<String>.from(snapshot[array] ?? []);

        if (currentList.contains(secondUserId)) {
          // If the second user is already in the list, remove them (unfollow)
          currentList.remove(secondUserId);
          transaction.update(userDoc, {array: currentList});
          return false; // Return false for unfollow
        } else {
          // Otherwise, add the second user to the list (follow)
          currentList.add(secondUserId);
          transaction.update(userDoc, {array: currentList});
          return true; // Return true for follow
        }
      });
    } catch (error) {
      debugPrint(error.toString());
      return false; // Default to unfollow in case of error
    }
  }

}



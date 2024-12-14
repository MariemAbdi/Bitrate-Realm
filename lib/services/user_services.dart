import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';
class UserServices{
  final CollectionReference<Map<String, dynamic>> _firestoreCollection = FirebaseFirestore.instance.collection('users');

//ADD USER TO FIRESTORE
  Future<void> createUser(UserModel user) async {
    final docSnapshot = await _firestoreCollection.doc(user.email).get();

    //IF USER DOESN'T EXIST THEN WE ADD THEM TO THE FIRESTORE
    if(!docSnapshot.exists) {
      await _firestoreCollection.doc(user.email).set(user.toJson());
    }

  }

//GET THE LIST OF ALL THE USERS
  Stream<List<UserModel>> getAllUsers()=>
      _firestoreCollection.orderBy('nickname').snapshots().map((snapshot)
      => snapshot.docs.map((doc)
      => UserModel.fromJson(doc.data())).toList());
}
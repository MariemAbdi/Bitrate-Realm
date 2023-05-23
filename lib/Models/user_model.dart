import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  late String email; // THE ID
  late String nickname;
  late String bio;
  late List<String> followers;
  late List<String> following;

  User({required this.email, required this.nickname, this.bio="Hello World!", this.followers= const[], this.following= const[]});

  Map<String,dynamic> toJson()=>{
    'email': email,
    'nickname': nickname,
    'bio': bio,
    'followers': followers,
    'following': following,
  };

  static User fromJson(Map<String,dynamic> json){
    return User(
      email: json['email'],
      nickname: json['nickname'],
      bio: json['bio'],
      followers: json['followers'].cast<String>(),
      following: json['following'].cast<String>(),
      );}

}

Future<void> createUser(User user) async {
  //REFERENCE TO A DOCUMENT
  final docUser= FirebaseFirestore.instance.collection('users').doc(user.email);
  //GET USER
  final docSnapshot = await docUser.get();

  //IF IT DOESN'T EXIST THEN WE ADD IT TO THE FIRESTORE
  if(!docSnapshot.exists) {
    //CREATE DOCUMENT AND WRITE DATA TO FIREBASE
    await docUser.set(user.toJson());
  }

}

//GET A LIST OF ALL THE DOCUMENTS IN THE COLLECTION
Stream<List<User>> getAllUsers()=>
    FirebaseFirestore.instance.collection('users').orderBy('nickname').snapshots().map((snapshot) => snapshot.docs.map((doc) =>
        User.fromJson(doc.data())).toList());


Future<void> deleteUser(String id)async{
  //DELETE USER
  FirebaseFirestore.instance.collection('users').doc(id);
}

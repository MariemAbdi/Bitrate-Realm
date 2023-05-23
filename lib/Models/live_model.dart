import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:livestream/Resources/utils.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../Resources/firebase_auth_methods.dart';
import '../Resources/firebase_storage_services.dart';
import '../Screens/Going Live/broadcast_screen.dart';
import '../Services/Themes/my_themes.dart';

class LiveStream{
  late String id;
  late String title;
  late String description;
  late String user;
  late int views;
  late DateTime date;
  late String channelId;
  late String language;
  late List<String> tags;
  late int duration;
  late String thumbnail;
  late String videoUrl;
  late List<String> likes;
  late String category;

  LiveStream({this.id="", required this.title, required this.description, required this.language, required this.tags, this.user="", this.views=0, DateTime? date ,
    this.channelId='', this.duration=0, this.thumbnail="", this.videoUrl='', this.likes=const[], required this.category}): date = date ?? DateTime.now();

  Map<String,dynamic> toJson()=>{
    'id': id,
    'title': title,
    'description': description,
    'user': user,
    'language': language,
    'tags' : tags,
    'views': views,
    'date': date,
    'channelId': channelId,
    'duration': duration,
    'thumbnail': thumbnail,
    'videoUrl': videoUrl,
    'likes': likes,
    'category':category
  };

  static LiveStream fromJson(Map<String,dynamic> json){
    return LiveStream(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        user: json['user'],
        language: json['language'],
        tags: json['tags'].cast<String>(),
        views: json['views'],
        date: json['date'].toDate(),
        channelId: json['channelId'],
        duration: json['duration'],
        thumbnail: json['thumbnail'],
        videoUrl: json['videoUrl'],
        likes: json['likes'].cast<String>(),
        category: json['category'],

    );
  }

  factory LiveStream.fromMap(Map<String, dynamic> map) {
    return LiveStream(
      id: map['id'],
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      user: map['user'] ?? '',
      language: map['language'] ?? '',
      tags: map['tags']?.cast<String>() ?? [],
      views: map['views']?.toInt() ?? 0,
      date: map['date']?.toDate() ?? DateTime.now(),
      channelId: map['channelId'] ?? '',
      duration: map['duration']?.toInt() ?? 0,
      thumbnail: map['thumbnail'] ?? '',
      videoUrl: map['videoUrl'] ?? '',
      likes: map['likes']?.cast<String>() ?? [],
      category: map['category'],
    );
  }
}

final _firestore= FirebaseFirestore.instance;
Storage storage = Storage();

startLiveStream(BuildContext context, String title, String description, String language, List<String> tags, String category, Uint8List? image) async{

  final user = context.read<FirebaseAuthMethods>().user;
  String channelId= '';
  LiveStream live;
  try{
    if(!((await _firestore.collection('live_streams').doc(user.uid).get()).exists)){
      // //SHOW LOADING CIRCLE
      // showDialog(context: context, builder: (context){
      //   return const Center(child: CircularProgressIndicator(color: MyThemes.darkBlue,),);
      // });
      //UPLOAD THUMBNAIL PHOTO TO FIREBASE STORAGE
      //GENERATE RANDOM ID THEN SAVE THE THUMBNAIL IMAGE
      //String thumbnailId = const Uuid().v4();
      storage.uploadFile("live thumbnail", image! , user.uid);

      //CHANNEL ID CREATION
      channelId= user.uid;
      //CREATE LIVESTREAM INSTANCE AND UPLOAD IT TO THE FIRESTORE
      live = LiveStream(title: title, description: description, language: language, tags: tags, user: user.email!, views: 0, date: DateTime.now(), channelId: channelId, duration: 0, thumbnail: channelId, videoUrl: "", category: category);
      _firestore.collection('live_streams').doc(user.uid).set(live.toJson());

      //Navigator.pop(context);

      if (channelId.isNotEmpty) {
        //GO TO THE BROADCASTING SCREEN IF THERE IS NO PROBLEM
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BroadcastScreen(
                isBroadcaster: true,
                channelId: channelId,
                liveStream: live)));
      }
    }else{
      mySnackBar(context, "Two LiveStreams Cannot Start At Once!", Colors.red);
    }
  }on FirebaseException catch(e){
    mySnackBar(context, e.message!, Colors.red);
  }
}

uploadVideo(BuildContext context, String title, String description, String language, List<String> tags, String category, Uint8List? image, Uint8List? video) async{

  final user = context.read<FirebaseAuthMethods>().user;
  LiveStream live;
  try{
    //SHOW LOADING CIRCLE
    showDialog(context: context, builder: (context){
      return const Center(child: CircularProgressIndicator(color: MyThemes.darkBlue,),);
    });//UPLOAD THUMBNAIL PHOTO TO FIREBASE STORAGE
    //GENERATE RANDOM ID THEN SAVE THE VIDEO FILE
    String customId = const Uuid().v4();
    storage.uploadFile("videos", video! , "$customId.mp4").whenComplete(() async {
      storage.uploadFile("video thumbnail", image! , customId);//DOWNLOAD THUMBNAIL

      //REFERENCE TO A DOCUMENT
      final docUser= _firestore.collection('videos').doc(customId);
      //GET VIDEO
      final docSnapshot = await docUser.get();

      //CREATE LIVESTREAM INSTANCE AND UPLOAD IT TO THE FIRESTORE
          live = LiveStream(id: customId,title: title, description: description, language: language, tags: tags, user: user.email!, views: 0, date: DateTime.now(), channelId: "", duration: 0, thumbnail: customId, videoUrl: customId, category: category);

          //IF IT DOESN'T EXIST THEN WE ADD IT TO THE FIRESTORE
          if(!docSnapshot.exists) {
            //CREATE DOCUMENT AND WRITE DATA TO FIREBASE
            await docUser.set(live.toJson());
          }

          //_firestore.collection('videos').doc(user.uid).set(live.toJson());
          mySnackBar(context, "Video Uploaded Successfully!", Colors.green);
          Navigator.pop(context);
        });//DOWNLOAD VIDEO

  }on FirebaseException catch(e){
    mySnackBar(context, e.message!, Colors.red);
  }
}

Future<void> endLiveStream(String channelId) async{
  try{
    //IF WE DELETE A COLLECTION ITS SUB-COLLECTION WILL REMAIN
    //SO WE NEED TO DELETE THE SUB-COLLECTION FIRST THEN THE PARENT COLLECTION
    QuerySnapshot snapshot = await _firestore.collection("live_streams").doc(channelId).collection("comments").get();
    for(int i=0; i< snapshot.docs.length; i++){
      await _firestore.collection("live_streams").doc(channelId).collection("comments").doc(((snapshot.docs[i].data()! as dynamic)['commentId'])).delete();
    }
    //DELETE THE WHOLE THING
    await _firestore.collection("live_streams").doc(channelId).delete();

    //DELETE IMAGE FROM FIRESTORE
    storage.deleteFile("live thumbnail", channelId);
    
  }catch(e){
    debugPrint(e.toString());
  }
}

Future<void> updateViewCount(String channelId, bool isIncreased) async{
  try{
    //IF THE USER IS LEAVING isIncreased WILL HAVE THE VALUE OF FALSE
    //WHEN THE USER STARTS WATCHING A LIVE STREAM THEN IT'S TRUE
    await _firestore.collection('live_streams').doc(channelId).update({
      'views': FieldValue.increment(isIncreased? 1: -1)
    });
  }catch(e){
    debugPrint(e.toString());
  }
}

Future<void> addComment(String collectionId, String docId, String message,String nickname, String id, BuildContext context) async{
  final user = context.read<FirebaseAuthMethods>().user;

  try{
    String commentId =  const Uuid().v4(); //GENERATE A UNIQUE ID

    //ADD A COMMENT TO THE COLLECTION
    await _firestore.collection(collectionId).doc(docId).collection('comments').doc(commentId).set(
        {
          'nickname': nickname,
          'message': message,
          'uid': user.uid,
          'createdAt': DateTime.now(),
          'commentId': commentId,
        });
  }on FirebaseException catch(e){
    mySnackBar(context, e.message!, Colors.red);
  }
}

//GET A LIST OF ALL THE VIDEOS
Stream<List<LiveStream>> getAllVideos(String field,bool descending)=>
    FirebaseFirestore.instance.collection('videos').orderBy(field, descending: descending).snapshots().map((snapshot) => snapshot.docs.map((doc) =>
        LiveStream.fromJson(doc.data())).toList());

//GET A LIST OF ALL THE VIDEOS
Stream<List<LiveStream>> getVideosPerCategory(String category)=>
    FirebaseFirestore.instance.collection('videos').where('category', isEqualTo: category).orderBy("date", descending: true).snapshots().map((snapshot) => snapshot.docs.map((doc) =>
        LiveStream.fromJson(doc.data())).toList());


//GET A LIST OF ALL THE LIVE STREAMS
Stream<List<LiveStream>> getCurrentLives()=>
    FirebaseFirestore.instance.collection('live_streams').orderBy('date').snapshots().map((snapshot) => snapshot.docs.map((doc) =>
        LiveStream.fromJson(doc.data())).toList());


//GET A LIST OF ALL THE VIDEOS OF A CERTAIN USER
Stream<List<LiveStream>> getMyVideos(String id)=>
    FirebaseFirestore.instance.collection('videos').where("user", isEqualTo: id).snapshots().map((snapshot) => snapshot.docs.map((doc) =>
        LiveStream.fromJson(doc.data())).toList());

//GET A LIST OF ALL THE LIKED VIDEOS OF A CERTAIN USER
Stream<List<LiveStream>> getMyFavouriteVideos(String id)=>
    FirebaseFirestore.instance.collection('videos').where("likes", arrayContains: id).snapshots().map((snapshot) => snapshot.docs.map((doc) =>
        LiveStream.fromJson(doc.data())).toList());

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'firebase_storage_services.dart';
import '../config/utils.dart';
import '../models/live_stream.dart';
import '../screens/Going Live/broadcast_screen.dart';

class LiveStreamServices{
  final CollectionReference<Map<String, dynamic>> _liveStreamsCollection= FirebaseFirestore.instance.collection('live_streams');
  final CollectionReference<Map<String, dynamic>> _videosCollection= FirebaseFirestore.instance.collection('videos');
  FirebaseStorageServices firebaseStorage = FirebaseStorageServices();

  startLiveStream(LiveStream liveStream) async{
    String channelId= liveStream.user;
    try{
      //SHOW LOADING ANIMATION
      showLoadingPopUp();

      if(!((await _liveStreamsCollection.doc(channelId).get()).exists)){
        //UPLOAD THUMBNAIL PHOTO TO FIREBASE STORAGE
        String? photoLink = await firebaseStorage.uploadFile("live thumbnail", liveStream.thumbnail , channelId);

        //CREATE LIVESTREAM INSTANCE AND UPLOAD IT TO THE FIRESTORE
        if(photoLink!=null){
          _liveStreamsCollection.doc(channelId).set(liveStream.copyWith(thumbnailLink: photoLink).toJson());
        }

        if (channelId.isNotEmpty) {
          //GO TO THE BROADCASTING SCREEN IF THERE IS NO PROBLEM
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => BroadcastScreen(
          //         isBroadcaster: true,
          //         channelId: channelId,
          //         liveStream: live)));
        }
      }else{
        Get.back();//HIDE LOADING ANIMATION
        showToast(toastType: ToastType.error, message: "You Can't Start Two LiveStreams At Once!");
      }
    }catch(e){
      Get.back();//HIDE LOADING ANIMATION
      showToast(toastType: ToastType.error, message: e.toString());
    }
  }

  uploadVideo(LiveStream liveStream) async{
    String? videoLink, thumbnailLink;
    try{
      //SHOW LOADING CIRCLE
      showLoadingPopUp();
      
      //GENERATE RANDOM ID TO UPLOAD THE VIDEO & ITS THUMBNAIL
      String userFilesUUID = const Uuid().v4();

      //UPLOAD VIDEO TO FIREBASE STORAGE
      videoLink = await firebaseStorage.uploadFile("videos", liveStream.video , "$userFilesUUID.mp4");
      
      if(videoLink != null){
        thumbnailLink = await firebaseStorage.uploadFile("video thumbnail", liveStream.thumbnail , userFilesUUID);
        if(thumbnailLink != null){
          //GET VIDEO
          DocumentSnapshot<Map<String, dynamic>> docSnapshot = await _videosCollection.doc(userFilesUUID).get();
          //IF IT DOESN'T EXIST THEN WE ADD IT TO THE FIRESTORE
          if(!docSnapshot.exists) {
            liveStream.copyWith(id: userFilesUUID, thumbnailLink: thumbnailLink, videoLink: videoLink);
            await _videosCollection.doc(userFilesUUID).set(liveStream.toJson());
            Get.back();//HIDE LOADING ANIMATION
            showToast(toastType: ToastType.success, message: "Video Uploaded Successfully!");
          }
        }
      }

    }catch(e){
      showToast(toastType: ToastType.error, message: e.toString());
    }
  }

  Future<void> endLiveStream(String channelId) async{
    try{
      //IF WE DELETE A COLLECTION ITS SUB-COLLECTION WILL REMAIN
      //SO WE NEED TO DELETE THE SUB-COLLECTION FIRST THEN THE PARENT COLLECTION
      QuerySnapshot snapshot = await _liveStreamsCollection.doc(channelId).collection("comments").get();
      for(int i=0; i< snapshot.docs.length; i++){
        await _liveStreamsCollection.doc(channelId).collection("comments").doc(((snapshot.docs[i].data()! as dynamic)['commentId'])).delete();
      }
      //DELETE THE WHOLE THING
      await _liveStreamsCollection.doc(channelId).delete();

      //DELETE IMAGE FROM FIRESTORE
      firebaseStorage.deleteFile("live thumbnail", channelId);

    }catch(e){
      debugPrint(e.toString());
      mySnackBar(e.toString(), Colors.redAccent);
    }
  }

  Future<void> updateViewCount(String channelId, bool isIncreased) async{
    try{
      //IF THE USER IS LEAVING isIncreased WILL HAVE THE VALUE OF FALSE
      //WHEN THE USER STARTS WATCHING A LIVE STREAM THEN IT'S TRUE
      await _liveStreamsCollection.doc(channelId).update({
        'views': FieldValue.increment(isIncreased? 1 : -1)
      });
    }catch(e){
      debugPrint(e.toString());
    }
  }

  Future<void> addComment(String collectionId, String docId, String message,String nickname, String id, BuildContext context) async{
    // final user = context.read<FirebaseAuthMethods>().user;
    //
    // try{
    //   String commentId =  const Uuid().v4(); //GENERATE A UNIQUE ID
    //
    //   //ADD A COMMENT TO THE COLLECTION
    //   await _firestore.collection(collectionId).doc(docId).collection('comments').doc(commentId).set(
    //       {
    //         'nickname': nickname,
    //         'message': message,
    //         'uid': user.uid,
    //         'createdAt': DateTime.now(),
    //         'commentId': commentId,
    //       });
    // }on FirebaseException catch(e){
    //   mySnackBar(context, e.message!, Colors.red);
    // }
  }

//GET A LIST OF ALL THE VIDEOS
  Stream<List<LiveStream>> getAllVideos(String field, bool descending)=>
      _videosCollection.orderBy(field, descending: descending).snapshots().map((snapshot)
      => snapshot.docs.map((doc)
      => LiveStream.fromJson(doc.data())).toList());

//GET A LIST OF ALL THE VIDEOS (PER CATEGORY)
  Stream<List<LiveStream>> getVideosPerCategory(String category)=>
      _videosCollection.where('category', isEqualTo: category).orderBy("date", descending: true).snapshots().map((snapshot)
      => snapshot.docs.map((doc)
      => LiveStream.fromJson(doc.data())).toList());

//GET A LIST OF ALL THE LIVE STREAMS
  Stream<List<LiveStream>> getCurrentLives()=>
      _liveStreamsCollection.orderBy('date').snapshots().map((snapshot)
      => snapshot.docs.map((doc)
      => LiveStream.fromJson(doc.data())).toList());

//GET A LIST OF ALL THE VIDEOS OF A CERTAIN USER
  Stream<List<LiveStream>> getMyVideos(String userId)=>
      _videosCollection.where("user", isEqualTo: userId).snapshots().map((snapshot)
      => snapshot.docs.map((doc)
      => LiveStream.fromJson(doc.data())).toList());

//GET A LIST OF ALL THE LIKED VIDEOS OF A CERTAIN USER
  Stream<List<LiveStream>> getMyFavouriteVideos(String userId)=>
      _videosCollection.where("likes", arrayContains: userId).snapshots().map((snapshot)
      => snapshot.docs.map((doc)
      => LiveStream.fromJson(doc.data())).toList());

}
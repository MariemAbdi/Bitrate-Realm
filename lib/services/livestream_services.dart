import 'package:bitrate_realm/config/routing.dart';
import 'package:bitrate_realm/services/user_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:uuid/uuid.dart';

import '../models/user.dart';
import '../translations/locale_keys.g.dart';
import 'firebase_storage_services.dart';
import '../config/utils.dart';
import '../models/live_stream.dart';

class LiveStreamServices{
  final CollectionReference<Map<String, dynamic>> _liveStreamsCollection = FirebaseFirestore.instance.collection('live streams');
  FirebaseStorageServices firebaseStorage = FirebaseStorageServices();

  Stream<List<LiveStream>> getAllLives(String currentUserEmail, String categoryId, {int? limit}) {
    Query liveStreamsQuery = _liveStreamsCollection;

    // Add category filter only if categoryId is not empty or null
    if (categoryId != "null" && categoryId.isNotEmpty) {
      liveStreamsQuery = liveStreamsQuery.where("category", isEqualTo: categoryId);
    }

    // Apply ordering for isLive and date
    liveStreamsQuery = liveStreamsQuery
        .orderBy('isLive', descending: true)
        .orderBy('date', descending: true);

    // Apply limit if provided
    if (limit != null) {
      liveStreamsQuery = liveStreamsQuery.limit(limit);
    }

    // Convert Firestore snapshots to LiveStream list
    return liveStreamsQuery.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => LiveStream.fromJson(doc.data() as Map<String, dynamic>))
        .where((liveStream) => liveStream.streamer != currentUserEmail) // Exclude the current user
        .toList());
  }


  Stream<List<LiveStream>> getUserLives(String currentUserEmail, String categoryId) {
    Query myLivesQuery = _liveStreamsCollection;

    // Filter by current user's email
    myLivesQuery = myLivesQuery.where("streamer", isEqualTo: currentUserEmail);

    // Add category filter only if categoryId is not empty or null
    if (categoryId != "null" && categoryId.isNotEmpty) {
      myLivesQuery = myLivesQuery.where("category", isEqualTo: categoryId);
    }

    // Apply ordering for isLive and date
    myLivesQuery = myLivesQuery
        .orderBy('isLive', descending: true)
        .orderBy('date', descending: true);

    // Convert Firestore snapshots to LiveStream list
    return myLivesQuery.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => LiveStream.fromJson(doc.data() as Map<String, dynamic>))
        .toList());
  }

  Future<int> getUserLivesCount(String currentUserEmail) async {
    try {
      // Create a query to filter by the current user's email
      Query myLivesQuery = _liveStreamsCollection.where("streamer", isEqualTo: currentUserEmail);

      // Get the query snapshot
      QuerySnapshot snapshot = await myLivesQuery.get();

      // Return the count of documents
      return snapshot.size;
    } catch (e) {
      debugPrint('Error fetching lives count: $e');
      return 0; // Return 0 in case of an error
    }
  }


  startLiveStream(LiveStream liveStream) async{
    String channelId = const Uuid().v4();
    try{
      //SHOW LOADING ANIMATION
      showLoadingPopUp();

      UserModel? user = await UserServices().getUserData(liveStream.streamer!);

      if (user == null) return;

      // Check if the user is already live
      if (user.isLive) {
        Get.back(); // Hide loading animation
        showToast(toastType: ToastType.error, message: "You Can't Start Two LiveStreams At Once!");
        return;
      }

      //SET USER TO BE LIVE
      await UserServices().updateUser(user.copyWith(isLive: true));

      // Upload thumbnail photo to Firebase Storage
      String? photoLink = await firebaseStorage.uploadFile("live thumbnail", liveStream.thumbnail, channelId);

      // Proceed only if the photo upload succeeds
      if (photoLink == null) return;

      LiveStream uploadedLive = liveStream.copyWith(
        thumbnailLink: photoLink,
        channelId: channelId,
        isLive: true,
      );

      // Upload the live stream instance to Firestore
      await _liveStreamsCollection.doc(channelId).set(uploadedLive.toJson());

      // Go to broadcasting screen
      broadcastNavigation(true, uploadedLive);

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
          //DocumentSnapshot<Map<String, dynamic>> docSnapshot = await _videosCollection.doc(userFilesUUID).get();
          //IF IT DOESN'T EXIST THEN WE ADD IT TO THE FIRESTORE
          // if(!docSnapshot.exists) {
          //   liveStream.copyWith(id: userFilesUUID, thumbnailLink: thumbnailLink, videoLink: videoLink);
          //  // await _videosCollection.doc(userFilesUUID).set(liveStream.toJson());
          //   Get.back();//HIDE LOADING ANIMATION
          //   showToast(toastType: ToastType.success, message: "Video Uploaded Successfully!");
          // }
        }
      }

    }catch(e){
      showToast(toastType: ToastType.error, message: e.toString());
    }
  }

  Future<void> endLiveStream(String channelId, UserModel user) async{
    try{
      //SET LIVE TO NOT BE LIVE
      await _liveStreamsCollection.doc(channelId).update({
        "isLive": false
      });

      //SET USER TO NOT BE LIVE
      await UserServices().updateUser(user.copyWith(isLive: false));
    }catch(e){
      debugPrint(e.toString());
      showToast(toastType: ToastType.error, message: LocaleKeys.somethingWentWrong.tr());
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
//   Stream<List<LiveStream>> getAllVideos(String field, bool descending)=>
//       _videosCollection.orderBy(field, descending: descending).snapshots().map((snapshot)
//       => snapshot.docs.map((doc)
//       => LiveStream.fromJson(doc.data())).toList());

//GET A LIST OF ALL THE VIDEOS (PER CATEGORY)
//   Stream<List<LiveStream>> getVideosPerCategory(String category)=>
//       _videosCollection.where('category', isEqualTo: category).orderBy("date", descending: true).snapshots().map((snapshot)
//       => snapshot.docs.map((doc)
//       => LiveStream.fromJson(doc.data())).toList());

//GET A LIST OF ALL THE VIDEOS OF A CERTAIN USER
//   Stream<List<LiveStream>> getMyVideos(String userId)=>
//       _videosCollection.where("user", isEqualTo: userId).snapshots().map((snapshot)
//       => snapshot.docs.map((doc)
//       => LiveStream.fromJson(doc.data())).toList());

//GET A LIST OF ALL THE LIKED VIDEOS OF A CERTAIN USER
//   Stream<List<LiveStream>> getMyFavouriteVideos(String userId)=>
//       _videosCollection.where("likes", arrayContains: userId).snapshots().map((snapshot)
//       => snapshot.docs.map((doc)
//       => LiveStream.fromJson(doc.data())).toList());

}
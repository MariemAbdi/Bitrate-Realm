import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bitrate_realm/models/live_stream.dart';

import '../services/firebase_storage_services.dart';
import '../config/utils.dart';
import '../screens/Going Live/video_player.dart';
import '../config/app_style.dart';

class VideoWidget extends StatefulWidget {
  final LiveStream video;
  const VideoWidget({Key? key, required this.video}) : super(key: key);

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  FirebaseStorageServices storage = FirebaseStorageServices();
  String nickname="";

  //GETTING TEH VIDEO THUMBNAIL IMAGE
  Widget thumbnail(String fileName){
    return FutureBuilder(
      future: storage.downloadURL("video thumbnail", fileName),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
          return Stack(
            children: [

              Ink.image(image: NetworkImage(snapshot.data!), height: 150, fit: BoxFit.cover,),

              Positioned(
                  top: 5,
                  left: 10,
                  child: Text(widget.video.language, style: GoogleFonts.ptSans(textStyle: const TextStyle(fontWeight: FontWeight.w600)))),

              Positioned(
                  bottom: 3,
                  right: 3,
                  child: Text(formatDuration(widget.video.duration), style: GoogleFonts.ptSans(textStyle: const TextStyle(fontWeight: FontWeight.w600)))),
            ],
          );
        }

        return const Center(child: CircularProgressIndicator(color: MyThemes.primaryLight,),);
      },
    );
  }

  //GETTING THE USER'S PROFILE PICTURE
  Widget profilePicture(){
    return FutureBuilder(
      future: storage.downloadURL("profile pictures", widget.video.user),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if(snapshot.hasData){
          return Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  color: MyThemes.primaryLight,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(snapshot.data!),
                  )));

        }

        return const Center(child: CircularProgressIndicator(color: MyThemes.primaryLight,),);
      },
    );
  }

  getUser(){
    FirebaseFirestore.instance.collection("users").doc(widget.video.user).get().then((DocumentSnapshot documentSnapshot){
      setState(() {
        nickname=documentSnapshot["nickname"];
      });
    });
    return nickname;
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(video: widget.video)
        ));
      },
      child: Card(
        elevation: 4,
        clipBehavior: Clip.antiAlias, //for smoother looks
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [

            thumbnail(widget.video.thumbnailLink),

            Padding(
              padding: const EdgeInsets.only(top: 5, right: 15, left: 15, bottom: 5),
              child: Column(
                children: [


                  Align(
                      alignment: Alignment.topRight,
                      child: Text(DateFormat('dd/MM/yyyy').format(widget.video.creationDate), style: GoogleFonts.ptSans(textStyle: const TextStyle(fontSize: 11, color: Colors.grey)))),

                  Row(
                    children: [
                      profilePicture(),
                      const SizedBox(width: 10,),
                      Text(nickname, style: GoogleFonts.ptSans(textStyle: const TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis, fontSize: 16)))
                    ],),

                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(widget.video.title, style: GoogleFonts.ptSans(textStyle: const TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis, fontSize: 14)))),


                  widget.video.tags.isNotEmpty?
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(tagsList(widget.video.tags), style: GoogleFonts.ptSans(textStyle: const TextStyle(fontSize: 12))))
                      :Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:bitrate_realm/Widgets/chat_livestream.dart';
import 'package:video_player/video_player.dart';

import '../../models/live_stream.dart';
import '../../services/firebase_auth_services.dart';

class VideoPlayerScreen extends StatefulWidget {
  final LiveStream video;
  const VideoPlayerScreen({Key? key, required this.video}) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController= VideoPlayerController.asset("assets/azertyuiop123.mp4");
  late ChewieController _chewieController= ChewieController(videoPlayerController: _videoPlayerController);

  late String videoURL="";
  late int likesCount=0;
  late bool isAlreadyLiked=false;

  void fetchData() async{
    //final user = Provider.of<AuthProvider>(context).user;
    final user = FirebaseAuthServices().user!;

    FirebaseFirestore.instance.collection("videos").doc(widget.video.id).get().then((DocumentSnapshot documentSnapshot) {
      setState(() {
        likesCount = documentSnapshot["likes"].length;
        isAlreadyLiked = documentSnapshot["likes"].contains(user.email);
      });
    }
    );
  }

  incrementView()async{
    await FirebaseFirestore.instance.collection('videos').doc(widget.video.id).update({
      'views': FieldValue.increment(1)
    });
  }

  @override
  void initState() {
    super.initState();

    fetchData();

    incrementView();
    getVideo().then((value) {
      _videoPlayerController = VideoPlayerController.network(videoURL);

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: 16/9,
        autoPlay: true,
        looping: true,
        zoomAndPan: true,
        allowedScreenSleep: false,
      );
    });

  }

  Future<void> getVideo() async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    Reference videoRef = storage.ref().child('videos/${widget.video.videoLink}.mp4');

    String downloadURL = await videoRef.getDownloadURL();

    setState(() {
      videoURL=downloadURL;
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final user = context.read<FirebaseAuthServices>().user;
    final user = FirebaseAuthServices().user!;

    return Scaffold(
      //appBar: MyAppBar(implyLeading:true, title: widget.video.title, action: Container(),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16/9,
              child: Chewie(controller: _chewieController,),),

            SizedBox(
              height: MediaQuery.of(context).size.height*0.2,
              child: Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(child: Text(widget.video.title,style: GoogleFonts.ptSans(textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20,)))),
                        likeButton(user.email!),
                      ],
                    ),

                    const Divider(),
                    Row(
                      children: [
                        const Icon(Icons.language),
                        Text(widget.video.language,style: GoogleFonts.ptSans(textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16))),
                      ],
                    ),
                    Text(widget.video.description,style: GoogleFonts.ptSans(textStyle: const TextStyle(fontSize: 16)), textAlign: TextAlign.start,),

                    const Divider(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.date_range),
                            Text(DateFormat('dd/MM/yyyy HH:mm').format(widget.video.creationDate),style: GoogleFonts.ptSans(textStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14))),
                          ],
                        ),

                        Row(
                          children: [
                            const Icon(Icons.remove_red_eye),
                            Text(widget.video.views.toString(),style: GoogleFonts.ptSans(textStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14))),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),


            Container(
              height: MediaQuery.of(context).size.height*0.45,
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Expanded(
                  child: Chat(collectionName: 'videos', docId: widget.video.id,)
              ),
            ),

          ],
        ),
      ),
    );
  }

  likeButton(String id){
    return LikeButton(
      size: 35,
      isLiked: isAlreadyLiked,
      animationDuration:const Duration(seconds: 2),
      circleColor:
      const CircleColor(start: Colors.redAccent, end: Colors.red),
      bubblesColor: const BubblesColor(
        dotPrimaryColor: Colors.redAccent,
        dotSecondaryColor: Colors.red,
      ),
      likeBuilder: (bool isLiked) {
        return Icon(
          Icons.favorite,
          color: isLiked ? Colors.red : Colors.grey,
          size: 35,
        );
      },
      likeCount: likesCount,
      countBuilder: (count,isLiked,text) {
        var color = isLiked ? Colors.red : Colors.grey;
        return Text(
          text,
          style: GoogleFonts.ptSans(color: color, fontSize: 16),
        );
      },
      onTap: (isLiked) async{
        //---------------IF ALREADY LIKED -> UNLIKE ELSE LIKE -------------
        await FirebaseFirestore.instance.collection('videos').doc(widget.video.id).update({
          "likes": isAlreadyLiked?FieldValue.arrayRemove([id]):FieldValue.arrayUnion([id]),
        });
        setState(() {
          fetchData();
        });

        return Future.value(!isLiked);
      },
    );
  }
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:livestream/Models/live_model.dart';
import 'package:livestream/Resources/firebase_auth_methods.dart';
import 'package:livestream/Screens/HomePage/profile_screen.dart';
import 'package:livestream/Widgets/my_appbar.dart';
import 'package:livestream/Widgets/live_video_widget.dart';
import 'package:livestream/translations/locale_keys.g.dart';
import 'package:provider/provider.dart';

import '../../Resources/firebase_storage_services.dart';
import '../../Services/Themes/my_themes.dart';
import '../Going Live/go_live_screen.dart';


class FollowingScreen extends StatefulWidget {
  const FollowingScreen({Key? key}) : super(key: key);

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {

  List<dynamic> followingList = []; // shouldn't use dynamic
  List<String> followingIds=[];

  Storage storage = Storage();
  late User user;

  getFollowingList() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.email)
        .get()
        .then((value) async {
      // get followerIds
      List<String> followersIds = List.from(value.data()!["following"]);
      followingIds=followersIds;
      // loop through all ids and get associated user object by userID/followerID
      for (int i = 0; i < followersIds.length; i++) {
        var followerId = followersIds[i];
        var data = await FirebaseFirestore.instance
            .collection("users")
            .doc(followerId)
            .get();

        followingList.add(data);
      }
      setState(() {
      });
    });
  }

  @override
  void initState() {
    super.initState();
    user = context.read<FirebaseAuthMethods>().user;
    getFollowingList();
  }


  @override
  Widget build(BuildContext context) {
    final bool isLight= Theme.of(context).brightness==MyThemes.lightTheme.brightness;

    return Scaffold(
      appBar: MyAppBar(implyLeading: false,title: "Bitrate Realm", action: Container(
          margin: const EdgeInsets.only(top: 7, bottom: 7, right: 10, left: 10),
          padding: const EdgeInsets.only(left: 10,right: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: InkWell(
            onTap: (){
              Navigator.pushNamed(context, GoLiveScreen.routeName);
            },
            child: const Row(
              children: [
                Text("LIVE", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                Icon(Icons.circle, color: Colors.red,size: 18,)
              ],
            ),
          )
      ),),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 600,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(LocaleKeys.following.tr(),style: GoogleFonts.ptSans(textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                  ),

                  //FOLLOWED CHANNELS
                  followingList.isNotEmpty?
                  StreamBuilder<List<LiveStream>>(
                      stream: getCurrentLives(),
                      builder: (context,snapshot){
                        if(snapshot.hasData){
                          if(snapshot.data!.isEmpty){
                            return SizedBox(
                              height: 150,
                              child: ListView.builder(
                                itemCount: followingList.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ProfileScreen(
                                                  id: followingList[index]["email"],
                                                  nickname: followingList[index]["nickname"],
                                                )));
                                      },
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 100,
                                            width: 100,
                                            child: FutureBuilder(
                                              future: storage.downloadURL("profile pictures", followingList[index]["email"]),
                                              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                                if(!snapshot.hasData){
                                                  return Container(
                                                      decoration: const BoxDecoration(
                                                          color: MyThemes.darkBlue,
                                                          shape: BoxShape.circle,
                                                          image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: AssetImage("assets/icons/avatar.png"),
                                                          )));
                                                }
                                                if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                                                  return Container(
                                                      decoration: BoxDecoration(
                                                          color: MyThemes.darkBlue,
                                                          shape: BoxShape.circle,
                                                          image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: NetworkImage(snapshot.data!),
                                                          )));

                                                }

                                                return const Center(child: CircularProgressIndicator(color: MyThemes.darkBlue,),);
                                              },
                                            ),
                                          ),
                                          const SizedBox(height: 5,),
                                          FittedBox(child: Text(followingList[index]["nickname"], style: GoogleFonts.ptSans(fontWeight: FontWeight.w700, fontSize: 16),overflow: TextOverflow.ellipsis,)),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                          return SizedBox(
                            height: 150,
                            child: ListView.builder(
                              itemCount: followingList.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                bool userIsLive = snapshot.data!.any((element) => element.user.contains(followingList[index]["email"]));
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: InkWell(
                                    onTap: (){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ProfileScreen(
                                                id: followingList[index]["email"],
                                                nickname: followingList[index]["nickname"],
                                              )));
                                    },
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: FutureBuilder(
                                            future: storage.downloadURL("profile pictures", followingList[index]["email"]),
                                            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                              if(!snapshot.hasData){
                                                return Container(
                                                    decoration:  BoxDecoration(
                                                        color: MyThemes.darkBlue,
                                                        shape: BoxShape.circle,
                                                        border: userIsLive?Border.all(color: Colors.red, width: 3):const Border(),
                                                        boxShadow: userIsLive?[
                                                          BoxShadow(
                                                            color: Colors.red.withOpacity(0.5),
                                                            spreadRadius: 5,
                                                            blurRadius: 7,
                                                            offset: const Offset(0, 3), // changes position of shadow
                                                          ),
                                                        ]:[],
                                                        image: const DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: AssetImage("assets/icons/avatar.png"),
                                                        )));
                                              }
                                              if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                                                return Container(
                                                    decoration: BoxDecoration(
                                                        color: MyThemes.darkBlue,
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(snapshot.data!),
                                                        )));
                                              }

                                              return const Center(child: CircularProgressIndicator(color: MyThemes.darkBlue,),);
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 5,),
                                        FittedBox(child: Text(followingList[index]["nickname"], style: GoogleFonts.ptSans(fontWeight: FontWeight.w700, fontSize: 16),overflow: TextOverflow.ellipsis,)),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        return const CircularProgressIndicator();
                      })
                  :Center(
                    child: Text("Nothing To show", style: GoogleFonts.ptSans(color: isLight ? MyThemes.darkBlue:Colors.white.withOpacity(0.8), fontSize: 14, fontWeight: FontWeight.w700), textAlign: TextAlign.center,),),

                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(LocaleKeys.liveNow.tr(),style: GoogleFonts.ptSans(textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                  ),


                  //LIST OF CURRENT LIVES
                  StreamBuilder<List<LiveStream>>(
                    stream: getCurrentLives(),
                      builder: (context,snapshot){
                      if(snapshot.hasData){
                        List<LiveStream> lives = snapshot.data!;
                        return ListView.builder(
                            itemCount: lives.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (BuildContext context, int index){
                              return LiveVideoWidget(video: lives[index]);
                            });
                      }
                      return const CircularProgressIndicator();
                      })

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

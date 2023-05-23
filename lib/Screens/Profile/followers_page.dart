import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:livestream/Resources/firebase_storage_services.dart';
import 'package:livestream/Screens/HomePage/home_screen.dart';
import 'package:livestream/Screens/HomePage/profile_screen.dart';
import 'package:provider/provider.dart';

import '../../Resources/firebase_auth_methods.dart';
import '../../Services/Themes/my_themes.dart';

class FollowersPage extends StatefulWidget {
  final String userId;
  final String collection;
  const FollowersPage({Key? key, required this.userId, required this.collection}) : super(key: key);

  @override
  State<FollowersPage> createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {

  List<dynamic> followersList = []; // shouldn't use dynamic
  Storage storage = Storage();

  getList() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userId)
        .get()
        .then((value) async {
      // get followerIds
      List<String> followersIds = List.from(value.data()![widget.collection]);
      // loop through all ids and get associated user object by userID/followerID
      for (int i = 0; i < followersIds.length; i++) {
        var followerId = followersIds[i];
        var data = await FirebaseFirestore.instance
            .collection("users")
            .doc(followerId)
            .get();

        followersList.add(data);
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemCount: followersList.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index){
        return ListTile(
          visualDensity: const VisualDensity(vertical: 1), // to expand
          leading: SizedBox(
            height: 50,
            width: 50,
            child: FutureBuilder(
              future: storage.downloadURL("profile pictures", followersList[index]["email"]),
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
          title: Text(followersList[index]["nickname"], style: GoogleFonts.ptSans(textStyle: const TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis)),),
          subtitle: Text(followersList[index]["bio"], style: GoogleFonts.ptSans(textStyle: const TextStyle(overflow: TextOverflow.ellipsis)),),

          onTap: (){
            if(followersList[index]["email"]==context.read<FirebaseAuthMethods>().user.email!) {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
                return Home(selectedIndex: 3);
              }), (route) => false);
            }else{
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                          id: followersList[index]["email"],
                          nickname: followersList[index]["nickname"]),
                        ),
                      );
            }
          },

        );
      },
    );
  }
}

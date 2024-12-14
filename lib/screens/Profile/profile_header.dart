import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:livestream/Services/firebase_storage_services.dart';
import 'package:livestream/Screens/Profile/chat_screen.dart';
import 'package:livestream/Widgets/profile_picture.dart';
import 'package:provider/provider.dart';

import '../../Services/firebase_auth_services.dart';
import '../../config/utils.dart';
import '../../config/app_style.dart';
import '../../translations/locale_keys.g.dart';


class ProfileHeader extends StatefulWidget {
  final String id;
  const ProfileHeader({Key? key, required this.id}) : super(key: key);

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  Uint8List? image; // IF WE USE FILE TYPE INSTEAD THEN WE WON'T BE ABLE TO USE IT ON WEB
  late String nickname="", bio="";
  late bool followed=true;
  late String imageURL="";
  Storage storage= Storage();

  @override
  void initState() {
    super.initState();
    _fetchData(context);
  }

  void _fetchData(BuildContext context) async{
   final user = context.read<FirebaseAuthServices>().user;

    FirebaseFirestore.instance.collection("users").doc(widget.id).get().then((DocumentSnapshot documentSnapshot) {
      List<String> following= List.from(documentSnapshot["followers"]);
      setState(() {
        nickname=documentSnapshot["nickname"];
        bio=documentSnapshot["bio"];
        followed=following.contains(user.email!);
      });
    }
    );
  }

  void followUnfollow(String myId, bool following) {
    FirebaseFirestore.instance.collection('users').doc(widget.id).update({
      "followers": following?FieldValue.arrayRemove([myId]):FieldValue.arrayUnion([myId]),
    });

    FirebaseFirestore.instance.collection('users').doc(myId).update({
      "following": following?FieldValue.arrayRemove([widget.id]):FieldValue.arrayUnion([widget.id]),
    });
  }

  void uploadImage(String fileName) async{
    showCupertinoModalPopup(context: context, builder: (BuildContext context){
      return CupertinoActionSheet(
        title: Text("Profile Picture", style: GoogleFonts.roboto(fontWeight: FontWeight.w800),),
        actions: [
          //CHOOSE IMAGE FROM GALLERY
          CupertinoActionSheetAction(
            onPressed: () async {

              Navigator.pop(context);

              Uint8List? pickedImage = await pickFile(context, FileType.image);
              if(pickedImage!=null){
                setState(() {
                  image=pickedImage;
                });

                //UPLOAD IMAGE TO FIREBASE STORAGE
                storage.uploadFile("profile pictures", pickedImage, fileName);

                setState(() {
                });
              }

            },
            child: Text(LocaleKeys.chooseFromGallery.tr(), style: GoogleFonts.roboto(),),
          ),

          // REMOVE CURRENT PHOTO : DEFAULT
          CupertinoActionSheetAction(
            onPressed: () async {

              Navigator.pop(context);

              // setState(() {
              //   image = null;
              // });

              //DELETE IMAGE FROM DATA STORAGE
              storage.deleteFile("profile pictures", widget.id);

              setState(() {
              });

            },
            child: Text(LocaleKeys.remove.tr(), style: GoogleFonts.roboto(color: Colors.red),),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthServices>().user;
    final isMe= widget.id == user.email!;

    return Column(
      children: [

        //PROFILE PICTURE
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [

                //PROFILE PICTURE
                ProfilePicture(id: widget.id, storage: storage, image: image,),

                //EDIT PROFILE PICTURE => PEN
                Visibility(
                  visible: isMe,
                  child: Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      margin: const EdgeInsets.all(3.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        color: MyThemes.primaryLight,
                        shape: BoxShape.circle,),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: (){
                          uploadImage(user.email!);
                          },
                        icon: const Icon(Icons.edit, color: Colors.white, size: 20,),
                      ),
                    ),
                  ),
                ),),
              ],
            ),
          ),
        ),

        //NICKNAME
        Text(
          nickname,
          style: GoogleFonts.ptSans(textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),

        ),

        //DESCRIPTION
        Text(
          bio,
          style: GoogleFonts.ptSansCaption(textStyle: const TextStyle(fontSize: 15)),
        ),

        Visibility(
          visible: !isMe,
          child: const SizedBox(height: 16),),

        //FOLLOW & MESSAGE BUTTON
        Visibility(
          visible: !isMe,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton.extended(
                onPressed: () {
                  if(followed){
                    followUnfollow(user.email!,followed);
                  }else{
                    followUnfollow(user.email!,followed);
                  }

                  setState(() {
                    followed=!followed;
                  });
                },
                heroTag: 'follow',
                elevation: 0,
                label: followed? Text(LocaleKeys.following.tr()) :  Text(LocaleKeys.follow.tr()),
                backgroundColor: followed? MyThemes.primaryLight : Colors.red,
                foregroundColor: Colors.white,
                icon: Icon(followed?Icons.check:Icons.person_add_alt_1),
              ),
              const SizedBox(width: 10.0),
              FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatScreen(receiver: widget.id)));
                },
                heroTag: 'message',
                elevation: 0,
                backgroundColor: Colors.red,
                label: Text(LocaleKeys.message.tr()),
                icon: const Icon(Icons.message_rounded),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

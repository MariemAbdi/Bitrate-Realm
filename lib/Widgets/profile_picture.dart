import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../Resources/firebase_storage_services.dart';
import '../Services/Themes/my_themes.dart';

class ProfilePicture extends StatelessWidget {
  final String id;
  final Storage storage;
  final Uint8List? image;
  const ProfilePicture({Key? key, required this.id, required this.storage, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: storage.downloadURL("profile pictures", id),
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
          if(image==null){
            return Container(
                decoration: BoxDecoration(
                    color: MyThemes.darkBlue,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(snapshot.data!),
                    )));
          }else{
            return Container(
                decoration: BoxDecoration(
                    color: MyThemes.darkBlue,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: MemoryImage(image!),
                    )));
          }
        }

        return const Center(child: CircularProgressIndicator(color: MyThemes.darkBlue,),);
      },
    );
  }
}

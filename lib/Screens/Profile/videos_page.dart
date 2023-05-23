import 'dart:core';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:livestream/Models/live_model.dart';
import 'package:livestream/translations/locale_keys.g.dart';

import '../../Services/Themes/my_themes.dart';
import '../../Widgets/videoWidget.dart';


class VideosPage extends StatefulWidget {
  final String userId;
  const VideosPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<LiveStream>>(
        stream: getMyVideos(widget.userId),
        builder: (context, snapshot){
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  '${LocaleKeys.somethingWentWrong.tr()} ${snapshot.error}',
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.w800)),
            );
          } else if (snapshot.hasData) {
            var videosList = snapshot.data!;
            return ListView.builder(
                itemCount: videosList.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (BuildContext context, int index){
                  LiveStream video= videosList[index];
                  return VideoWidget(video: video);
                });
          }

          return const Center(
              child: CircularProgressIndicator(
                color: MyThemes.darkBlue,
              ));
        });
  }
}

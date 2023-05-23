import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:livestream/Widgets/my_appbar.dart';
import 'package:livestream/translations/locale_keys.g.dart';
import 'package:provider/provider.dart';

import '../../Models/live_model.dart';
import '../../Resources/firebase_auth_methods.dart';
import '../../Services/Themes/my_themes.dart';
import '../../Widgets/videoWidget.dart';

class FavouriteVideos extends StatefulWidget {
  const FavouriteVideos({Key? key}) : super(key: key);

  @override
  State<FavouriteVideos> createState() => _FavouriteVideosState();
}

class _FavouriteVideosState extends State<FavouriteVideos> {
  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthMethods>().user;
    final bool isLight= Theme.of(context).brightness==MyThemes.lightTheme.brightness;
    return Scaffold(
      appBar: MyAppBar(implyLeading: true, title: LocaleKeys.myFavourites.tr(), action: Container()),
      body: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 600,
        ),
        child: StreamBuilder<List<LiveStream>>(
          stream: getMyFavouriteVideos(user.email!),
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
                if(videosList.isEmpty){
                  return Center(
                    child: Text(
                      LocaleKeys.noVideoLiked.tr(),
                      style: GoogleFonts.ptSans(color: isLight ? MyThemes.darkBlue:Colors.white.withOpacity(0.8),
                          fontSize: 20,
                          fontWeight: FontWeight.w700), textAlign: TextAlign.center,),
                  );
                }
                return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    itemCount: videosList.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index){
                      LiveStream video = videosList[index];
                      return VideoWidget(video: video);
                    });
              }

              return const Center(
                  child: CircularProgressIndicator(
                    color: MyThemes.darkBlue,
                  ));
            }
        ),
      ),
    );
  }
}

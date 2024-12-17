import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bitrate_realm/Widgets/my_appbar.dart';
import 'package:bitrate_realm/translations/locale_keys.g.dart';
import 'package:provider/provider.dart';

import '../../models/live_stream.dart';
import '../../providers/auth_provider.dart';
import '../../services/firebase_auth_services.dart';
import '../../config/app_style.dart';
import '../../services/livestream_services.dart';
import '../../widgets/video_widget.dart';

class FavouriteVideos extends StatefulWidget {
  const FavouriteVideos({Key? key}) : super(key: key);

  @override
  State<FavouriteVideos> createState() => _FavouriteVideosState();
}

class _FavouriteVideosState extends State<FavouriteVideos> {
  @override
  Widget build(BuildContext context) {
    //final user = context.read<FirebaseAuthServices>().user;
    final user = Provider.of<AuthProvider>(context).user;
    final bool isLight= Theme.of(context).brightness==MyThemes.customTheme.brightness;
    return Scaffold(
      appBar: MyAppBar(implyLeading: true, title: LocaleKeys.myFavourites.tr(), action: Container()),
      body: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 600,
        ),
        child: StreamBuilder<List<LiveStream>>(
          stream: LiveStreamServices().getMyFavouriteVideos(user!.email!),
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
                      style: GoogleFonts.ptSans(color: isLight ? MyThemes.primaryLight:Colors.white.withOpacity(0.8),
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
                    color: MyThemes.primaryLight,
                  ));
            }
        ),
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


import '../screens/Discover/upload_video.dart';
import '../config/app_style.dart';
import '../models/live_stream.dart';
import '../services/livestream_services.dart';
import '../widgets/live_video_widget.dart';
import '../widgets/video_widget.dart';
import '../translations/locale_keys.g.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {

  late int _currentIndex=0;

  final categories=[
  "Gaming",
  "Tutorial",
  "Vlog"];

  buildTabs(String title, int index) {
    return GestureDetector(
      onTap: (){
        setState(() {
          _currentIndex=index;
        });
      },
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          //color: _currentIndex==index?MyThemes.primaryLight:MyThemes.primaryLight.withOpacity(0.2),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 0.5,
              spreadRadius: 0.5,
              offset: const Offset(1,1),
            )
          ],
        ),
        child: Text(title, style: GoogleFonts.ptSans(color:Colors.white, fontWeight: FontWeight.w800, fontSize: 16),),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLight= Theme.of(context).brightness==MyThemes.customTheme.brightness;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:false,
        title: Text(LocaleKeys.discover.tr()),
        actions: [
          Container(
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
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const UploadVideoScreen()));
                },
                child:  Row(
                  children: [
                    Text(LocaleKeys.upload.tr(), style: GoogleFonts.ptSans(color: Colors.red, fontWeight: FontWeight.bold)),
                    const Icon(Icons.video_call_sharp, color: Colors.red,size: 18,)
                  ],
                ),
              )
          )
        ],),
      body: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 600,
        ),
        child: Column(
          children: [

            const SizedBox(height: 15,),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                buildTabs(LocaleKeys.all.tr(), 0),
                buildTabs(categories[0], 1),
                buildTabs(categories[1], 2),
                buildTabs(categories[2], 3),
              ],),
            ),

            const SizedBox(height: 15,),

            //TAB BAR CONTENT
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(15.0),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                children: [

                  SingleChildScrollView(

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(LocaleKeys.liveNow.tr(),style: GoogleFonts.ptSans(textStyle: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18))),
                        //------------------------LATEST 10 LIVE STREAMS------------------------
                        SizedBox(
                          height: 280,
                          child: StreamBuilder<List<LiveStream>>(
                            stream: LiveStreamServices().getCurrentLives(),
                            builder: (context, snapshot) {
                              if(snapshot.hasData){
                                var videosList = snapshot.data!;
                                if(videosList.isEmpty){
                                  return Center(
                                    child: Text(
                                      LocaleKeys.nothingToShow.tr(),
                                      style: GoogleFonts.ptSans(
                                          //color: isLight ? MyThemes.primaryLight:Colors.white.withOpacity(0.8),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700), textAlign: TextAlign.center,),
                                  );
                                }
                                return ListView.builder(
                                  itemCount: videosList.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (BuildContext context, int index) {
                                    LiveStream video = videosList[index];
                                    return SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            Container(
                                                width:300,
                                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                                child: LiveVideoWidget(video: video)),
                                          ],
                                        ));
                                  },

                                );
                              }
                              return const CircularProgressIndicator();
                            }
                          ),
                        ),


                        const SizedBox(height: 20,),

                        //------------------------VIDEOS------------------------
                        Text(LocaleKeys.videos.tr(),style: GoogleFonts.ptSans(textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),

                        StreamBuilder<List<LiveStream>>(
                            stream: _currentIndex == 0 ? LiveStreamServices().getAllVideos("date", true)
                                : LiveStreamServices().getVideosPerCategory(categories[_currentIndex-1]),
                            builder: (context, snapshot){
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text(
                                    LocaleKeys.nothingToShow.tr(),
                                    style: GoogleFonts.ptSans(
                                        //color: isLight ? MyThemes.primaryLight:Colors.white.withOpacity(0.8),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700), textAlign: TextAlign.center,),
                                );
                              } else if (snapshot.hasData) {
                                var videosList = snapshot.data!;
                                if(videosList.isEmpty){
                                  return Center(
                                    child: Text(
                                      LocaleKeys.nothingToShow.tr(),
                                      style: GoogleFonts.ptSans(
                                          //color: isLight ? MyThemes.primaryLight:Colors.white.withOpacity(0.8),
                                          fontSize: 16,
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
                                    //color: MyThemes.primaryLight,
                                  ));
                            }
                        ),

                        const SizedBox(height: 15,),



                      ],

                    ),

                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
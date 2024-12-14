import 'dart:async';
import 'dart:convert';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:livestream/config/routing.dart';
import 'package:livestream/config/utils.dart';
import 'package:livestream/translations/locale_keys.g.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';


import '../../models/live_stream.dart';
import '../../services/firebase_auth_services.dart';
import '../../config/app_style.dart';
import '../../services/livestream_services.dart';
import '../../widgets/chat_livestream.dart';
import '../../widgets/utils/custom_button.dart';



class BroadcastScreen extends StatefulWidget{
  static String routeName = '/broadcast';
  final bool isBroadcaster;
  final String channelId;
  final LiveStream? liveStream; //USED TO SHOW THE LIVE INFO
  const BroadcastScreen({Key? key, required this.isBroadcaster, required this.channelId, this.liveStream}) : super(key: key);

  @override
  State<BroadcastScreen> createState() => _BroadcastScreenState();
}

class _BroadcastScreenState extends State<BroadcastScreen> with WidgetsBindingObserver{

  late final RtcEngine _engine;
  String? token;
  final List<int> _remoteUid = []; //LIST OF VIEWERS
  bool _cameraSwitched = true;
  bool _isMuted = false;
  late bool _showDetails = true;
  //late Duration timeDuration = const Duration(seconds: 0);
  late int elapsedTime=0;
  int _viewCount = 0;
  bool _isFullScreen = false;

  // Add the AppLifecycleObserver to your state class
  late AppLifecycleObserver _observer;

  // Declare the method to be called
  Future<void> deleteDocument() async {
    await LiveStreamServices().endLiveStream(widget.channelId);
  }

  final user= FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();

    // initialize the Agora RTC engine
    _initEngine();

    // start the timer to update the elapsed time
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        elapsedTime = DateTime.now().difference(widget.liveStream!.creationDate).inSeconds;
        //timeDuration = Duration(seconds: elapsedTime);
        getViewCount();
      });
    });

    //OVERRIDE THE initState() METHOD TO ADD THE ENGINE
    _observer = AppLifecycleObserver(() async {
      await deleteDocument();
      // Exit the app
      SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
    });
    WidgetsBinding.instance.addObserver(_observer);
  }

  @override
  void dispose() {
    // Override the dispose() method to remove the observer
    WidgetsBinding.instance.removeObserver(_observer);
    _remoteUid.clear();
    // dispose of the controller and the Agora RTC engine
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }


  // Override the didChangeAppLifecycleState() method to handle the lifecycle events
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      deleteDocument();
    }
  }

  //ENGINE INITIALIZATION
  void _initEngine() async {
    _engine = await RtcEngine.createWithContext(RtcEngineContext(dotenv.env["APP_ID"]!));
    _addListeners();


    // configure the Agora RTC engine
    await _engine.enableVideo();
    await _engine.enableAudio();


    // In my experience, Agora engine sometimes uses the speakerphone mode by default, and sometimes earphone mode.
    // This method allows you to set the default one.
    // If you want to change the settings during the call, just call setEnableSpeakerphone (bool enabled)_
    //await _engine.setDefaultAudioRoutetoSpeakerphone(true);

      await _engine.startPreview();
      await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);


    //CHECK THE ROLE OF THE USER TO SET IT
    _engine.setClientRole(widget.isBroadcaster?ClientRole.Broadcaster:ClientRole.Audience);


    // start the live stream player
    _joinChannel();
  }


  Future<void> getToken() async {
    final res = await http.get(
      Uri.parse('${dotenv.env["RENDER_BASEURL"]}/rtc/${widget.channelId}/publisher/userAccount/${context.read<FirebaseAuthServices>().user.uid}/'),
    );

    if (res.statusCode == 200) {
      setState(() {
        token = res.body;
        token = jsonDecode(token!)['rtcToken'];
      });
    } else {
      debugPrint('Failed to fetch the token');
    }
  }

  //WHENEVER A USER JOINS THE LIVE WE ARE NOTIFIED
  void _addListeners() {
    _engine.setEventHandler(RtcEngineEventHandler(
        joinChannelSuccess: (channel, uid, elapsed){
          debugPrint('joinChannelSuccess $channel $uid $elapsed');
        },
        userJoined: (uid, elapsed){
          debugPrint('userJoined $uid $elapsed');
          setState(() {
            _remoteUid.add(uid);
          });
        },
        userOffline: (uid, reason){ //HOW THE USER GOT DISCONNECTED
          debugPrint('userOffline $uid $reason');
          setState(() {
            _remoteUid.removeWhere((element) => element == uid);
          });
        },
        leaveChannel: (stats){
          debugPrint("leaveChannel $stats");
          setState(() {
            _remoteUid.clear();
          });
        },

        tokenPrivilegeWillExpire: (token)async{
          await getToken();
          await _engine.renewToken(token);
        }
    ));
  }

  //JOIN CHANNEL
  void _joinChannel() async{
    await getToken();
    if(token!=null){
      //REQUEST FOR MIC AND CAMERA PERMISSIONS
      if(defaultTargetPlatform == TargetPlatform.android && widget.isBroadcaster){
        await [Permission.microphone, Permission.camera].request();
      }
      //if(!mounted)return;
      await _engine.joinChannelWithUserAccount(token, widget.channelId, context.read<FirebaseAuthServices>().user.uid);
    }
  }

  //LEAVE CHANNEL
  _leaveChannel(String uid) async{
    await _engine.leaveChannel();
    //IF THE ONE LEAVING IS THE STREAMER THEN THE LIVE ENDS
    if(uid == widget.channelId){
        await LiveStreamServices().endLiveStream(widget.channelId);
        _engine.disableAudio();
        _engine.disableVideo();
    }else{
      //IF THE ONE LEAVING IS A VIEWER THEN THE VIEWS COUNT IS UPDATED
      await LiveStreamServices().updateViewCount(widget.channelId, false);
    }

    homeNavigation();
  }

  //SWITCH CAMERA
  void _switchCamera() {
    _engine.switchCamera().then((value){
      setState(() {
        _cameraSwitched= !_cameraSwitched;
      });
    }).catchError((error){
      debugPrint('Switch Camera $error');
    });
  }

  //MUTE|UN-MUTE MICROPHONE
  void _onToggleMute() async{
    setState(() {
      _isMuted=!_isMuted;
    });
    await _engine.muteLocalAudioStream(_isMuted);
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (p) async {
        customConfirmationCoolAlert(context, LocaleKeys.leave.tr(), LocaleKeys.areYouSureYouWantToLeave.tr(), "assets/lottie/sad-dog.json", ()async {await _leaveChannel(context.read<FirebaseAuthServices>().user.uid);});
        return Future.value(true);
      },
      child: Scaffold(
        bottomNavigationBar:
        Visibility(
          visible: !_isFullScreen,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 600,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
              child: CustomButton(text: LocaleKeys.leave.tr(), onPressed: (){
                customConfirmationCoolAlert(context, LocaleKeys.leave.tr(), LocaleKeys.areYouSureYouWantToLeave.tr(), "assets/lottie/sad-dog.json",
                  ()async {
                  await _leaveChannel(context.read<FirebaseAuthServices>().user.uid);
                });
              },),
            ),
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 600,
                  ),
                  child: Column(
                    children: [

                      //STREAMING
                      OrientationBuilder(
                        builder: (context, orientation){
                          return SizedBox(
                            width: double.infinity,
                            height: _isFullScreen?MediaQuery.of(context).size.height:MediaQuery.of(context).size.height*0.3,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                //VIDEO STREAM
                                InkWell(
                                  onTap:(){
                                    setState(() {
                                      _showDetails=!_showDetails;
                                    });
                                  },
                                  child: _renderVideo(false),
                                ),

                                //LIVE DURATION
                                Visibility(
                                  visible: _showDetails,
                                  child: Positioned(
                                      bottom: 10,
                                      left: 10,
                                      child: FittedBox(child: Text(formatDuration(elapsedTime), style: GoogleFonts.ptSans(fontWeight: FontWeight.bold),))),
                                ),

                                //LIVE VIEW COUNT
                                Visibility(
                                  visible: _showDetails,
                                  child: Positioned(
                                      top: 10,
                                      right: 10,
                                      child: Row(
                                        children: [
                                          FittedBox(child: Text(_viewCount.toString(), style: GoogleFonts.ptSans(fontWeight: FontWeight.bold),)),
                                          const SizedBox(width: 2,),
                                          const Icon(Icons.remove_red_eye),
                                        ],
                                      )),
                                ),

                                //IF STREAMER THEN HE CAN SWITCH CAMERA AND MUTE THE MICROPHONE
                                if(widget.isBroadcaster)
                                  Visibility(
                                    visible: _showDetails,
                                    child: Positioned(
                                      bottom: 5,
                                      right: 50,
                                      child: Row(
                                        children: [
                                          Visibility(
                                            visible:!kIsWeb,
                                            child: CircleAvatar(
                                              radius: 22,
                                              backgroundColor: Colors.transparent,
                                              child: Container(
                                                margin: const EdgeInsets.all(3.0),
                                                padding: const EdgeInsets.all(8.0),
                                                decoration: const BoxDecoration(
                                                  color: MyThemes.primaryLight,
                                                  shape: BoxShape.circle,),
                                                child: IconButton(
                                                  padding: EdgeInsets.zero,
                                                  onPressed: _switchCamera,
                                                  icon: const Icon(Icons.cameraswitch, color: Colors.white, size: 22,),
                                                ),
                                              ),
                                            ),
                                          ),
                                          CircleAvatar(
                                            radius: 22,
                                            backgroundColor: Colors.transparent,
                                            child: Container(
                                              margin: const EdgeInsets.all(3.0),
                                              padding: const EdgeInsets.all(8.0),
                                              decoration: const BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,),
                                              child: IconButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: _onToggleMute,
                                                icon: Icon(_isMuted?Icons.mic:Icons.mic_off, color: Colors.white, size: 22,),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                Visibility(
                                  visible: !kIsWeb && _showDetails,
                                  child: Positioned(
                                    bottom: 5,
                                    right: 5,
                                    child: CircleAvatar(
                                      radius: 22,
                                      backgroundColor: Colors.transparent,
                                      child: Container(
                                        margin: const EdgeInsets.all(3.0),
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade700,
                                          shape: BoxShape.circle,),
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: (){
                                            setState(() {
                                              setState(() {
                                                if(_isFullScreen) {
                                                  // rotate screen back to portrait mode
                                                  SystemChrome
                                                      .setPreferredOrientations([
                                                    DeviceOrientation.portraitUp,
                                                  ]);}else{
                                                  // rotate screen to landscape mode
                                                  SystemChrome.setPreferredOrientations([
                                                    DeviceOrientation.landscapeLeft,
                                                    DeviceOrientation.landscapeRight,
                                                  ]);
                                                }
                                                setState(() {
                                                  _isFullScreen = !_isFullScreen;
                                                });
                                              });
                                            });
                                          },
                                          icon: Icon(_isFullScreen?Icons.fullscreen_exit:Icons.fullscreen, color: Colors.white, size: 22,),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                      ),

                      //LIVE INFORMATION
                      Visibility(
                        visible: !_isFullScreen,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height*0.2,
                          child: Expanded(
                            child: ListView(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                              children: [

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(child: Text(widget.liveStream!.title,style: GoogleFonts.ptSans(textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20,)))),
                                    Text(widget.liveStream!.language,style: GoogleFonts.ptSans(textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20,)))
                                  ],
                                ),

                                const Divider(),
                                Text(widget.liveStream!.description,style: GoogleFonts.ptSans(textStyle: const TextStyle(fontSize: 16)), textAlign: TextAlign.start,),

                                const Divider(),

                                Row(
                                  children: [
                                    const Icon(Icons.date_range),
                                    Text(DateFormat('dd/MM/yyyy HH:mm').format(widget.liveStream!.creationDate),style: GoogleFonts.ptSans(textStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Visibility(
                        visible: !_isFullScreen,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          height: MediaQuery.of(context).size.height*0.40,
                          child: Expanded(
                              child: Chat(collectionName: 'live_streams', docId: widget.channelId,)
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
        ),
      ),
    );
  }

  //LIVE VIDEO CONFIGURATION BASED ON THE USER (BROADCASTER|VIEWER) AND DEVICE (DESKTOP|MOBILE)
  _renderVideo(isScreenSharing) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: widget.isBroadcaster//"${user.uid}" == widget.channelId
          ? isScreenSharing
          ? kIsWeb
          ? const rtc_local_view.SurfaceView.screenShare()
          : const rtc_local_view.TextureView.screenShare()
          : const rtc_local_view.SurfaceView(zOrderMediaOverlay: true, zOrderOnTop: true,)
          : isScreenSharing
          ? kIsWeb
          ? const rtc_local_view.SurfaceView.screenShare()
          : const rtc_local_view.TextureView.screenShare()
          : _remoteUid.isNotEmpty
          ? kIsWeb
          ? rtc_remote_view.SurfaceView(uid: _remoteUid[0], channelId: widget.channelId, mirrorMode: VideoMirrorMode.Auto, renderMode: VideoRenderMode.Hidden,)
          : rtc_remote_view.TextureView(uid: _remoteUid[0], channelId: widget.channelId,)
          : Container(),
    );
  }

  void getViewCount() {
    FirebaseFirestore.instance.collection("live_streams").doc(widget.channelId).get().then((DocumentSnapshot documentSnapshot) {
      setState(() {
        _viewCount=documentSnapshot["views"];
      });
    });
  }
}

class AppLifecycleObserver extends WidgetsBindingObserver {
  final Function onAppPaused;

  AppLifecycleObserver(this.onAppPaused);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      onAppPaused();
    }
  }
}



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:bitrate_realm/config/utils.dart';
import 'package:provider/provider.dart';

import '../services/firebase_auth_services.dart';
import '../config/app_style.dart';
import '../Widgets/single_message.dart';
import 'package:intl/intl.dart' as intl;
import 'package:timeago/timeago.dart' as timeago;
import 'package:get/get.dart' hide Trans;

import '../translations/locale_keys.g.dart';


class ChatScreen extends StatefulWidget {

  final String receiver;

  const ChatScreen({super.key, required this.receiver});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final currentUser=GetStorage();
  final TextEditingController _controller = TextEditingController();

  late String receiverName="";

  void _fetchData() async{
    FirebaseFirestore.instance.collection("users").doc(widget.receiver).get().then((DocumentSnapshot documentSnapshot) {
      setState(() {
        receiverName=documentSnapshot["username"];
      });
    }
    );
  }

  getTimeAgo(DateTime dt){
    Locale currentLocale = EasyLocalization.of(context)!.locale;
    debugPrint(currentLocale.countryCode);
    if(DateTime.now().difference(dt).inDays>=2 && DateTime.now().difference(dt).inDays<7) {
      return timeago.format(dt);
      //return DateFormat('EEEE', locale).format(dt);
    } else if (DateTime.now().difference(dt).inDays<=1) {
      return timeago.format(dt,locale: currentLocale.languageCode);
    } else {
      return DateFormat('dd/MM/yyyy').format((dt));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    _fetchData();
  }

    //SEND MESSAGE
    sendMessage() async{
    // final user = context.read<FirebaseAuthServices>().user;
      //final user = Provider.of<AuthProvider>(context).user;
      final user = FirebaseAuthServices().user!;
      String message=_controller.text;
      _controller.clear();
      await FirebaseFirestore.instance.collection('users').doc(user!.email)
          .collection('messages').doc(widget.receiver).collection('chats').add({
        "senderId":user!.email,
        "receiverId":widget.receiver,
        "message":message,
        "type":"text",
        "date":DateTime.now(),
      });

      await FirebaseFirestore.instance.collection('users').doc(widget.receiver)
          .collection('messages').doc(user.email).collection('chats').add({
        "senderId":user.email,
        "receiverId":widget.receiver,
        "message":message,
        "type":"text",
        "date":DateTime.now(),
      });
    }

    //MESSAGE FIELD WIDGET
    Widget messageField(){
      return Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                validator: (msg) {
                  if (msg!.isEmpty) {
                    return LocaleKeys.typeSomethingFirst.tr();
                  }
                  return null;
                },
                controller: _controller,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: LocaleKeys.chat.tr(),
                    hintText: LocaleKeys.saySomething.tr(),
                    prefixIcon: const Icon(Icons.chat),
                    border: const OutlineInputBorder(),

                    suffixIcon: _controller.text.isEmpty
                        ? null
                        : IconButton(
                      icon: const Icon(EvaIcons.close),
                      onPressed: () {
                        setState(() {
                          _controller.clear();
                        });
                      },
                    )),
                onChanged: (value) {
                  setState(() {});
                },
                onFieldSubmitted: (msg){
                  //SEND MESSAGE
                  sendMessage();
                },
              ),
            ),
            GestureDetector(
              onTap: (){
                sendMessage();
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(Icons.telegram,
                 // color: MyThemes.primaryLight,
                  size: MediaQuery.of(context).size.width*0.12,),
              ),
            )
          ],
        ),
      );
    }

  @override
  Widget build(BuildContext context) {
    // final user = context.read<FirebaseAuthServices>().user;
    final user = FirebaseAuthServices().user!;
    return RefreshIndicator(
     // color: Theme.of(context).brightness==MyThemes.customTheme.brightness?MyThemes.secondaryLight:Colors.white,
      //backgroundColor: Theme.of(context).brightness==MyThemes.customTheme.brightness?MyThemes.primaryLight:Colors.grey.shade800,
      onRefresh: ()async{
        _fetchData();
      },
      child: GestureDetector(
        onTap: (){
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          //appBar: MyAppBar(implyLeading: true, title: receiverName, action: Container()),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                //chat body
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('users').doc(user!.email).collection('messages').doc(widget.receiver).collection('chats').orderBy('date', descending: true).snapshots(),
                      builder: (context,AsyncSnapshot snapshot){
                        if(snapshot.hasData){
                          return ListView.builder(
                              itemCount: snapshot.data.docs.length,
                              reverse: true,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context,index){
                                bool isMe=snapshot.data.docs[index]['senderId'].compareTo(user!.email)==0;
                                return  SingleMessage(isMe: isMe,message: snapshot.data.docs[index]['message'],receiverId: widget.receiver,type: snapshot.data.docs[index]['type'],sent: getTimeAgo(snapshot.data.docs[index]['date'].toDate()),);
                              });
                        }
                        //intl.DateFormat("dd/MM/yyyy kk:mm").format(snapshot.data.docs[index]['date'].toDate())
                        return const Center(child: CircularProgressIndicator(),);
                      },
                    ),
                  ),
                ),

                messageField(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

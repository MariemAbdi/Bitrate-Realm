import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:livestream/Models/live_stream.dart';
import 'package:livestream/config/app_style.dart';
import 'package:livestream/Services/livestream_services.dart';
import 'package:provider/provider.dart';

import '../Services/firebase_auth_services.dart';
import '../translations/locale_keys.g.dart';

class Chat extends StatefulWidget {
  final String collectionName;
  final String docId;
  const Chat({Key? key, required this.collectionName, required this.docId,}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _chatController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthServices>().user;

    //MESSAGE FIELD WIDGET
    Widget messageField(){
      return Row(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: TextFormField(
                validator: (msg) {
                  if (msg!.isEmpty) {
                    return LocaleKeys.typeSomethingFirst.tr();
                  }
                  return null;
                },
                controller: _chatController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: LocaleKeys.chat.tr(),
                    hintText: LocaleKeys.saySomething.tr(),
                    prefixIcon: const Icon(Icons.chat),
                    border: const OutlineInputBorder(),

                    suffixIcon: _chatController.text.isEmpty
                        ? null
                        : IconButton(
                      icon: const Icon(EvaIcons.close),
                      onPressed: () {
                        setState(() {
                          _chatController.clear();
                        });
                      },
                    )),
                onChanged: (value) {
                  setState(() {});
                },
                onFieldSubmitted: (msg){
                  //SEND MESSAGE
                  LiveStreamServices().addComment(widget.collectionName, widget.docId,_chatController.text.trim(),user.displayName!, widget.docId, context);
                  _chatController.clear();
                  setState(() {});
                },
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              //SEND MESSAGE
              LiveStreamServices().addComment(widget.collectionName, widget.docId,_chatController.text.trim(),user.displayName!, widget.docId, context);
              _chatController.clear();
              setState(() {});
            },
            child: const Padding(
              padding:  EdgeInsets.all(8),
              child: Icon(Icons.telegram,color: MyThemes.primaryLight, size: 40,),
            ),
          )
        ],
      );
    }

    return SizedBox(
      //width: size.width>900? size.width*0.25 : size.width*0.9,
      height: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          Expanded(
            child: StreamBuilder<dynamic>(
              stream: FirebaseFirestore.instance.collection(widget.collectionName).doc(widget.docId).collection('comments').orderBy('createdAt', descending: true).snapshots(),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index){
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(snapshot.data.docs[index]['nickname'], style: GoogleFonts.ptSans(fontWeight:FontWeight.w900, color: snapshot.data.docs[index]['uid'] == user.uid ? MyThemes.primaryLight : MyThemes.secondaryLight),overflow: TextOverflow.ellipsis, maxLines: 1,),
                              Text(DateFormat('dd/MM/yyyy HH:mm').format((snapshot.data.docs[index]['createdAt']).toDate()), style: GoogleFonts.ptSans(fontSize: 12)),
                            ],
                          ),
                          subtitle: Text(snapshot.data.docs[index]['message'], style: GoogleFonts.ptSans(color: Colors.black),),
                        );
                      });
                }
                return Container();
              },
            ),
          ),

          messageField(),
        ],
      ),
    );
  }
}

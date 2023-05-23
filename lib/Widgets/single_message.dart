import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Services/Themes/my_themes.dart';

class SingleMessage extends StatefulWidget {

  final String message;
  final String receiverId;
  final bool isMe;
  final String type;
  final String sent;

  const SingleMessage({super.key, required this.message,required this.isMe, required this.receiverId,required this.type,required this.sent});
  @override
  State<SingleMessage> createState() => _SingleMessageState();
}

class _SingleMessageState extends State<SingleMessage> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: widget.isMe? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: widget.isMe? CrossAxisAlignment.end : CrossAxisAlignment.start,
      //crossAxisAlignment: widget.type.compareTo('text')==0?CrossAxisAlignment.center:CrossAxisAlignment.end,
      children: [
        widget.type.compareTo("text")==0?
        Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.all(3),
          constraints: const BoxConstraints(maxWidth: 300),
          decoration: BoxDecoration(color: widget.isMe? MyThemes.darkBlue: MyThemes.lightBlue,
              borderRadius: const BorderRadius.all(Radius.circular(12))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.message, style: GoogleFonts.ptSans(color: Colors.white, fontSize: 16),),
              Text(widget.sent,style: GoogleFonts.ptSans(color: Colors.grey, fontSize: 11))
            ],
          ),
        ):Container(
          margin: const EdgeInsets.all(3),
          height: MediaQuery.of(context).size.height/2.5,
          width: MediaQuery.of(context).size.width/2,
          decoration: BoxDecoration(border: Border.all(),
            color: widget.isMe? MyThemes.darkBlue.withOpacity(0.5): MyThemes.lightBlue.withOpacity(0.5),),
          child: widget.message!=""?Image.network(widget.message,fit: BoxFit.contain,):
          const CircularProgressIndicator(color: MyThemes.darkBlue,),
        ),
      ],
    );
  }
}
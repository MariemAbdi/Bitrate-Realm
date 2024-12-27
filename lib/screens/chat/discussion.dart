import 'package:bitrate_realm/models/message.dart';
import 'package:bitrate_realm/models/user.dart';
import 'package:bitrate_realm/services/chat_services.dart';
import 'package:bitrate_realm/widgets/utils/custom_app_bar.dart';
import 'package:bitrate_realm/widgets/utils/custom_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:timeago/timeago.dart' as timeago;
import '../../services/firebase_auth_services.dart';
import '../../widgets/chat/message_bubble.dart';
import '../../widgets/input/send_input.dart';
import '../../widgets/utils/custom_async_builder.dart';
import '../../widgets/utils/nothing_to_show.dart';


class DiscussionScreen extends StatefulWidget {
  const DiscussionScreen({super.key, required this.receiver});
  final UserModel receiver;
  @override
  State<DiscussionScreen> createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends State<DiscussionScreen> {

  final currentUser= FirebaseAuthServices().user;
  late  TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
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
  Widget build(BuildContext context) {
    final user = FirebaseAuthServices().user!;
    return GestureDetector(
      onTap: ()=> SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: CustomAppBar(title: widget.receiver.username),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
            children: [
                //chat body
                Expanded(
                  child: CustomAsyncBuilder(
                    stream: ChatServices().getMessages(userId: user.email!, receiver: widget.receiver.email),
                    builder: (context, value){
                      List<Message> messages = value!;
                      if(messages.isEmpty){
                        return const NothingToShow();
                      }
                        return CustomListView(
                            itemCount: messages.length,
                            reverse: true,
                            itemBuilder: (context,index){
                              Message message = messages[index];
                              bool isMe = message.sender == user.email!;
                              return MessageBubble(
                                isMe: isMe,
                                receiver: widget.receiver,
                                message: message,
                              );
                            });
                    },
                  ),
                ),


              SendInput(
                controller: _messageController,
                clearAfter: true,
                onConfirm: (_)=>ChatServices().sendMessage(
                    Message(
                        message: _messageController.text.trim(),
                        sender: user.email!,
                        receiver: widget.receiver.email,
                        date: DateTime.now()
                    )
                ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

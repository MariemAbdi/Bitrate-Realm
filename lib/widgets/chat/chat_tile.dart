import 'package:bitrate_realm/config/app_style.dart';
import 'package:bitrate_realm/models/user.dart';
import 'package:bitrate_realm/widgets/utils/custom_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:substring_highlight/substring_highlight.dart';

import '../../config/routing.dart';
import '../../config/utils.dart';
import '../../models/chat.dart';
import '../utils/square_image.dart';

class ChatTile extends StatelessWidget {
  const ChatTile(
      {Key? key,
      required this.receiver,
      required this.chat,
      required this.resetCount,
      required this.searchedTerm})
      : super(key: key);

  final UserModel receiver;
  final Chat chat;
  final String searchedTerm;
  final Future<void> Function() resetCount;
  @override
  Widget build(BuildContext context) {
    return CustomOutlinedButton(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 10),
      onPressed: () {
        discussionNavigation(receiver);
        resetCount();
      },
      child: ListTile(
          leading: SquareImage(photoLink: receiver.pictureURL),
          title: SubstringHighlight(
            text: receiver.username,
            term: searchedTerm,
            overflow: TextOverflow.ellipsis,
            textStyle: context.textTheme.labelSmall!,
          ),
          subtitle: SubstringHighlight(
            text: chat.lastMessage,
            term: searchedTerm,
            overflow: TextOverflow.ellipsis,
            textStyle: context.textTheme.bodySmall!.copyWith(fontSize: 12),
          ),
          trailing: chat.count == 0
              ? Text(formatDateTime(chat.lastSent),
                  style: context.textTheme.headlineSmall?.copyWith(fontSize: 10))
              : CircleAvatar(
                  radius: 12,
                  backgroundColor: MyThemes.primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Text(chat.count < 100 ? "${chat.count}" : "+99",
                        style: context.textTheme.headlineSmall
                            ?.copyWith(fontSize: chat.count < 100 ? 12 : 8)),
                  ))),
    );
  }
}

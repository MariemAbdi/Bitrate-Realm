import 'package:bitrate_realm/config/responsiveness.dart';
import 'package:bitrate_realm/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/utils.dart';
import '../../models/message.dart';
import '../../models/user.dart';
import '../../widgets/utils/square_image.dart';

class MessageBubble extends StatefulWidget {
  final Message message;
  final UserModel receiver;
  final bool isMe;

  const MessageBubble({super.key, required this.message, required this.isMe, required this.receiver});

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        widget.message.messageType.compareTo("text") == 0
        // Text message bubble
            ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            // Add the profile image on the left
            if (!widget.isMe) // Assuming the other person has the image
              Container(
                  width: 35,
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  child: SquareImage(
                      photoLink: widget.receiver.pictureURL,
                      radius: 10
                  )
              ),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
              constraints: const BoxConstraints(maxWidth: 300),
              decoration: BoxDecoration(
                color: widget.isMe ? Colors.grey[900] : context.theme.primaryColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.isMe ? "You" : widget.receiver.username,
                    style: context.textTheme.bodySmall
                  ),

                  Text(
                    widget.message.message,
                    style: context.textTheme.labelSmall
                  ),
                  kSmallVerticalSpace,

                  Text(
                    formatDateTime(widget.message.date),
                    style: context.textTheme.bodySmall?.copyWith(fontSize: 10)
                  ),
                ],
              ),
            ),

            if (widget.isMe) // Assuming the other person has the image
              Container(
                  width: 35,
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  child: SquareImage(
                      photoLink: widget.receiver.pictureURL,
                      radius: 10
                  )
              ),

          ],
        )
        // Image message bubble
            : Row(
          mainAxisAlignment: widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!widget.isMe) // Assuming the other person has the image
              Container(
                  width: 30,
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  child: SquareImage(photoLink: widget.receiver.pictureURL)
              ),// Add space between image and message

            Container(
              margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
              height: Responsiveness.deviceHeight(context) / 2.5,
              width: Responsiveness.deviceWidth(context) / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey),
              ),
              child: widget.message.message.isNotEmpty
                  ? Image.network(
                widget.message.message,
                fit: BoxFit.contain,
              )
                  : const Center(child: CircularProgressIndicator()),
            ),

            if (widget.isMe) // Assuming the other person has the image
              Container(
                  width: 30,
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  child: SquareImage(photoLink: widget.receiver.pictureURL)
              ),
          ],
        ),
      ],
    )
    ;
  }
}
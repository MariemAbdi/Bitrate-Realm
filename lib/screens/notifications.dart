import 'package:bitrate_realm/models/notification.dart';
import 'package:bitrate_realm/widgets/utils/custom_app_bar.dart';
import 'package:bitrate_realm/widgets/utils/custom_list.dart';
import 'package:bitrate_realm/widgets/utils/custom_outlined_button.dart';
import 'package:bitrate_realm/widgets/utils/square_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:get/get.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<NotificationModel> notifications = [
      NotificationModel(id: "123", title: "title1", description: lorem(paragraphs: 2, words: 50), topic: "topic"),
      NotificationModel(id: "124", title: "title2", description: lorem(paragraphs: 3, words: 70), topic: "topic"),
      NotificationModel(id: "125", title: "title3", description: lorem(paragraphs: 1, words: 20), topic: "topic"),
    ];
    return Scaffold(
      appBar: const CustomAppBar(title: "Notifications"),
      body: CustomListView(
          itemCount: notifications.length,
          padding: const EdgeInsets.all(20),
          itemBuilder: (context, index){
            NotificationModel notification = notifications[index];
            return CustomOutlinedButton(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const SquareImage(photoLink: null),
                title: Text(notification.title, style: context.textTheme.bodyMedium),
                subtitle: Text(notification.description, style: context.textTheme.bodySmall),
                trailing: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.delete, color: Colors.white),
                ),
              ),
            );
          }),
    );
  }
}

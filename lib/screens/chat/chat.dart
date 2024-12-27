import 'package:bitrate_realm/constants/spacing.dart';
import 'package:bitrate_realm/models/chat.dart';
import 'package:bitrate_realm/services/chat_services.dart';
import 'package:bitrate_realm/services/firebase_auth_services.dart';
import 'package:bitrate_realm/services/user_services.dart';
import 'package:bitrate_realm/translations/locale_keys.g.dart';
import 'package:bitrate_realm/widgets/chat/chat_tile.dart';
import 'package:bitrate_realm/widgets/home/users_list.dart';
import 'package:bitrate_realm/widgets/input/send_input.dart';
import 'package:bitrate_realm/widgets/utils/custom_app_bar.dart';
import 'package:bitrate_realm/widgets/utils/custom_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../widgets/utils/custom_async_builder.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController _searchController;
  String _searchText="";

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  void _makeSearch(String searchText) {
    setState(() {
      _searchText = searchText;
    });
  }
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuthServices().user;
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: CustomAppBar(title: LocaleKeys.chat.tr(), canGoBack: false),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SendInput(controller: _searchController, onConfirm: _makeSearch),
            kSmallVerticalSpace,

            Visibility(
              visible: _searchText.isEmpty,
              child: const UsersList(goToProfile: false),
            ),

            CustomAsyncBuilder(
                stream: ChatServices().fetchAllMessages(currentUser!.email!),
                builder: (context, chatValue){
                  List<Chat> fullChat = chatValue ?? [];

                  return CustomListView(
                      itemCount: fullChat.length,
                      itemBuilder: (context, index){
                        Chat chat = fullChat[index];
                        return CustomAsyncBuilder(
                            future: UserServices().getUserData(chat.id!),
                            builder: (context, userValue) {
                              UserModel? user = userValue;
                              //search
                              if(user!=null){
                                bool matches = user.username.toLowerCase().contains(_searchText.toLowerCase()) || chat.lastMessage.toLowerCase().contains(_searchText.toLowerCase());
                                if(matches){
                                  return ChatTile(
                                      receiver: userValue!,
                                      chat: chat,
                                      searchedTerm: _searchText,
                                      resetCount: ()=>ChatServices().resetChatCount(currentUser.email!,chat.id!)
                                  );
                                }
                              }
                              return Container();
                            }

                        );
                      }
                  );
                }
            )
          ],
        ),
      ),
    );
  }
}

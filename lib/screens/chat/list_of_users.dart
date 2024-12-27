import 'package:flutter/material.dart';

import '../../widgets/utils/nothing_to_show.dart';
import '../../constants/spacing.dart';
import '../../models/user.dart';
import '../../services/user_services.dart';
import '../../widgets/input/send_input.dart';
import '../../widgets/utils/custom_app_bar.dart';
import '../../widgets/utils/custom_async_builder.dart';
import '../../widgets/utils/custom_list.dart';
import '../../widgets/utils/custom_outlined_button.dart';
import '../../widgets/utils/user_info_tile.dart';

class ListOfUsers extends StatefulWidget {
  const ListOfUsers({Key? key, this.goToProfile = true}) : super(key: key);

  final bool goToProfile;
  @override
  State<ListOfUsers> createState() => _ListOfUsersState();
}

class _ListOfUsersState extends State<ListOfUsers> {
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
    return Scaffold(
      appBar: const CustomAppBar(title: "Users"),
      body: Column(
        children: [
          SendInput(controller: _searchController, onConfirm: _makeSearch),
          kSmallVerticalSpace,

          CustomAsyncBuilder(
              future: UserServices().getUsersList(),
              builder: (context, users){
                List<UserModel> usersList = users ?? [];
                if(usersList.isEmpty){
                  return const NothingToShow();
                }
                return CustomListView(
                    itemCount: usersList.length,
                    itemBuilder: (context, index){
                      UserModel user = usersList[index];
                      bool matches = user.username.toLowerCase().contains(_searchText.toLowerCase());
                      if(matches){
                        return CustomOutlinedButton(
                            padding: const EdgeInsets.all(18),
                            margin: const EdgeInsets.only(bottom: 10),
                            child: UserInfoTile(
                              user: user,
                              searchedTerm: _searchText,
                              goToProfile: widget.goToProfile,
                            )
                        );
                      }

                      return Container();
                    }
                );
              }),
        ],
      ),
    );
  }
}

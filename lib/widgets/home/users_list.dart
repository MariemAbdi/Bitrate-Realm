import 'package:flutter/material.dart';

import '../../config/app_style.dart';
import '../custom_outlined_button.dart';
import '../utils/custom_list.dart';

class UsersList extends StatefulWidget {
  const UsersList({Key? key}) : super(key: key);

  @override
  UsersListState createState() => UsersListState();
}

class UsersListState extends State<UsersList> {
  @override
  Widget build(BuildContext context) {
    return CustomListView(
        height: 120,
        itemCount: 15,
        itemBuilder: (context, index){
          return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Column(
                children: [
                  Expanded(
                    child: CustomOutlinedButton(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.network(
                              "https://cdn.pixabay.com/photo/2022/11/10/07/15/portrait-7582123_640.jpg",
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover, // Ensures the image covers the area without exceeding
                            ),
                          ),
                        )
                    ),
                  ),

                  Container(
                    width: 90,
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: MyThemes.primaryColor.withOpacity(0.75),
                    ),
                    child: const Text("Mariem Abdi", style: TextStyle(color: Colors.white, overflow: TextOverflow.ellipsis, fontSize: 12), textAlign: TextAlign.center,),
                  )
                ],
              )
          );
        }
    );
  }
}

import 'package:flutter/material.dart';
import 'package:livestream/config/routing.dart';
import 'package:livestream/widgets/custom_outlined_button.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget{
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  HomeAppBarState createState() => HomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class HomeAppBarState extends State<HomeAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: InkWell(
        onTap: profileNavigation,
        child: Container(
          padding: const EdgeInsets.fromLTRB(8,8,0,8),
          margin: const EdgeInsets.only(left: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                  "https://cdn.pixabay.com/photo/2022/11/10/07/15/portrait-7582123_640.jpg",
                height: 40,
                width: 40,
                fit: BoxFit.cover, // Ensures the image covers the area without exceeding
              ),
            )
          ),
        ),
      ),
      title: const Expanded(
        child: Text(
          'Mariem Abdi',
        ),
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: CustomOutlinedButton(
              child: Icon(Icons.search)
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: CustomOutlinedButton(
              child: Icon(Icons.notifications)
          ),
        ),
      ],
    );
  }
}

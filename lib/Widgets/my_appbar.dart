import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class MyAppBar extends StatefulWidget implements PreferredSizeWidget{
  final String title;
  final Widget action;
  final bool implyLeading;
  const MyAppBar({Key? key,required this.implyLeading, required this.title, required this.action}) : super(key: key);

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(50);
}

class _MyAppBarState extends State<MyAppBar> {
  //AnimateIconController controller = AnimateIconController();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: widget.implyLeading,
      title: Text(widget.title, overflow: TextOverflow.ellipsis,),
      actions: [
        widget.action
      ],
      /*actions: [
        //CHANGE THE APP'S THEME ICON
        AnimateIcons(
          startIcon: EvaIcons.moon,
          endIcon: EvaIcons.sun,
          size: 30.0,
          controller: controller,
          // add this tooltip for the start icon
          startTooltip: 'Icons.add_circle',
          // add this tooltip for the end icon
          endTooltip: 'Icons.add_circle_outline',
          onStartIconPress: () {
            ThemeService().switchTheme();
            return true;
          },
          onEndIconPress: () {
            ThemeService().switchTheme();
            return true;
          },
          duration: const Duration(milliseconds: 1000),
          startIconColor: Colors.white,
          endIconColor: Colors.yellow,
          clockwise: true,
        ),
      ],*/
    );
  }
}

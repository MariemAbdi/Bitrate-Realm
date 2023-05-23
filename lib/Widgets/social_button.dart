import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  SocialButton({Key? key, required this.icon, required this.title, required this.color, required this.onTap}) : super(key: key);

  IconData icon;
  Color color;
  String title;
  Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: Colors.white, size: 16,),
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400),overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}

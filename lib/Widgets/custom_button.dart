import 'package:flutter/material.dart';

import '../Services/Themes/my_themes.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback function;
  const CustomButton({Key? key, required this.text, required this.function}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: MyThemes.darkBlue,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4)),
        ),
        onPressed: function,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

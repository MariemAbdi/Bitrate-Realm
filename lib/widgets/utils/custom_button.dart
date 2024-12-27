import 'package:flutter/material.dart';
import '../../config/app_style.dart';
import '../../constants/spacing.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final VoidCallback? onPressed;
  final bool isUppercase;
  final IconData? iconData;
  const CustomButton({Key? key, required this.text, this.backgroundColor = MyThemes.primaryColor, required this.onPressed, this.isUppercase = false, this.iconData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
            return backgroundColor; // By default
          }),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if(iconData!=null)
              ...[
                Icon(iconData, size: 16),
                kHorizontalSpace,
              ],
            Text(
              isUppercase ? text.toUpperCase() : text,
            ),
          ],
        )
      ),
    );
  }
}

import 'package:bitrate_realm/config/utils.dart';
import 'package:bitrate_realm/constants/spacing.dart';
import 'package:bitrate_realm/widgets/utils/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/custom_outlined_button.dart';
import '../utils/square_image.dart';

class EditProfileImage extends StatelessWidget {
  const EditProfileImage({Key? key, required this.profileImageLink, required this.updateImage,required this.removeImage}) : super(key: key);

  final String? profileImageLink;
  final void Function()? updateImage, removeImage;

  @override
  Widget build(BuildContext context) {
    showOptions(){
      customBottomSheet(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
                text: "Pick Photo",
                onPressed: updateImage
            ),
            kSmallVerticalSpace,
            CustomButton(
                text: "Delete Photo",
                backgroundColor: Colors.redAccent,
                onPressed: profileImageLink != null ? removeImage : ()=>Get.back()
            ),
          ],
        )
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Center(
          child: SizedBox(
              height: 100,
              child: CustomOutlinedButton(
                aspectRatio: 1,
                child: SquareImage(
                    padding: const EdgeInsets.all(8),
                    photoLink: profileImageLink
                ),
              )
          ),
        ),

        Center(
          child: InkWell(
            onTap: showOptions,
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: const Center(
                child: Icon(Icons.add_photo_alternate, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

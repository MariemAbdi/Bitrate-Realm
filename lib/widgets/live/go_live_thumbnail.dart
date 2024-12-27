import 'dart:typed_data';

import 'package:bitrate_realm/config/responsiveness.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

import '../../constants/spacing.dart';
import '../../translations/locale_keys.g.dart';

class GoLiveThumbnail extends StatelessWidget {
  const GoLiveThumbnail({Key? key, this.selectThumbnail, this.pickedThumbnail})
      : super(key: key);

  final void Function()? selectThumbnail;
  final Uint8List? pickedThumbnail;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: selectThumbnail,
      child: pickedThumbnail != null
          ? Container(
              height: Responsiveness.deviceWidth(context) / 2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: MemoryImage(pickedThumbnail!), fit: BoxFit.cover)
              ),
            )
          : DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(10),
              dashPattern: const [10, 4],
              strokeCap: StrokeCap.round,
              child: Container(
                height: Responsiveness.deviceWidth(context) / 2,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.folder_open,
                        color: Colors.white70,
                        size: 40,
                      ),
                      kSmallVerticalSpace,
                      Text(LocaleKeys.selectThumbnail.tr(),
                          style: context.textTheme.titleSmall?.copyWith(color: Colors.white70)
                      ),
                    ],
                  ),
                ),
              )),
    );
  }
}

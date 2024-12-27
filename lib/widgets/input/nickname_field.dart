import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bitrate_realm/config/validators.dart';
import 'package:get/get.dart' hide Trans;

import '../../translations/locale_keys.g.dart';
class NicknameField extends StatefulWidget {

  final TextEditingController nicknameController;
  const NicknameField({Key? key, required this.nicknameController}) : super(key: key);

  @override
  State<NicknameField> createState() => _NicknameFieldState();
}

class _NicknameFieldState extends State<NicknameField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: Validators().nicknameValidation,
      controller: widget.nicknameController,
      keyboardType: TextInputType.name,
      autofillHints: const[
        AutofillHints.name,
        AutofillHints.nickname
      ],
      style: context.textTheme.headlineSmall,
      decoration: InputDecoration(
          labelText: LocaleKeys.nickname.tr(),
          hintText: LocaleKeys.enteryournickname.tr(),
          prefixIcon: const Icon(CupertinoIcons.person_alt),
          suffixIcon: widget.nicknameController.text.isEmpty
              ? null
              : IconButton(
            icon: const Icon(Icons.close, size: 14),
            onPressed: () {
              setState(() {
                widget.nicknameController.clear();
              });
            },
          )),
      onChanged: (value) {
        setState(() {});
      },
    );
  }
}

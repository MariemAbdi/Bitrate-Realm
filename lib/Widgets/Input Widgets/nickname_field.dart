import 'package:easy_localization/easy_localization.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      validator: (nickname) {
        if (nickname!.isEmpty) {
          return LocaleKeys.nicknamecantbeempty.tr();
        }
        return null;
      },
      controller: widget.nicknameController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
          labelText: LocaleKeys.nickname.tr(),
          hintText: LocaleKeys.enteryournickname.tr(),
          prefixIcon: const Icon(CupertinoIcons.person_alt),
          border: const OutlineInputBorder(),
          suffixIcon: widget.nicknameController.text.isEmpty
              ? null
              : IconButton(
            icon: const Icon(EvaIcons.close),
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

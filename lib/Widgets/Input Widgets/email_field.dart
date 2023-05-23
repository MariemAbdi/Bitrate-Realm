import 'package:easy_localization/easy_localization.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../translations/locale_keys.g.dart';


class EmailField extends StatefulWidget {
  final TextEditingController emailController;
  const EmailField({Key? key, required this.emailController}) : super(key: key);

  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (email) {
        if (email!.isEmpty) {
          return LocaleKeys.emailfieldcantbeempty.tr();
        } else if (!RegExp(r'^[a-zA-Z\d.]+@[a-zA-Z\d]+\.[a-zA-Z]+')
            .hasMatch(email)) {
          return LocaleKeys.pleaseenteravalidemail.tr();
        }
        return null;
      },
      controller: widget.emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          labelText: LocaleKeys.email.tr(),
          hintText: LocaleKeys.enteryouremail.tr(),
          prefixIcon: const Icon(CupertinoIcons.mail_solid),
          border: const OutlineInputBorder(),
          suffixIcon: widget.emailController.text.isEmpty
              ? null
              : IconButton(
            icon: const Icon(EvaIcons.close),
            onPressed: () {
              setState(() {
                widget.emailController.clear();
              });
            },
          )),
      onChanged: (value) {
        setState(() {});
      },
    );
  }
}

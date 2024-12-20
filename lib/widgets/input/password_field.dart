import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:bitrate_realm/config/validators.dart';
import 'package:get/get.dart' hide Trans;

import '../../translations/locale_keys.g.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController passwordController;
  const PasswordField({Key? key, required this.passwordController, this.canBeEmpty = false, this.title}) : super(key: key);

  final bool canBeEmpty;
  final String? title;
  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.canBeEmpty ? null : Validators().passwordValidation,
      keyboardType: TextInputType.text,
      controller: widget.passwordController,
      obscureText: !_isPasswordVisible,
      obscuringCharacter: "*",
      autofillHints: const[
        AutofillHints.password
      ],
      style: context.textTheme.headlineSmall,
      decoration: InputDecoration(
          labelText: widget.title ?? LocaleKeys.password.tr(),
          hintText: widget.title ?? LocaleKeys.enteryourpassword.tr(),
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: Icon(_isPasswordVisible
                ? Icons.visibility_off
                : Icons.visibility),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          )),
      onChanged: (value) {
        setState(() {});
      },
    );
  }
}

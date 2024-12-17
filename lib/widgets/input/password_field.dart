import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bitrate_realm/config/validators.dart';

import '../../translations/locale_keys.g.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController passwordController;
  final bool requireValidation;
  const PasswordField({Key? key, required this.passwordController, required this.requireValidation}) : super(key: key);

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (password) => Validators().passwordValidation(password, widget.requireValidation),
      keyboardType: TextInputType.text,
      controller: widget.passwordController,
      obscureText: !_isPasswordVisible,
      obscuringCharacter: "*",
      autofillHints: const[
        AutofillHints.password
      ],
      decoration: InputDecoration(
          labelText: LocaleKeys.password.tr(),
          hintText: LocaleKeys.enteryourpassword.tr(),
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

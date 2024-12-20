import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:provider/provider.dart';

import '../../constants/spacing.dart';
import '../../services/firebase_auth_services.dart';
import '../../config/assets_paths.dart';
import '../../translations/locale_keys.g.dart';
import '../utils/custom_button.dart';
import '../input/email_field.dart';

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({Key? key}) : super(key: key);

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _emailController;


  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }


  void resetPassword() async{
    if (_formKey.currentState?.validate() ?? false) {
    context.read<FirebaseAuthServices>().resetPassword(_emailController.text.trim()).whenComplete(() => _emailController.clear());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //LOGO
          SizedBox(
              height: 200,
              width: 200,
              child: Image.asset(AssetsPaths.logoImage)),

          //WELCOME BACK | JOIN US TEXT
          FittedBox(
            child: Text(
                LocaleKeys.resetPassword.tr().toUpperCase(),
                style: context.textTheme.headlineMedium
            ),
          ),

          kVerticalSpace,

          EmailField(emailController: _emailController),
          kVerticalSpace,

          //VALIDATION BUTTON
          CustomButton(
            text: LocaleKeys.done.tr(),
            onPressed: resetPassword,
            isUppercase: true,
          ),

        ],
      ),
    );
  }
}

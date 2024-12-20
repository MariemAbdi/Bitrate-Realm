import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:bitrate_realm/models/user.dart';
import 'package:provider/provider.dart';

import '../../constants/spacing.dart';
import '../../services/firebase_auth_services.dart';
import '../../config/assets_paths.dart';
import '../../translations/locale_keys.g.dart';
import '../utils/custom_button.dart';
import '../input/email_field.dart';
import '../input/nickname_field.dart';
import '../input/password_field.dart';
import 'google_sign_in.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _nicknameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;


  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }


  @override
  void dispose() {
    //CONTROLLERS NEED TO BE DISPOSED OF
    _nicknameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  signup()async{
    if (_formKey.currentState?.validate() ?? false) {
      UserModel userModel = UserModel(
        email: _emailController.text.trim(),
        username: _nicknameController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await context.read<FirebaseAuthServices>().signUpWithEmailAndPassword(userModel: userModel);
      clearFields();
    }
  }

  clearFields(){
    _nicknameController.clear();
    _emailController.clear();
    _passwordController.clear();
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
                LocaleKeys.joinus.tr(),
                style: context.textTheme.headlineMedium
            ),
          ),

          kVerticalSpace,

          NicknameField(nicknameController: _nicknameController),
          kVerticalSpace,


          EmailField(emailController: _emailController),
          kVerticalSpace,

          PasswordField(passwordController: _passwordController),
          kVerticalSpace,

          //VALIDATION BUTTON
          CustomButton(
            text: LocaleKeys.signup.tr(),
            onPressed: signup,
            isUppercase: true,
          ),

          //-------------------------------GOOGLE AUTHENTICATION--------------------------------------------
          const GoogleSignIn(),
        ],
      ),
    );
  }
}

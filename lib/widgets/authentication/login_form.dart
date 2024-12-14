import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:livestream/models/user.dart';
import 'package:provider/provider.dart';

import '../../constants/spacing.dart';
import '../../services/firebase_auth_services.dart';
import '../../config/assets_paths.dart';
import '../../config/routing.dart';
import '../../translations/locale_keys.g.dart';
import '../utils/custom_button.dart';
import '../input/email_field.dart';
import '../input/password_field.dart';
import 'google_sign_in.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _emailController;
  late TextEditingController _passwordController;


  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }


  @override
  void dispose() {
    //CONTROLLERS NEED TO BE DISPOSED OF
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void signIn() async{
    if (_formKey.currentState?.validate() ?? false) {
      UserModel userModel = UserModel(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      context.read<FirebaseAuthServices>().signInWithEmailAndPassword(userModel: userModel);
    }
  }

  clearFields(){
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
                LocaleKeys.welcomeBack.tr().toUpperCase(),
                style: context.textTheme.headlineMedium
            ),
          ),

          kVerticalSpace,

          EmailField(emailController: _emailController),
          kVerticalSpace,

          PasswordField(passwordController: _passwordController, requireValidation: true),

          //----------------------------------FORGOT PASSWORD-------------------------------------------------
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //FORGOT PASSWORD
                TextButton(
                  onPressed: forgotPasswordNavigation,
                  child: Text(LocaleKeys.forgotPassword.tr(),
                      style: context.textTheme.displaySmall
                  ),

                )
              ],
          ),

          kVerticalSpace,

          //VALIDATION BUTTON
          CustomButton(
              text: LocaleKeys.signin.tr(),
              onPressed: signIn
          ),

          //-------------------------------GOOGLE AUTHENTICATION--------------------------------------------
          const GoogleSignIn(),
        ],
      ),
    );
  }
}

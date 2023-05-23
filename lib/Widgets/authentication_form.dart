import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../Models/user_model.dart';
import '../../Resources/firebase_auth_methods.dart';
import '../../translations/locale_keys.g.dart';
import '../Screens/Authentication/forgot_password_screen.dart';
import '../Services/Themes/my_themes.dart';
import 'Input Widgets/email_field.dart';
import 'Input Widgets/nickname_field.dart';
import 'Input Widgets/password_field.dart';
import 'custom_button.dart';
import 'social_button.dart';

class AuthenticationForm extends StatefulWidget {
  final bool isLogin;
  const AuthenticationForm({Key? key, required this.isLogin}) : super(key: key);

  @override
  State<AuthenticationForm> createState() => _AuthenticationFormState();
}

class _AuthenticationFormState extends State<AuthenticationForm> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  GetStorage getStorage = GetStorage();

  //CONTROLLERS NEED TO BE DISPOSED OF
  @override
  void dispose() {
    _nicknameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  //SIGN IN VIA EMAIL & PASSWORD
  void signIn() async{
    context.read<FirebaseAuthMethods>().signInWithEmailAndPassword(email: _emailController.text.trim(), password: _passwordController.text.trim(), context: context);
  }

  //SIGN UP VIA EMAIL & PASSWORD
  void signUp() async{
    context.read<FirebaseAuthMethods>().signUpWithEmailAndPassword(nickname: _nicknameController.text.trim(), email: _emailController.text.trim(), password: _passwordController.text.trim(), context: context)
        .whenComplete(() {
      //Create A New User & Add It To The Firestore Database
      User user= User(email: _emailController.text.trim(), nickname: _nicknameController.text.trim());
      createUser(user);

      //Clear The Fields Once The Account Is created
      _nicknameController.clear();
      _emailController.clear();
      _passwordController.clear();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            //LOGO
            SizedBox(
              height: 100,
              width: 100,
              child: Image.asset(
                "assets/images/logo.png",
              ),),

            //WELCOME BACK | JOIN US TEXT
            FittedBox(
              child: Text(
                widget.isLogin?LocaleKeys.welcomeBack.tr():LocaleKeys.joinus.tr(),
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: MyThemes.darkerRed,
                      height: 1.2,
                    )),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            //NICKNAME FIELD
            Visibility(
                visible:!widget.isLogin,
                child: NicknameField(nicknameController: _nicknameController,)),

            Visibility(
                visible: !widget.isLogin,
                child: const SizedBox(height: 16),
            ),

            //EMAIL FIELD
            EmailField(emailController: _emailController),
            const SizedBox(height: 16,),

            //PASSWORD FIELD
            PasswordField(passwordController: _passwordController, requireValidation: true,),
            const SizedBox(height: 16),

            //----------------------------------FORGOT PASSWORD-------------------------------------------------
            Visibility(
                visible: widget.isLogin,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    //FORGOT PASSWORD
                    TextButton(onPressed: () {
                      Navigator.pushNamed(context, ForgotPasswordScreen.routeName);
                    },
                      child: Text(LocaleKeys.forgotPassword.tr(),
                        style: GoogleFonts.ptSans(
                          textStyle: const TextStyle(
                              color: MyThemes.darkBlue,
                              decoration: TextDecoration.underline),
                        ),),

                    )
                  ],
                )),


            Visibility(
              visible: widget.isLogin,
              child: const SizedBox(height: 16),),

            //VALIDATION BUTTON
            CustomButton(text: widget.isLogin?LocaleKeys.signin.tr():LocaleKeys.signup.tr(), function: (){
              if (_formKey.currentState?.validate() ?? false) {
                widget.isLogin?signIn():signUp();
              }
            }),

            //-------------------------------GOOGLE AUTHENTICATION--------------------------------------------
            const SizedBox(
              height: 20,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Expanded(
                  child: Divider(
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  LocaleKeys.or.tr(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Divider(
                    color: Colors.black,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10,),

            //GOOGLE AUTHENTICATION BUTTON
            SocialButton(icon: FontAwesomeIcons.googlePlusG, title: LocaleKeys.loginwithgoogle.tr(), color: MyThemes().googleColor,
                onTap: () {
                  context.read<FirebaseAuthMethods>().signInWithGoogle(context);
                })

          ],
        ),
      ),
    );
  }
}

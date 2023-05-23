import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:livestream/Responsive/responsive_layout.dart';
import 'package:livestream/Widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

import '../../Resources/firebase_auth_methods.dart';
import '../../Services/Themes/my_themes.dart';
import '../../Widgets/Input Widgets/email_field.dart';
import '../../translations/locale_keys.g.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static String routeName = '/resetPassword';

  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  void resetPassword() async{
    context.read<FirebaseAuthMethods>().resetPassword(context, _emailController.text.trim()).whenComplete(() => _emailController.clear());
  }
  @override
  Widget build(BuildContext context) {
    return Theme(data: MyThemes.lightTheme,
        child: Scaffold(
          body: ResponsiveLayout(
              mobileBody: _mobileBody(),
              desktopBody: _desktopBody()),
        ));
  }

  Widget _form(){
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

            //WELCOME BACK TEXT
            Text(
              LocaleKeys.resetPassword.tr(),
              style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: MyThemes.darkerRed,
                    height: 1.2,
                  )),
            ),

            const SizedBox(
              height: 15,
            ),

            //EMAIL FIELD
            EmailField(emailController: _emailController),

            const SizedBox(height: 20,),

            //BUTTON
            CustomButton(text: LocaleKeys.done.tr(), function: () {
              if (_formKey.currentState?.validate() ?? false) {
                resetPassword();
              }
            }),
            const SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }

  Widget _mobileBody(){
    double width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Positioned(
          width: width * 1.7,
          left: 100,
          bottom: 100,
          child: Image.asset("assets/images/Spline.png",),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: const SizedBox(),
          ),
        ),
        const RiveAnimation.asset("assets/rive/shapes.riv",),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: const SizedBox(),
          ),
        ),
        Positioned(
          top:  0,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                          padding: const EdgeInsets.only(top: 50, right: 20, left: 20, bottom: 50),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.8),
                                spreadRadius: 3,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _form()
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _desktopBody(){
    return Row(
      children: [
        //THE ANIMATED PART
        Expanded(
            child: Stack(
              children: [
                Positioned(
                  //width: width * 1.7,
                  left: 100,
                  bottom: 100,
                  child: Image.asset(
                    "assets/images/Spline.png",
                  ),
                ),
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: const SizedBox(),
                  ),
                ),
                const RiveAnimation.asset(
                  "assets/rive/shapes.riv",
                  fit: BoxFit.cover,
                ),
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                    child: const SizedBox(),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 50,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(),

                          SizedBox(
                            width: 350,
                            child: Text(
                              LocaleKeys.signinnow.tr(),
                              style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    fontSize: 60,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                    height: 1.2,
                                  )),
                            ),
                          ),

                          const SizedBox(
                            height: 16,
                          ),

                          //SIGN IN BUTTON
                          Material(
                            color: MyThemes.darkerRed,
                            borderRadius: BorderRadius.circular(50),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, LoginScreen.routeName);
                              },
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                width: 200,
                                height: 50,
                                alignment: Alignment.center,
                                child: Text(LocaleKeys.signinnow.tr(),style: GoogleFonts.ptSans(
                                    textStyle: const TextStyle(
                                        color: Colors.white, fontSize: 20)),
                                ),
                              ),
                            ),
                          ),

                          const Spacer(flex: 2,),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),

        //THE FORM PART
        Expanded(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 21),
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _form(),
                    ],

                  ),
                ),
              ),
            )),
      ],
    );
  }
}

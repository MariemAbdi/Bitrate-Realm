import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:livestream/Screens/Authentication/registration_screen.dart';
import 'package:rive/rive.dart';

import '../../Services/Themes/my_themes.dart';
import '../../Widgets/authentication_form.dart';
import '../../translations/locale_keys.g.dart';
import 'login_screen.dart';

class AuthenticationDesktop extends StatefulWidget {
  final bool isLogin;
  const AuthenticationDesktop({Key? key, required this.isLogin}) : super(key: key);

  @override
  State<AuthenticationDesktop> createState() => _AuthenticationDesktopState();
}

class _AuthenticationDesktopState extends State<AuthenticationDesktop> {
  @override
  Widget build(BuildContext context) {
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
                              widget.isLogin?LocaleKeys.joinourrealm.tr():LocaleKeys.alredayamember.tr(),
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

                          //REGISTRATION | LOGIN BUTTON
                          Material(
                            color: MyThemes.darkerRed,
                            borderRadius: BorderRadius.circular(50),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, widget.isLogin? RegistrationScreen.routeName : LoginScreen.routeName);
                              },
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                width: 200,
                                height: 50,
                                alignment: Alignment.center,
                                child: Text(widget.isLogin?LocaleKeys.signupnow.tr():LocaleKeys.signinnow.tr(),style: GoogleFonts.ptSans(
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
                      AuthenticationForm(isLogin: widget.isLogin)
                    ],

                  ),
                ),
              ),
            )),
      ],
    );
  }
}

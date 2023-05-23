import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:livestream/Screens/Authentication/registration_screen.dart';
import 'package:livestream/Widgets/authentication_form.dart';
import 'package:rive/rive.dart';

import '../../Services/Themes/my_themes.dart';
import '../../translations/locale_keys.g.dart';
import 'login_screen.dart';

class AuthenticationMobile extends StatefulWidget {
  final bool isLogin;
  const AuthenticationMobile({Key? key, required this.isLogin}) : super(key: key);

  @override
  State<AuthenticationMobile> createState() => _AuthenticationMobileState();
}

class _AuthenticationMobileState extends State<AuthenticationMobile> {
  @override
  Widget build(BuildContext context) {
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
                        padding: const EdgeInsets.all(20),
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
                            AuthenticationForm(isLogin: widget.isLogin,),
                            const SizedBox(height: 20,),


                            //JOIN US LINK
                            FittedBox(
                              child: TextButton(
                                onPressed: (){
                                  Navigator.pushNamed(context, widget.isLogin? RegistrationScreen.routeName : LoginScreen.routeName);
                                },
                                child: Text(
                                  widget.isLogin?LocaleKeys.notamemberyet.tr():LocaleKeys.alreadyamembersigninnow.tr(),
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: MyThemes.darkBlue,
                                        decoration: TextDecoration.underline
                                    ),),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
}

import 'dart:async';
import 'package:bitrate_realm/providers/navigation_provider.dart';
import 'package:bitrate_realm/providers/user_provider.dart';
import 'package:bitrate_realm/screens/authentication/login.dart';
import 'package:bitrate_realm/screens/on_boarding.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:bitrate_realm/screens/navigation.dart';
import 'package:bitrate_realm/translations/codegen_loader.g.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'config/app_style.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  //USED FOR THE BINDING TO BE INITIALIZED BEFORE CALLING runApp.
  WidgetsFlutterBinding.ensureInitialized();

  //SET THE ORIENTATION TO BE PORTRAIT ONLY
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  //MAKE THE APP FULL SCREEN => HIDES THE STATUS AND NAVIGATION BAR OF THE PHONE
  SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky, overlays: []);

  //TO LOAD THE .env FILE CONTENTS INTO DOTENV
  await dotenv.load(fileName: ".env");

  //INITIALIZE GET STORAGE
  await GetStorage.init();

  //INITIALIZE FIREBASE
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //INITIALIZING THE INTERNATIONALIZATION PACKAGE
  await EasyLocalization.ensureInitialized();

  // Add localization for supported languages
  timeago.setLocaleMessages('en', timeago.EnMessages());
  timeago.setLocaleMessages('fr', timeago.FrMessages());
  timeago.setLocaleMessages('ar', timeago.ArMessages());
  // Add other languages as needed

  //RUNNING THE APP WITH INTERNATIONALIZATION SETTINGS
  runApp(EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en'), Locale('fr')],
      path: 'assets/translations',
      assetLoader: const CodegenLoader(),
      child: const MyApp()
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //THE ROOT OF THE APP
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: GetMaterialApp(
        //INTERNATIONALIZATION SETTINGS
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        //THEME CUSTOMIZATION
        theme: MyThemes.customTheme,
        home: const AuthPage(),
      ),
    );
  }
}

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final userProvider = Provider.of<UserProvider>(context, listen: false);

          // Check for onboarding screen display
          if (GetStorage().read("onBoarding") == null && !kIsWeb) {
            return const OnBoardingScreen();
          }

          // If user is logged in
          if (snapshot.hasData) {
            final userId = snapshot.data!.email!;

            // Ensure listenToUserChanges is called after widget tree build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // Call listenToUserChanges once the widget is built
              userProvider.listenToUserChanges(userId);
            });

            return const NavigationScreen();
          }

          // If user is not logged in
          return const LoginScreen();
        });
  }
}


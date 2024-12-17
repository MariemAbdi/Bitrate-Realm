import 'dart:async';
import 'package:bitrate_realm/providers/auth_provider.dart';
import 'package:bitrate_realm/providers/user_provider.dart';
import 'package:bitrate_realm/screens/profile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:bitrate_realm/Services/firebase_auth_services.dart';
import 'package:bitrate_realm/screens/login.dart';
import 'package:bitrate_realm/screens/navigation.dart';
import 'package:bitrate_realm/translations/codegen_loader.g.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import 'services/theme_services.dart';
import 'config/app_style.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  //USED FOR THE BINDING TO BE INITIALIZED BEFORE CALLING runApp.
  WidgetsFlutterBinding.ensureInitialized();

  //SET THE ORIENTATION TO BE PORTRAIT ONLY
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  //MAKE THE APP FULL SCREEN => HIDES THE STATUS AND NAVIGATION BAR OF THE PHONE
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);

  //TO LOAD THE .env FILE CONTENTS INTO DOTENV
  await dotenv.load(fileName: ".env");

  //INITIALIZE GET STORAGE
  await GetStorage.init();

  //INITIALIZE FIREBASE
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //INITIALIZING THE INTERNATIONALIZATION PACKAGE
  await EasyLocalization.ensureInitialized();

  //RUNNING THE APP WITH INTERNATIONALIZATION SETTINGS
  runApp(EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en'),Locale('fr')],
      path: 'assets/translations',
      assetLoader: const CodegenLoader(),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
        child: const MyApp())
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //THE ROOT OF THE APP
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Ensure callbacks are set before AuthProvider logic depends on them.
    authProvider.onUserLoggedIn = () async {
      final userId = authProvider.user?.email;
      if (userId != null) {
        await userProvider.fetchUserData(userId);
      }
    };

    authProvider.onUserLoggedOut = () {
      userProvider.clearUser();
    };

    return GetMaterialApp(
      //INTERNATIONALIZATION SETTINGS
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      //THEME CUSTOMIZATION
      theme: MyThemes.customTheme,
      home: const AuthWrapper(),//const NavigationScreen()
    );
  }
}

// class AuthWrapper extends StatefulWidget {
//   const AuthWrapper({Key? key}) : super(key: key);
//
//   @override
//   State<AuthWrapper> createState() => _AuthWrapperState();
// }
//
// class _AuthWrapperState extends State<AuthWrapper> {
//   final GetStorage _getStorage = GetStorage();
//   @override
//   Widget build(BuildContext context) {
//     final firebaseUser = context.watch<User?>();
//     //final onBoarding = _getStorage.read("onBoarding");
//
//     //IF USER IS CONNECTED AND REMEMBER ME WAS CHECKED
//     if (firebaseUser != null) {
//       return const NavigationScreen();
//     }
//     //IF IT'S THE USER'S FIRST TIME USING THE APP && DEVICE ISN'T WEB
//     // if(onBoarding==null && !kIsWeb) {
//     //   return const OnBoardingScreen();
//     // }
//     //ELSE
//     return const LoginScreen();
//   }
// }

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.user != null) {
      return const NavigationScreen(); // Replace with your home screen
    } else {
      return const LoginScreen(); // Replace with your auth screen
    }
  }
}

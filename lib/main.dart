import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:livestream/Services/firebase_auth_services.dart';
import 'package:livestream/screens/login.dart';
import 'package:livestream/screens/navigation.dart';
import 'package:livestream/translations/codegen_loader.g.dart';
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
      child: const MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //THE ROOT OF THE APP
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ///This ensures that you only have one instance of FirebaseAuthServices for the lifetime of your app,
        ///which can be accessed from any screen using context.read<FirebaseAuthServices>() or context.watch<FirebaseAuthServices>().
        Provider<FirebaseAuthServices>(
          create: (_)=> FirebaseAuthServices(FirebaseAuth.instance),
        ),
        ///It automatically rebuilds parts of your UI whenever the authState changes, allowing you to display the appropriate screen.
        /// initialData: null is used to provide a fallback value (null) before the stream emits its first value.
        StreamProvider(
            create: (context)=> context.read<FirebaseAuthServices>().authState,
            initialData: null
        )
      ],
      child: GetMaterialApp(
        //INTERNATIONALIZATION SETTINGS
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        //THEME CUSTOMIZATION
        theme: MyThemes.customTheme,
        home: const NavigationScreen()//const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final GetStorage _getStorage = GetStorage();
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    //final onBoarding = _getStorage.read("onBoarding");

    //IF USER IS CONNECTED AND REMEMBER ME WAS CHECKED
    if (firebaseUser != null) {
      return const NavigationScreen();
    }
    //IF IT'S THE USER'S FIRST TIME USING THE APP && DEVICE ISN'T WEB
    // if(onBoarding==null && !kIsWeb) {
    //   return const OnBoardingScreen();
    // }
    //ELSE
    return const LoginScreen();
  }
}

// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({super.key});
//   @override
//   Widget build(BuildContext context) {
//     //passing user from here has more advantage than calling it directly in method
//     final firebaseUser = context.watch<User?>(); // Get current user
//     final authService = context.read<FirebaseAuthServices>(); // Access service
//
//     return authService.determineScreen(firebaseUser);
//   }
// }

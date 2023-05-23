import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:livestream/Screens/Authentication/forgot_password_screen.dart';
import 'package:livestream/Screens/Authentication/login_screen.dart';
import 'package:livestream/Screens/Authentication/registration_screen.dart';
import 'package:livestream/Screens/HomePage/home_screen.dart';
import 'package:livestream/Resources/firebase_auth_methods.dart';
import 'package:livestream/Screens/Settings/contact_us.dart';
import 'package:livestream/translations/codegen_loader.g.dart';
import 'package:livestream/unknown_route_page.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import 'Screens/Going Live/go_live_screen.dart';
import 'Screens/Settings/settings_screen.dart';
import 'Services/Themes/theme_service.dart';
import 'Services/Themes/my_themes.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'on_boarding_screen.dart';

Future<void> main() async {
  //USED FOR THE BINDING TO BE INITIALIZED BEFORE CALLING runApp.
  WidgetsFlutterBinding.ensureInitialized();

  //SET THE ORIENTATION TO BE PORTRAIT ONLY
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,]);

  //MAKE THE APP FULL SCREEN => HIDES THE STATUS AND NAVIGATION BAR OF THE PHONE
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);

  //TO LOAD THE .env FILE CONTENTS INTO DOTENV
  await dotenv.load(fileName: ".env");

  //INITIALIZE GET STORAGE
  await GetStorage.init();

  //INITIALIZE FIREBASE
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);

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
        Provider<FirebaseAuthMethods>(
          create: (_)=>FirebaseAuthMethods(FirebaseAuth.instance),
        ),
        StreamProvider(
            create: (context)=>context.read<FirebaseAuthMethods>().authState,
            initialData: null)
      ],
      child: GetMaterialApp(
        //INTERNATIONALIZATION SETTINGS
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        //REMOVING THE DEBUG BANNER
        debugShowCheckedModeBanner: false,
        //THEMES FILES
        theme: MyThemes.lightTheme,
        darkTheme: MyThemes.darkTheme,
        themeMode: ThemeService().theme,
        //IF USER USES AN UNKNOWN ROUTE PATH
        onUnknownRoute: (RouteSettings routeSettings){
          return MaterialPageRoute<void>(
            settings: routeSettings,
            builder: (BuildContext context) =>
                const UnknownRoutePage(),
          );
        },
        //defaultTransition: ,
        routes: {
            Home.routeName: (context) => Home(selectedIndex: 0,),
            LoginScreen.routeName: (context) => const LoginScreen(),
            RegistrationScreen.routeName: (context) => const RegistrationScreen(),
            SettingsScreen.routeName: (context) => const SettingsScreen(),
            ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
            GoLiveScreen.routeName: (context) => const GoLiveScreen(),
            ContactUs.routeName: (context) => const ContactUs(),

          //BroadcastScreen.routeName: (context) => const BroadcastScreen(isBroadcaster: false, channelId: '',),
          },
        //THE FIRST SCREEN
        home: const AuthWrapper(),
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
      return Home(selectedIndex: 0,);
    }
    //IF IT'S THE USER'S FIRST TIME USING THE APP && DEVICE ISN'T WEB
    // if(onBoarding==null && !kIsWeb) {
    //   return const OnBoardingScreen();
    // }
    //ELSE
    return const LoginScreen();
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';


import '../services/user_services.dart';
import '../config/utils.dart';
import '../screens/navigation.dart';
import '../models/user.dart';
import '../screens/login.dart';
import '../config/routing.dart';
import '../translations/locale_keys.g.dart';

class FirebaseAuthServices{
  // final FirebaseAuth _firebaseAuth;
  // FirebaseAuthServices(this._firebaseAuth);

  //User get user => _firebaseAuth.currentUser!;

  //STATE PERSISTENCE
  //Stream<User?> get authState => _firebaseAuth.authStateChanges();

  final BuildContext _context = Get.context!;

  // Add this method to decide which screen to show
  // Widget determineScreen(User? firebaseUser) {
  //   // final GetStorage _getStorage = GetStorage();
  //   // // Example: Check storage or firebase user
  //   // if (firebaseUser != null) {
  //   //   return const NavigationScreen();
  //   // }
  //   //
  //   // // Add onboarding or other logic as needed
  //   // // final onBoarding = getStorage.read("onBoarding");
  //   // // if (onBoarding == null && !kIsWeb) {
  //   // //   return const OnBoardingScreen();
  //   // // }
  //   //
  //   // return const LoginScreen();
  // }

  //EMAIL & PASSWORD SIGNUP
  Future<void> signUpWithEmailAndPassword({required UserModel userModel}) async{
    // try{
    //   //SHOW LOADING CIRCLE
    //   showLoadingPopUp();
    //
    //   await _firebaseAuth.createUserWithEmailAndPassword(email: userModel.email, password: userModel.password);
    //   user.updateDisplayName(userModel.nickname);
    //
    //   //ADD USER TO DATABASE
    //   UserServices().createUser(userModel);
    //
    //   if(!_context.mounted) return;
    //   await sendEmailVerification();
    //
    //   Get.back();//POP LOADING CIRCLE
    //
    // }catch(e){
    //   debugPrint(e.toString());
    //   Get.back();//POP LOADING CIRCLE
    //   showToast(toastType: ToastType.error, message: e.toString());
    // }
  }


  //EMAIL & PASSWORD LOGIN
  Future<void> signInWithEmailAndPassword({required UserModel userModel}) async {
    // try{
    //   //SHOW LOADING CIRCLE
    //   showLoadingPopUp();
    //
    //   await _firebaseAuth.signInWithEmailAndPassword(email: userModel.email, password: userModel.password);
    //
    //   Get.back();//POP LOADING CIRCLE
    //
    //   //SEND EMAIL VERIFICATION IF NOT YET VERIFIED
    //   if(!_firebaseAuth.currentUser!.emailVerified && !_context.mounted){
    //     await sendEmailVerification();
    //   }else{
    //     popRoute(_context);
    //   }
    //
    // } catch(e){
    //   debugPrint(e.toString());
    //   Get.back();//POP LOADING CIRCLE
    //   showToast(toastType: ToastType.error, message: e.toString());
    // }
  }


  //EMAIL VERIFICATION
  Future<void> sendEmailVerification() async{
    // try{
    //   _firebaseAuth.currentUser!.sendEmailVerification();
    //   _firebaseAuth.signOut();
    //
    //   showToast(toastType: ToastType.info, message: LocaleKeys.emailVerifcationSent.tr());
    // }catch(e){
    //   debugPrint(e.toString());
    //   showToast(toastType: ToastType.error, message: e.toString());
    // }
  }

  //GOOGLE SIGN IN
  Future<void> signInWithGoogle(BuildContext context) async{
    //try{
    //   if(kIsWeb){
    //     GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
    //     googleAuthProvider.addScope("https://www.googleapis.com/auth/contacts.readonly");
    //     await _firebaseAuth.signInWithPopup(googleAuthProvider).whenComplete(() => popRoute(context));
    //   }else{
    //       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    //       final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    //
    //       if(googleAuth?.accessToken!=null && googleAuth?.idToken!=null){
    //         //CREATE A NEW CREDENTIAL
    //         final credential = GoogleAuthProvider.credential(
    //             accessToken: googleAuth?.accessToken,
    //             idToken: googleAuth?.idToken
    //         );
    //
    //         //SHOW LOADING CIRCLE
    //         showLoadingPopUp();
    //
    //         //SIGN IN
    //         await _firebaseAuth.signInWithCredential(credential).whenComplete(() {
    //           UserModel userModel = UserModel(email: _firebaseAuth.currentUser!.email!, nickname: _firebaseAuth.currentUser!.displayName!);
    //           UserServices().createUser(userModel);
    //         });
    //
    //         if(!context.mounted) return;
    //
    //         popRoute(context);
    //       }
    //   }
    //   // popRoute(context);
    // }catch(e){
    //   debugPrint(e.toString());
    //   Get.back();//POP LOADING CIRCLE
    //   showToast(toastType: ToastType.error, message: e.toString());
    // }
  }

  // Future<void> signInWithGoogle(BuildContext context) async {
  //   try {
  //     if (kIsWeb) {
  //       // Web-specific logic
  //       GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
  //       googleAuthProvider.addScope("https://www.googleapis.com/auth/contacts.readonly");
  //       await _firebaseAuth.signInWithRedirect(googleAuthProvider);
  //
  //       UserCredential userCredential = await _firebaseAuth.getRedirectResult();
  //       if (userCredential.user != null) {
  //         UserServices().createUser(UserModel(
  //           email: userCredential.user!.email!,
  //           nickname: userCredential.user!.displayName!,
  //         ));
  //       }
  //     } else {
  //       // Mobile logic
  //       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //       final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  //
  //       if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
  //         final credential = GoogleAuthProvider.credential(
  //           accessToken: googleAuth?.accessToken,
  //           idToken: googleAuth?.idToken,
  //         );
  //
  //         showLoadingPopUp();
  //
  //         await _firebaseAuth.signInWithCredential(credential).whenComplete(() {
  //           UserModel userModel = UserModel(
  //             email: _firebaseAuth.currentUser!.email!,
  //             nickname: _firebaseAuth.currentUser!.displayName!,
  //           );
  //           UserServices().createUser(userModel);
  //         });
  //
  //         if (!context.mounted) return;
  //         popRoute(context);
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     Get.back(); // Close loading circle
  //     showToast(toastType: ToastType.error, message: e.toString());
  //   }
  // }


  //SIGN OUT FROM ANY TYPE OF AUTHENTICATION
  Future<void> signOut(BuildContext context) async{
    // try{
    //   //SHOW LOADING CIRCLE
    //   showLoadingPopUp();
    //
    //   //IF CONNECTED USING A GOOGLE ACCOUNT
    //   var methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(_firebaseAuth.currentUser!.email!);
    //   if (methods.contains('google.com')) {
    //     await GoogleSignIn().disconnect();
    //   }
    //
    //   await _firebaseAuth.signOut().whenComplete(()=> popRoute(context));
    //
    // }on FirebaseAuthException catch(e){
    //   debugPrint(e.toString());
    //   Get.back();//POP LOADING CIRCLE
    //   showToast(toastType: ToastType.error, message: e.toString());
    // }
  }

  //SEND RESET PASSWORD EMAIL
  Future<void> resetPassword(BuildContext context, String email) async{
    // try{
    //   await _firebaseAuth.sendPasswordResetEmail(email: email).whenComplete(() => mySnackBar(LocaleKeys.emailSentSuccessfully.tr(), Colors.green));
    // }on FirebaseAuthException catch(e){
    //   debugPrint(e.message);
    //   mySnackBar( LocaleKeys.checkYourEmail.tr(), Colors.red);
    // }
  }

  Future<void> changePassword(BuildContext context, String email, String oldPassword, String newPassword) async{
    // try{
    //   var credentials = EmailAuthProvider.credential(email: email, password: oldPassword);
    //
    //   await user.reauthenticateWithCredential(credentials).then((value){
    //     user.updatePassword(newPassword);
    //   });
    //
    // }catch(e){
    //   debugPrint(e.toString());
    //   showToast(toastType: ToastType.error, message: e.toString());
    // }
  }

}
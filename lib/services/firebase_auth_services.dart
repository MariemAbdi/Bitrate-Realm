import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;


import '../main.dart';
import '../services/user_services.dart';
import '../config/utils.dart';
import '../models/user.dart';
import '../translations/locale_keys.g.dart';

class FirebaseAuthServices{
  FirebaseAuthServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get user => _firebaseAuth.currentUser;

  //STATE PERSISTENCE
  Stream<User?> get authState => _firebaseAuth.authStateChanges();

  //EMAIL & PASSWORD SIGNUP
  Future<User?> signUpWithEmailAndPassword({required UserModel userModel}) async{
    try{
      //SHOW LOADING CIRCLE
      showLoadingPopUp();

      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: userModel.email, password: userModel.password);

      //ADD USER TO DATABASE
      UserServices().createUser(userModel);

      // if(!_context.mounted) return;
      // await sendEmailVerification();

      return userCredential.user;
    }catch(e){
      showToast(toastType: ToastType.error, message: e.toString());
      return null;
    }finally{
      Get.back();//POP LOADING CIRCLE
    }
  }


  //EMAIL & PASSWORD LOGIN
  Future<User?> signInWithEmailAndPassword({required String email, required String password}) async {
    try{
      //SHOW LOADING CIRCLE
      showLoadingPopUp();

      final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      // //SEND EMAIL VERIFICATION IF NOT YET VERIFIED
      // if(!_firebaseAuth.currentUser!.emailVerified && !_context.mounted){
      //   await sendEmailVerification();
      // }else{
      //   popRoute(_context);
      // }

      return userCredential.user;
    }catch(e){
      showToast(toastType: ToastType.error, message: e.toString());
      return null;
    }finally{
      Get.back();//POP LOADING CIRCLE
    }
  }


  //EMAIL VERIFICATION
  Future<void> sendEmailVerification() async{
    try{
      _firebaseAuth.currentUser!.sendEmailVerification();
      _firebaseAuth.signOut();
      showToast(toastType: ToastType.info, message: LocaleKeys.emailVerifcationSent.tr());
    }catch(e){
      debugPrint(e.toString());
      showToast(toastType: ToastType.error, message: e.toString());
    }
  }

  //GOOGLE SIGN IN
  Future<void> signInWithGoogle() async{
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
  Future<void> signOut() async{
    try{
      //SHOW LOADING CIRCLE
      showLoadingPopUp();

//       //IF CONNECTED USING A GOOGLE ACCOUNT
//       var methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(_firebaseAuth.currentUser!.email!);
//       if (methods.contains('google.com')) {
//         await GoogleSignIn().disconnect();
//       }
// //GoogleSignIn().signOut();  ????


      await _firebaseAuth.signOut();

      Get.offAll(const AuthPage());
    }on FirebaseAuthException catch(e){
      showToast(toastType: ToastType.error, message: e.toString());
    }finally{
      Get.back();//POP LOADING CIRCLE
    }
  }

  //SEND RESET PASSWORD EMAIL
  Future<void> resetPassword(String email) async{
    try{
      await _firebaseAuth.sendPasswordResetEmail(email: email).whenComplete(()
      => mySnackBar(LocaleKeys.emailSentSuccessfully.tr(), Colors.green)
      );
    }on FirebaseAuthException catch(e){
      debugPrint(e.message);
      mySnackBar( LocaleKeys.checkYourEmail.tr(), Colors.red);
    }
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    try {
      // Ensure the user is not null
      if (user == null) {
        throw Exception("User is not logged in.");
      }

      // Re-authenticate the user with the old password
      var credentials = EmailAuthProvider.credential(email: user!.email!, password: oldPassword);

      // Re-authenticate with the old password
      await user?.reauthenticateWithCredential(credentials).then((value) async {
        // After re-authentication, update the password
        await user?.updatePassword(newPassword);
      });

      // If everything is successful, return true
      return true;
    } catch (e) {
      // Print the error for debugging purposes
      debugPrint("Error: $e");

      // Return false indicating failure
      return false;
    }
  }


}
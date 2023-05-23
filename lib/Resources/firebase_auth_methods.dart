import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:livestream/Resources/utils.dart';

import '../Models/user_model.dart' as model;
import '../Services/Themes/my_themes.dart';
import '../translations/locale_keys.g.dart';

class FirebaseAuthMethods{
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);

  User get user => _auth.currentUser!;

  // FOR EVERY FUNCTION HERE
  // POP THE ROUTE USING: Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);

  void popRoute(BuildContext context){
    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  //STATE PERSISTENCE
  Stream<User?> get authState => _auth.authStateChanges();

  //EMAIL & PASSWORD SIGNUP
  Future<void> signUpWithEmailAndPassword({required String nickname,required String email, required String password, required BuildContext context}) async{
    try{
      //SHOW LOADING CIRCLE
      showDialog(context: context, builder: (context){
        return const Center(child: CircularProgressIndicator(color: MyThemes.darkBlue,),);
      });
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      user.updateDisplayName(nickname);

      //if(context.mounted) return;
      await sendEmailVerification(context);

      //POP LOADING CIRCLE
      //if(context.mounted) return;
      Navigator.pop(context);

    }on FirebaseAuthException catch(e){
      if (e.code == 'user-not-found') {
        mySnackBar(context, LocaleKeys.userNotFound.tr(), Colors.red);
      }else{
        mySnackBar(context, LocaleKeys.internalError.tr(), Colors.red);
      }
    } catch(e){
      debugPrint(e.toString());
    }
  }


  //EMAIL & PASSWORD LOGIN
  Future<void> signInWithEmailAndPassword({required String email, required String password, required BuildContext context}) async {
    try{
      //SHOW LOADING CIRCLE
      showDialog(context: context, builder: (context){
        return const Center(child: CircularProgressIndicator(color: MyThemes.darkBlue,),);
      });
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      //POP LOADING CIRCLE
      Navigator.pop(context);

      //SEND EMAIL VERIFICATION IF NOT YET VERIFIED
      if(!_auth.currentUser!.emailVerified){
        await sendEmailVerification(context);
      }else{
        popRoute(context);
      }

    }on FirebaseAuthException catch(e){
      Navigator.pop(context);

      if (e.code == 'user-not-found') {
        mySnackBar(context, LocaleKeys.userNotFound.tr(), Colors.red);
      }else{
        mySnackBar(context, LocaleKeys.internalError.tr(), Colors.red);
      }


    } catch(e){
      debugPrint(e.toString());
    }
  }


  //EMAIL VERIFICATION
  Future<void> sendEmailVerification(BuildContext context) async{
    try{
      _auth.currentUser!.sendEmailVerification();
      _auth.signOut();
      mySnackBar(context, LocaleKeys.emailVerifcationSent.tr(), Colors.yellow.shade800);
    }on FirebaseAuthException catch(e){
      mySnackBar(context, e.message!, Colors.red);
    }catch(e){
      debugPrint(e.toString());
    }
  }

  //GOOGLE SIGN IN
  Future<void> signInWithGoogle(BuildContext context) async{
    try{
      if(kIsWeb){
        GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
        googleAuthProvider.addScope("https://www.googleapis.com/auth/contacts.readonly");
        await _auth.signInWithPopup(googleAuthProvider).whenComplete(() => popRoute(context));
      }else{
          final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
          final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

          if(googleAuth?.accessToken!=null && googleAuth?.idToken!=null){
            //CREATE A NEW CREDENTIAL
            final credential = GoogleAuthProvider.credential(
                accessToken: googleAuth?.accessToken,
                idToken: googleAuth?.idToken
            );

            //SHOW LOADING CIRCLE
            showDialog(context: context, builder: (context){
              return const Center(child: CircularProgressIndicator(color: MyThemes.darkBlue,),);
            });

            //SIGN IN
            await _auth.signInWithCredential(credential).whenComplete(() {
              model.User user= model.User(email: _auth.currentUser!.email!, nickname: _auth.currentUser!.displayName!);
              model.createUser(user);
            });

            popRoute(context);
          }
      }
      // popRoute(context);
    }catch(e){
      debugPrint(e.toString());
    }
  }

  //SIGN OUT FROM ANY TYPE OF AUTHENTICATION
  Future<void> signOut(BuildContext context) async{
    try{
      //SHOW LOADING CIRCLE
      showDialog(context: context, builder: (context){
        return const Center(child: CircularProgressIndicator(color: MyThemes.darkBlue,),);
      });

      //IF CONNECTED USING A GOOGLE ACCOUNT
      var methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(_auth.currentUser!.email!);
      if (methods.contains('google.com')) {
        await GoogleSignIn().disconnect();
      }

      await _auth.signOut().whenComplete(()=> popRoute(context));
      //popRoute(context);
    }on FirebaseAuthException catch(e){
      mySnackBar(context, e.message!, Colors.red);
    }
  }

  //SEND RESET PASSWORD EMAIL
  Future<void> resetPassword(BuildContext context, String email) async{
    try{
      await _auth.sendPasswordResetEmail(email: email).whenComplete(() => mySnackBar(context, LocaleKeys.emailSentSuccessfully.tr(), Colors.green));
    }on FirebaseAuthException catch(e){
      debugPrint(e.message);
      mySnackBar(context, LocaleKeys.checkYourEmail.tr(), Colors.red);
    }
  }

  Future<void> changePassword(BuildContext context, String email, String oldPassword, String newPassword) async{
    try{
      var credentials = EmailAuthProvider.credential(email: email, password: oldPassword);

      await user.reauthenticateWithCredential(credentials).then((value){
        user.updatePassword(newPassword);
      });
    }on FirebaseAuthException catch(e){
      mySnackBar(context, e.toString(), Colors.red);
    }
  }

}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:livestream/Widgets/Input%20Widgets/email_field.dart';
import 'package:livestream/Widgets/Input%20Widgets/multi_line_field.dart';
import 'package:livestream/Widgets/Input%20Widgets/nickname_field.dart';
import 'package:livestream/Widgets/Input%20Widgets/password_field.dart';
import 'package:livestream/Widgets/custom_button.dart';
import 'package:provider/provider.dart';

import '../../Resources/firebase_auth_methods.dart';
import '../../Resources/utils.dart';
import '../../Widgets/my_appbar.dart';
import '../../translations/locale_keys.g.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _bioController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final alertController = TextEditingController();

  late bool isConnectedWithMail=false;

  late String oldPassword ="";

  void _fetchData(BuildContext context) async{
    final user = context.read<FirebaseAuthMethods>().user;

    FirebaseFirestore.instance.collection("users").doc(user.email).get().then((DocumentSnapshot documentSnapshot) {
      setState(() {
        _nicknameController.text=documentSnapshot["nickname"];
        _bioController.text=documentSnapshot["bio"];
        _emailController.text=documentSnapshot["email"];
      });
    }
    );
  }

  //CHECK IF THE USER IS CONNECTED VIA A GOOGLE ACCOUNT THEN THE CHANGE PASSWORD FIELD WON'T SHOW UP
  void checkConnection()async{
    final user = context.read<FirebaseAuthMethods>().user;

    //IF CONNECTED USING A GOOGLE ACCOUNT
    var methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(user.email!);
    if (methods.contains('google.com')) {
      setState(() {
        isConnectedWithMail=false;
      });
    }else{
      setState(() {
        isConnectedWithMail=true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData(context);
    checkConnection();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nicknameController.dispose();
    _bioController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthMethods>().user;

    return Scaffold(
      appBar: MyAppBar(implyLeading: true, title: LocaleKeys.editProfile.tr(), action: Container(),),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              Visibility(
                  visible: isConnectedWithMail,
                  child: EmailField(emailController: _emailController)),

              Visibility(
                  visible: isConnectedWithMail,
                  child: const SizedBox(height: 15,)),

              NicknameField(nicknameController: _nicknameController),

              const SizedBox(height: 15,),

              MultilineField(controller: _bioController, label: LocaleKeys.bio.tr(), hint: LocaleKeys.enterYourBio.tr()),

              Visibility(
                  visible: isConnectedWithMail,
                  child: const SizedBox(height: 15,)),

              Visibility(
                  visible: isConnectedWithMail,
                  child: PasswordField(passwordController: _newPasswordController, requireValidation: false,)),

              const SizedBox(height: 30,),

              CustomButton(text: LocaleKeys.edit.tr(), function: () async{
                if (_formKey.currentState?.validate() ?? false) {
                  if(_bioController.text.trim().isEmpty){
                    _bioController.text="Hello World!";
                  }
                  if(_newPasswordController.text.trim().isNotEmpty){
                    //--------------------------RETYPE CURRENT PASSWORD--------------------------
                    final oldPassword= await openDialog();
                    if(oldPassword==null || oldPassword.isEmpty){return;}

                    setState(() {
                      this.oldPassword=oldPassword;
                    });
                  }

                  //--------------------------UPDATE EMAIL--------------------------
                  user.updateEmail(_emailController.text.trim());

                  //--------------------------UPDATE DISPLAY NAME--------------------------
                  user.updateDisplayName(_nicknameController.text.trim());

                  //--------------------------UPDATE COLLECTION IN FIRESTORE--------------------------
                  FirebaseFirestore.instance.collection("users").doc(user.email).update(
                      {
                        "nickname": _nicknameController.text.trim(),
                        "bio": _bioController.text.trim(),
                      });

                  if(!mounted) return;
                  if(_nicknameController.text.trim().isNotEmpty){
                    //--------------------------RESET PASSWORD IN FIREBASE AUTH--------------------------
                    context.read<FirebaseAuthMethods>().changePassword(context, user.email!, oldPassword, _newPasswordController.text.trim());
                    _newPasswordController.clear();
                  }
                  mySnackBar(context, LocaleKeys.profileUpdatedSuccessfully.tr(), Colors.green);
                }

              }),
            ],
          ),
        ),
      ),

    );
  }

  Future<String?> openDialog()=>showDialog<String>(context: context, builder: (context)=> AlertDialog(
    title: Text(LocaleKeys.oldPassword.tr()),
    content:
    PasswordField(passwordController: alertController, requireValidation: true,),
    actions: [
      TextButton(onPressed: (){
        if(alertController.text.isNotEmpty) {
          Navigator.of(context).pop(alertController.text);
          //alertController.clear();
        }
      }, child: Text(LocaleKeys.done.tr()))
    ],
  ));
}

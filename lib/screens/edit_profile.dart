import 'dart:typed_data';

import 'package:bitrate_realm/constants/spacing.dart';
import 'package:bitrate_realm/widgets/profile/edit_profile_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:provider/provider.dart';

import '../../services/firebase_auth_services.dart';
import '../../widgets/utils/custom_button.dart';
import '../../widgets/input/multi_line_field.dart';
import '../../widgets/input/nickname_field.dart';
import '../../widgets/input/password_field.dart';
import '../../config/utils.dart';
import '../../translations/locale_keys.g.dart';
import '../providers/user_provider.dart';
import '../widgets/utils/custom_app_bar.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  User firebaseAuthUser = FirebaseAuthServices().user!;

  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  late TextEditingController _oldPasswordController;
  late TextEditingController _newPasswordController;

  @override
  void initState() {
    super.initState();
    initializations();
    // Defer this method call to after the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeUserData();
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  initializations() {
    _usernameController = TextEditingController();
    _bioController = TextEditingController();
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
  }

  _initializeUserData() {
    UserProvider userProvider = context.read<UserProvider>();
    // Your code that listens for user changes
    userProvider.listenToUserChanges(firebaseAuthUser.email!); // Start listening to real-time updates

    // No need to manually fetch user data as it will be updated by the listener
    _usernameController.text = userProvider.user!.username;
    _bioController.text = userProvider.user!.bio;
    _newPasswordController.clear();
    _oldPasswordController.clear();
  }

  editProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      showLoadingPopUp(); // Show loading indicator while updating
      bool response = true;

      try {
        // Update the user data in Firestore
        await FirebaseFirestore.instance.collection("users").doc(firebaseAuthUser.email!).update({
          "username": _usernameController.text.trim(),
          "bio": _bioController.text.trim(),
        });

        // If old password is provided, reset password in Firebase Auth
        if (_oldPasswordController.text.trim().isNotEmpty && mounted) {
          response = await FirebaseAuthServices().changePassword(
            _oldPasswordController.text.trim(),
            _newPasswordController.text.trim(),
          );
        }
      } catch (error) {
        //showToast(toastType: ToastType.error, message: error.toString());
        response = false; // Mark response as failed in case of error
      } finally {
        if(mounted){
          Navigator.of(context, rootNavigator: true).pop();
        }

        // Show appropriate toast after closing loading popup
        if (response) {
          showToast(toastType: ToastType.success, message: LocaleKeys.profileUpdatedSuccessfully.tr());
        } else {
          showToast(toastType: ToastType.error, message: LocaleKeys.somethingWentWrong.tr());
        }

        _initializeUserData();
      }
    }
  }


  updateImage() async {
    Get.back(); // Hide bottom sheet
    Uint8List? pickedImage = await pickFile(context, FileType.image);
    if (pickedImage != null) {
      showLoadingPopUp();
      try {
        if(mounted) {
          await context.read<UserProvider>().updateProfileImage(pickedImage, firebaseAuthUser.email!);
        }
      } catch (error) {
        showToast(toastType: ToastType.error, message: error.toString());
      } finally {
        Get.back();
      }
    }
  }

  removeImage() async {
    Get.back(); // Hide bottom sheet
    showLoadingPopUp();
    try {
      await context.read<UserProvider>().removeProfileImage(firebaseAuthUser.email!);
    } catch (error) {
      showToast(toastType: ToastType.error, message: error.toString());
    } finally {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.user;

    return Scaffold(
      appBar: CustomAppBar(title: LocaleKeys.editProfile.tr()),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              EditProfileImage(
                profileImageLink: user?.pictureURL,
                updateImage: updateImage,
                removeImage: removeImage,
              ),
              kVerticalSpace,
              NicknameField(nicknameController: _usernameController),
              kVerticalSpace,
              MultilineField(
                controller: _bioController,
                label: LocaleKeys.bio.tr(),
                hint: LocaleKeys.enterYourBio.tr(),
              ),
              kVerticalSpace,
              PasswordField(
                title: "Current Password",
                passwordController: _oldPasswordController,
                canBeEmpty: _newPasswordController.text.isEmpty,
              ),
              kVerticalSpace,
              PasswordField(
                passwordController: _newPasswordController,
                canBeEmpty: _oldPasswordController.text.isEmpty,
              ),
              kVerticalSpace,
              CustomButton(
                text: LocaleKeys.edit.tr(),
                onPressed: editProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

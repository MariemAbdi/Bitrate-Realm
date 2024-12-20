import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:bitrate_realm/constants/about_us.dart';
import 'package:bitrate_realm/models/alert_data.dart';
import 'package:bitrate_realm/widgets/utils/custom_outlined_button.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../services/firebase_auth_services.dart';
import '../widgets/utils/custom_alert.dart';
import '../widgets/utils/custom_button.dart';
import 'app_style.dart';
import '../translations/locale_keys.g.dart';

BuildContext _context = Get.context!;

enum ToastType { success, info, error }

//PICK FILE FROM DEVICE
Future<Uint8List?> pickFile(BuildContext context, FileType type) async {
  FilePickerResult? pickedImage =
      await FilePicker.platform.pickFiles(allowMultiple: false, type: type);
  try {
    if (pickedImage != null) {
      if (kIsWeb) {
        //FOR WEB
        return pickedImage.files.single.bytes;
      }
      //FOR MOBILE
      return await File(pickedImage.files.single.path!).readAsBytes();
    } else {
      mySnackBar(LocaleKeys.noFileSelected.tr(), Colors.red);
    }
  } catch (e) {
    mySnackBar(e.toString(), Colors.red);
  }

  return null;
}

//RETURN A FORMATTED STRING FROM A LIST
String tagsList(List<String> tagList) {
  String result = "";
  for (int i = 0; i < tagList.length; i++) {
    result += "#${tagList[i]} ";
  }
  return result;
}

//SIMPLE BOTTOM SNACK BAR
Future<void> mySnackBar(String message, Color color) {
  return ScaffoldMessenger.of(_context)
      .showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: color,
      ))
      .closed
      .then((value) => ScaffoldMessenger.of(_context).clearSnackBars());
}

//COPY TO CLIPBOARD
Future<void> copyToClipboard(String textToCopy) async {
  await Clipboard.setData(ClipboardData(text: textToCopy)).whenComplete(()
  => mySnackBar(LocaleKeys.copiedToClipboard.tr(), Colors.grey.shade700));
}

void showToast({required ToastType toastType, required String message}) {
  Color backgroundColor;
  String title;

  switch (toastType) {
    case ToastType.success:
      title = "Success";
      backgroundColor = Colors.green;
      break;
    case ToastType.error:
      title = "Error";
      backgroundColor = Colors.redAccent;
      break;
    default:
      title = "Notice";
      backgroundColor = Colors.grey;
  }

  Get.snackbar(title, message,
      backgroundColor: backgroundColor,
      snackPosition: SnackPosition.BOTTOM,
      titleText: Text(title, style: const TextStyle(color: Colors.white)),
      messageText: Text(message, style: const TextStyle(color: Colors.white)));
}

void showLoadingPopUp() {
  Get.dialog(
      barrierColor: Colors.black.withOpacity(0.85),
      barrierDismissible: false,
      const PopScope(
          canPop: false,
          child: Center(
              child: CircularProgressIndicator(color: Colors.white))));
}

void customBottomSheet(Widget child, {Color? backgroundColor}){
  Get.bottomSheet(
      elevation: 6,
      backgroundColor: backgroundColor ?? Get.theme.scaffoldBackgroundColor,
      Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: child,
        ),
      )
  );
}

void customPopUp({required Widget child, required String title}){
  Get.dialog(
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10, tileMode: TileMode.mirror),
        child: AlertDialog(
          insetPadding: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Center(
              child: Text(
                  title,
                  style: Get.textTheme.displayMedium?.copyWith(color: MyThemes.primaryColor)
              )),
          //iconPadding: EdgeInsets.zero,
          icon: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: ()=> Get.back(),
                  icon: const Icon(Icons.clear, color: Colors.white))),
          content: SingleChildScrollView(child: child),
        ),
      )
  );
}

Future customInformativeCoolAlert(BuildContext context, String title, String text, String lottieAsset) {
  return CoolAlert.show(
    context: context,
    type: CoolAlertType.success,
    title: title,
    text: text,
    loopAnimation: true,
    lottieAsset: lottieAsset,
    backgroundColor: Theme.of(context).primaryColorDark,
    confirmBtnColor: Theme.of(context).primaryColorDark,
    confirmBtnText: LocaleKeys.done.tr(),
    onConfirmBtnTap: () {
      Navigator.pop(context);
    },
  );
}

String formatDuration(int time) {
  Duration duration = Duration(seconds: time);
  String hours = duration.inHours.toString().padLeft(2, '0');
  String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
  String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
  return '$hours:$minutes:$seconds';
}

//SEND EMAIL WITH THE RATING
Future<int> sendEmail(String subject, String sender, String message) async {
  final url = Uri.parse(dotenv.env['EMAILJS_POSTURL']!);
  String serviceId = dotenv.env['EMAILJS_SERVICEID']!;
  String templateId = dotenv.env['EMAILJS_TEMPLATEID']!;
  String publicKey = dotenv.env['EMAILJS_PUBLICKEY']!;
  final response = await http.post(url,
      headers: {
        'Content-Type': 'application/json',
        'origin': 'http://localhost'
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': publicKey,
        'template_params': {
          "subject": subject,
          "email": sender,
          "message": message,
        },
      }));
  return response.statusCode;
}

//BOTTOM SHEET TO RATE APP
void ratingBottomSheet() {
  double rating = 0;
  Get.bottomSheet(
    StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.3,
            builder: (_, controller) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.rateUs.tr().toUpperCase(),
                    style: context.textTheme.displayMedium,
                  ),

                  RatingBar.builder(
                    initialRating: rating,
                    allowHalfRating: true,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (newRating) {
                      setState(() {
                        rating = newRating;
                      });
                    },
                  ),
                  Text(
                    "$rating/5",
                    style: context.textTheme.displayMedium
                  ),
                  CustomButton(
                      text: LocaleKeys.done.tr(),
                      onPressed: () async {
                        sendEmail("APPLICATION RATING", FirebaseAuthServices().user!.email!, "$rating/5");
                        setState(() {
                          rating = 5;
                        });
                        Get.back();
                        showToast(toastType: ToastType.success, message: LocaleKeys.ratingSentSuccessfully.tr());
                      }),
                ],
              );
            },
          ),
        );
      },
    ),
    isScrollControlled: true,
    backgroundColor: MyThemes.secondaryColor,
    );
}

void signOutPopUp(){
  showCustomPopup(
    AlertData(
        title: LocaleKeys.logout.tr(),
        description: LocaleKeys.areYouSureYouWantToLogout.tr(),
        lottieAsset: "assets/lottie/sad-dog.json",
        onConfirm: ()=>FirebaseAuthServices().signOut()
    )
  );
}

void showCustomPopup(AlertData alertData) {
  Get.dialog(
    barrierColor: Colors.black.withOpacity(0.85),
    barrierDismissible: false,
    CustomAlert(alertData: alertData),
  );
}

Future<void> launchPhoneDialer() async {
  try {
    await launchUrl(Uri(
        scheme: "+216 23 456 789",
        path: "tel"
    ));
  } catch (error) {
    throw("Cannot dial");
  }
}

languageSelection(){
  String currentLanguage = GetStorage().read("language") ?? "English";
  customPopUp(
      title: "Pick A Language".toUpperCase(),
      child: StatefulBuilder(
          builder: (context, setState){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: availableLanguages.entries.map((language)
              => currentLanguage==language.key
                  ?Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: CustomButton(
                    text: language.key,
                    onPressed: ()async{
                      GetStorage().write("language", language.key);
                      await context.setLocale( Locale(language.value)); // change `easy_localization` locale
                      await Get.updateLocale( Locale(language.value));// change `Get` locale direction
                      Get.back();
                    }
                ),
              )
              :Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: CustomOutlinedButton(
                    child: Text(language.key),
                    onPressed: ()async{
                      GetStorage().write("language", language.key);
                      await context.setLocale( Locale(language.value)); // change `easy_localization` locale
                      await Get.updateLocale( Locale(language.value)); // change `Get` locale direction
                      Get.back();
                    }
                ),
              )).toList(),
            );
          })
  );
}
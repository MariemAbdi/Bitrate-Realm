import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:bitrate_realm/constants/about_us.dart';
import 'package:bitrate_realm/models/alert_data.dart';
import 'package:bitrate_realm/widgets/utils/custom_outlined_button.dart';
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
import 'package:timeago/timeago.dart' as timeago;

import '../services/firebase_auth_services.dart';
import '../widgets/utils/custom_alert.dart';
import '../widgets/utils/custom_button.dart';
import 'app_style.dart';
import '../translations/locale_keys.g.dart';

//BuildContext _context = Get.context!;

enum ToastType { success, info, error }

//PICK FILE FROM DEVICE
Future<Uint8List?> pickFile(FileType type) async {
  FilePickerResult? pickedImage = await FilePicker.platform.pickFiles(allowMultiple: false, type: type);
  try {
    if (pickedImage != null) {
      if (kIsWeb) {
        //FOR WEB
        return pickedImage.files.single.bytes;
      }
      //FOR MOBILE
      return await File(pickedImage.files.single.path!).readAsBytes();
    } else {
      showToast(toastType: ToastType.error, message: LocaleKeys.noFileSelected.tr());
    }
  } catch (error) {
    showToast(toastType: ToastType.error, message: error.toString());
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

Future<void> copyToClipboard(String textToCopy) async {
  await Clipboard.setData(ClipboardData(text: textToCopy)).whenComplete(()
  => showToast(toastType: ToastType.info, message: LocaleKeys.copiedToClipboard.tr()));
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
      backgroundColor = MyThemes.primaryColor;
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
              child: CircularProgressIndicator())));
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
        filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10, tileMode: TileMode.mirror),
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

String formatDuration(int time) {
  Duration duration = Duration(seconds: time);
  String hours = duration.inHours.toString().padLeft(2, '0');
  String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
  String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
  return '$hours:$minutes:$seconds';
}

String formatDateTime(DateTime dateTime, {String locale = 'en'}) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays >= 365) {
    // If more than a year ago, return date in "dd/MM/yyyy" format
    return DateFormat('dd/MM/yyyy').format(dateTime);
  } else if (difference.inDays >= 7) {
    // If more than a week ago but less than a year, return "1 week ago", etc.
    return timeago.format(dateTime, locale: locale);
  } else if (difference.inDays >= 2) {
    // If more than 1 day but less than a week
    return '${difference.inDays} days ago';
  } else if (difference.inDays == 1) {
    // If yesterday
    return 'Yesterday';
  } else {
    // Less than a day
    return timeago.format(dateTime, locale: locale);
  }
}

String formatFollowersNumber(int number) {
  if (number < 1000) {
    return number.toString(); // Return the number as it is if less than 1000
  } else if (number < 1000000) {
    double inThousands = number / 1000;
    // Format as K with up to two decimal places
    return '${inThousands.toStringAsFixed(2).replaceAll(RegExp(r'([.]*0+)(?!.*\d)'), '')}K'; // Remove trailing zeros
  } else if (number < 999000000) {
    double inMillions = number / 1000000;
    // Format as M with up to two decimal places
    return '${inMillions.toStringAsFixed(2).replaceAll(RegExp(r'([.]*0+)(?!.*\d)'), '')}M'; // Remove trailing zeros
  } else {
    return '+999M'; // Handle overflow
  }
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
              :CustomOutlinedButton(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Text(language.key),
                  onPressed: ()async{
                    GetStorage().write("language", language.key);
                    await context.setLocale( Locale(language.value)); // change `easy_localization` locale
                    await Get.updateLocale( Locale(language.value)); // change `Get` locale direction
                    Get.back();
                  }
              )).toList(),
            );
          })
  );
}
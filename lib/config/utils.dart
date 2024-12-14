import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

import 'app_style.dart';
import '../translations/locale_keys.g.dart';

BuildContext _context = Get.context!;

enum ToastType{success, info, error}

//PICK FILE FROM DEVICE
Future<Uint8List?> pickFile(BuildContext context, FileType type) async{
  FilePickerResult? pickedImage = await FilePicker.platform.pickFiles(allowMultiple: false, type: type);

    try{
      if(pickedImage!=null){
        if(kIsWeb){
          //FOR WEB
          return pickedImage.files.single.bytes;
        }
        //FOR MOBILE
        return await File(pickedImage.files.single.path!).readAsBytes();
      }else{
        mySnackBar(LocaleKeys.noFileSelected.tr(), Colors.red);
      }
    }catch(e){
      mySnackBar( e.toString(), Colors.red);
    }

  return null;
}

//RETURN A FORMATTED STRING FROM A LIST
String tagsList(List<String> tagList){
  String result="";
  for(int i=0; i<tagList.length;i++){
    result+="#${tagList[i]} ";
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
showToast({required ToastType toastType, required String message}){
  Color backgroundColor;
  String title;

  switch(toastType){
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

showLoadingPopUp(){
  Get.dialog(
      barrierColor: Colors.black.withOpacity(0.85),
      barrierDismissible: true,//false,
      const PopScope(
        canPop: false,
          child: Center(child: CircularProgressIndicator(color: MyThemes.primaryLight))
      )
  );
}

//CUSTOM ALERT POPUP WITH LOTTIE ASSETS TO ASK USER TO CONFIRM SOMETHING
Future customConfirmationCoolAlert(BuildContext context, String title, String text, String lottieAsset, Function()? fct) {
    return CoolAlert.show(
    context: context,
    type: CoolAlertType.confirm,
    title: title,
    text: text,
    loopAnimation: true,
    lottieAsset: lottieAsset,
    backgroundColor: Colors.white,
    cancelBtnText: LocaleKeys.cancel.tr(),
    confirmBtnColor: MyThemes.primaryLight,
    confirmBtnText: LocaleKeys.done.tr(),
    onCancelBtnTap: () => Get.back(),
    onConfirmBtnTap: fct,
  );
}

//CUSTOM ALERT POPUP WITH LOTTIE ASSETS TO INFORM USER OF SOMETHING
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
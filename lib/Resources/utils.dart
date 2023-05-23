import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../Services/Themes/my_themes.dart';
import '../translations/locale_keys.g.dart';

//PICK FILE FROM DEVICE
Future<Uint8List?> pickFile(BuildContext context, FileType type) async{
  FilePickerResult? pickedImage = await FilePicker.platform.pickFiles(allowMultiple: false,type: type);

    try{
      if(pickedImage!=null){
        if(kIsWeb){
          //FOR WEB
          return pickedImage.files.single.bytes;
        }
        //FOR MOBILE
        return await File(pickedImage.files.single.path!).readAsBytes();
      }else{
        mySnackBar(context, LocaleKeys.noFileSelected.tr(), Colors.red);
      }
    }catch(e){
      mySnackBar(context, e.toString(), Colors.red);
    }

  return null;
}


//RETURN A FORMATTED STRING FROM A LIST
String tagsList(List<String> tList){
  String result="";
  for(int i=0; i<tList.length;i++){
    result+="#${tList[i]} ";
  }
  return result;
}

//SIMPLE BOTTOM SNACK BAR
Future<void> mySnackBar(BuildContext context, String message, Color color) {
  return ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: color,
      ))
      .closed
      .then((value) => ScaffoldMessenger.of(context).clearSnackBars());
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
    confirmBtnColor: MyThemes.darkBlue,
    confirmBtnText: LocaleKeys.done.tr(),
    onCancelBtnTap: () {
      Navigator.pop(context);
    },
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
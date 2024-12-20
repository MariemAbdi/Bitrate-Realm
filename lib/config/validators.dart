import 'package:easy_localization/easy_localization.dart';

import '../translations/locale_keys.g.dart';

class Validators{
  String? emailValidation(String? email){
    if (email!.isEmpty) {
      return LocaleKeys.emailfieldcantbeempty.tr();
    } else if (!RegExp(r'^[a-zA-Z\d.]+@[a-zA-Z\d]+\.[a-zA-Z]+')
        .hasMatch(email)) {
      return LocaleKeys.pleaseenteravalidemail.tr();
    }
    return null;
  }

  String? nicknameValidation(String? nickname){
    if (nickname!.isEmpty) {
      return LocaleKeys.nicknamecantbeempty.tr();
    }
    return null;
  }

  String? passwordValidation(String? password){
    if (password!.isEmpty) {
      return LocaleKeys.passwordfieldcantbeempty.tr();
    } else if (password.length < 6) {
      return LocaleKeys.passwordmustbeatleast6characters.tr();
    }
    return null;
  }
}
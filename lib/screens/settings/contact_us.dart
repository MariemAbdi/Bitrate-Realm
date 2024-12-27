import 'package:bitrate_realm/config/app_style.dart';
import 'package:bitrate_realm/config/responsiveness.dart';
import 'package:bitrate_realm/constants/spacing.dart';
import 'package:bitrate_realm/widgets/contact%20us/contact_card.dart';
import 'package:bitrate_realm/widgets/utils/custom_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:bitrate_realm/config/utils.dart';
import 'package:lottie/lottie.dart';

import '../../constants/about_us.dart';
import '../../services/firebase_auth_services.dart';
import '../../translations/locale_keys.g.dart';
import '../../widgets/contact us/contact_info_card.dart';
import '../../widgets/input/custom_text_field.dart';
import '../../widgets/input/multi_line_field.dart';
import '../../widgets/utils/custom_app_bar.dart';
import '../../widgets/utils/custom_button.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _subject, _body ;

  @override
  void initState() {
    super.initState();
    _subject = TextEditingController();
    _body = TextEditingController();
  }

  @override
  void dispose() {
    _subject.dispose();
    _body.dispose();
    super.dispose();
  }

  //BOTTOM SHEET TO SEND AN EMAIL
  emailBottomSheet(){
    Get.bottomSheet(
      DraggableScrollableSheet(
        expand: false,
        minChildSize: 0.5,
        maxChildSize: 1.0,
        builder: (_, controller){
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(LocaleKeys.sendEmail.tr().toUpperCase(), style: Get.textTheme.headlineMedium?.copyWith(fontSize: 24, color: MyThemes.primaryColor)),
                  kVerticalSpace,

                  CustomTextField(
                      controller: _subject,
                      label: LocaleKeys.emailSubject.tr(),
                      hint: LocaleKeys.enterSubject.tr(),
                      errorMessage: LocaleKeys.subjectCantBeEmpty.tr()
                  ),
                  kVerticalSpace,

                  MultilineField(controller: _body, label: LocaleKeys.emailBody.tr(), hint: LocaleKeys.enterBody.tr()),
                  kVerticalSpace,

                  CustomButton(text: LocaleKeys.send.tr(), onPressed: ()async{
                    if (_formKey.currentState?.validate() ?? false){
                      sendEmail(_subject.text.trim(), FirebaseAuthServices().user!.email!, _body.text.trim())
                          .whenComplete((){
                        _subject.clear();
                        _body.clear();
                      });
                    }
                  }),
                ],
              ),
            ),
          );
        },
      ),
      backgroundColor: MyThemes.secondaryColor,
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: LocaleKeys.contactUs.tr()),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            //--------------------------------LOTTIE ASSET--------------------------------
            Lottie.asset("assets/lottie/contact-us.json", height: Responsiveness.deviceWidth(context)/2),

            //--------------------------------CALL US || EMAIL US BUTTONS--------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                      child: ContactCard(
                        title: LocaleKeys.callUs.tr(),
                        iconData: Icons.phone,
                        onPressed: launchPhoneDialer,
                      ),
                  ),
                  kHorizontalSpace,
                  Expanded(
                    child: ContactCard(
                      title: LocaleKeys.emailUs.tr(),
                      iconData: Icons.email,
                      onPressed: emailBottomSheet,
                    ),
                  ),
                ],
              ),
            ),

            //--------------------------------INFORMATION--------------------------------
            CustomListView(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: contactUsInformation.length,
              itemBuilder: (context, index){
                return ContactInfoCard(contactInfo: contactUsInformation[index]);
                },
            ),
          ],
        ),
      ),
    );
  }
}

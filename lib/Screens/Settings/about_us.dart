import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:livestream/translations/locale_keys.g.dart';
import 'package:lottie/lottie.dart';

import '../../Services/Themes/my_themes.dart';
import '../../Widgets/my_appbar.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {

  late int _currentIndex=0;

  final _aboutUsAssets=[
    "assets/lottie/name.json",
    "assets/lottie/founder.json",
    "assets/lottie/enterprise.json",
    "assets/lottie/values.json"];

  final _aboutUsTitle=[
    LocaleKeys.nameTitle.tr(),
    LocaleKeys.founderTitle.tr(),
    LocaleKeys.enterpriseTitle.tr(),
    LocaleKeys.valuesTitle.tr()];


  final _aboutUsText=[
    LocaleKeys.nameBody.tr(),
    LocaleKeys.founderBody.tr(),
    LocaleKeys.enterpriseBody.tr(),
    LocaleKeys.valuesBody.tr(),
  ];

  buildTabs(String title, int index) {
    return GestureDetector(
      onTap: (){
        setState(() {
          _currentIndex=index;
        });
      },
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _currentIndex==index?MyThemes.darkBlue:MyThemes.darkBlue.withOpacity(0.2),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 0.5,
              spreadRadius: 0.5,
              offset: const Offset(1,1),
            )
          ],
        ),
        child: Text(title, style: GoogleFonts.ptSans(color:Colors.white, fontWeight: FontWeight.w800, fontSize: 16),),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool _isLight= Theme.of(context).brightness==MyThemes.lightTheme.brightness;

    return Scaffold(
      appBar: MyAppBar(implyLeading: true, title: LocaleKeys.aboutUs.tr(), action: Container(),),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 600,
          ),
          child: Column(
            children: [

              const SizedBox(height: 15,),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  buildTabs(LocaleKeys.name.tr(), 0),
                  buildTabs(LocaleKeys.founder.tr(), 1),
                  buildTabs(LocaleKeys.enterprise.tr(), 2),
                  buildTabs(LocaleKeys.values.tr(), 3),
                ],),
              ),

              const SizedBox(height: 15,),

              //TAB BAR CONTENT
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(15.0),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children:  [
                    tabBodyWidget(_aboutUsAssets[_currentIndex], _aboutUsTitle[_currentIndex], _aboutUsText[_currentIndex], _isLight),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  tabBodyWidget(String asset,String textTitle, String textBody, bool isLight){
    return SingleChildScrollView(
      child: Column(
        children: [
          //------------------------LOTTIE ASSET------------------------
          Lottie.asset(asset,width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height*0.3),
          const SizedBox(height: 20,),
          //------------------------TITLE------------------------
          Text(textTitle, style: GoogleFonts.ptSans(fontWeight: FontWeight.w800, color: isLight?MyThemes.darkBlue:Colors.white.withOpacity(0.8), fontSize: 24),),
          const SizedBox(height: 20,),
          //------------------------BODY------------------------
          Text(textBody, style: GoogleFonts.ptSans(fontSize: 18,), textAlign: TextAlign.justify,),

          const SizedBox(height: 15,),
        ],
      ),
    );
  }
}

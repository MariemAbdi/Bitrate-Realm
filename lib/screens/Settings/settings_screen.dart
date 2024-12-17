import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bitrate_realm/Screens/Settings/about_us.dart';
import 'package:bitrate_realm/Screens/Settings/contact_us.dart';
import 'package:bitrate_realm/Screens/Settings/edit_profile.dart';
import 'package:bitrate_realm/Screens/Settings/favourite_videos.dart';
import 'package:bitrate_realm/Widgets/my_appbar.dart';
import 'package:bitrate_realm/config/utils.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../providers/auth_provider.dart';
import '../../services/firebase_auth_services.dart';
import '../../config/app_style.dart';
import '../../services/theme_services.dart';
import '../../translations/locale_keys.g.dart';
import '../../widgets/utils/custom_button.dart';



class SettingsScreen extends StatefulWidget {
  static String routeName = '/settings';
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDark = false;
  final GetStorage _getStorage = GetStorage();

  String _dropdownValue = "English";

  late bool isSwitched = true;

  late double _rating = 5.0;

  Widget _arrowIcon() {
    if (_dropdownValue == "العربية") {
      return const Icon(EvaIcons.arrowIosBack);
    } else {
      return const Icon(EvaIcons.arrowIosForward);
    }
  }

  void getCurrentLocale(){
   if(_getStorage.read("language")!=null){
     _dropdownValue=_getStorage.read("language");
   }
  }

  @override
  void initState() {
    getCurrentLocale();//UPDATE LANGUAGE DROPDOWN VALUE
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final bool isLight= Theme.of(context).brightness==MyThemes.customTheme.brightness;

    //DARK/LIGHT THEME WIDGET
    Widget themeWidget = Container(
      height: MediaQuery.of(context).size.height * 0.07,
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD5D5D5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              const Icon(CupertinoIcons.moon_stars_fill),
              const SizedBox(
                width: 10,
              ),
              Text(
                LocaleKeys.darkMode.tr(),
                style: GoogleFonts.ptSans(),
              ),
            ],
          ),
          FlutterSwitch(
            toggleSize: 30.0,
            value: isDark,
            borderRadius: 30.0,
            padding: 1.0,
            activeToggleColor: const Color(0xFF25afee),
            inactiveToggleColor: const Color(0xFFf2c039),
            activeSwitchBorder: Border.all(
              color: const Color(0xFF092e40),
              width: 3.0,
            ),
            inactiveSwitchBorder: Border.all(
              color: const Color(0xFFfdeab2),
              width: 3.0,
            ),
            activeColor: const Color(0xFF092e40),
            inactiveColor: const Color(0xFFfdeab2),
            activeIcon: const Icon(
              EvaIcons.moon,
              color: Colors.white,
            ),
            inactiveIcon: const Icon(
              EvaIcons.sun,
              color: Colors.white,
            ),
            onToggle: (val) {
              setState(() {
                isDark = val;
                ThemeServices().switchTheme();
              });
            },
          )
        ],
      ),
    );

    //LANGUAGE OPTION WIDGET
    Widget languageWidget = Container(
        height: MediaQuery.of(context).size.height * 0.07,
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFD5D5D5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                const Icon(Icons.language),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  LocaleKeys.language.tr(),
                  style: GoogleFonts.ptSans(),
                ),
              ],
            ),
            DropdownButton<String>(
                value: _dropdownValue,
                icon: const Icon(Icons.keyboard_arrow_down),
                borderRadius: BorderRadius.circular(12),
                underline: Container(),
                items: <String>['English', 'Français', 'العربية']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: GoogleFonts.ptSans(),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) async {
                  setState(() {
                    _dropdownValue = newValue!;
                    _getStorage.write("language", newValue);
                  });

                  if (_dropdownValue.compareTo("English") == 0) {
                    await context.setLocale(const Locale('en')); // change `easy_localization` locale
                    await Get.updateLocale(const Locale('en')); // change `Get` locale direction

                    setState((){});
                  } else if (_dropdownValue.compareTo("Français") == 0) {
                    await context.setLocale(const Locale('fr')); // change `easy_localization` locale
                    await Get.updateLocale(const Locale('fr')); // change `Get` locale direction

                    setState((){});
                  } else {
                    await context.setLocale(const Locale('ar')); // change `easy_localization` locale
                    await Get.updateLocale(const Locale('ar')); // change `Get` locale direction

                    setState((){});
                  }
                })
          ],
        ));

    //EDIT PROFILE DATA
    Widget editProfileWidget = InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const EditProfile()));
      },
      child: Container(
          height: MediaQuery.of(context).size.height * 0.07,
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFD5D5D5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(EvaIcons.edit),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    LocaleKeys.editProfile.tr(),
                    style: GoogleFonts.ptSans(),
                  ),
                ],
              ),
              IconButton(onPressed: () {}, icon: _arrowIcon())
            ],
          )),
    );


    //VIDEOS I LIKED
    Widget videosLikedWidget = InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const FavouriteVideos()));
      },
      child: Container(
          height: MediaQuery.of(context).size.height * 0.07,
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFD5D5D5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(EvaIcons.heart),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    LocaleKeys.myFavourites.tr(),
                    style: GoogleFonts.ptSans(),
                  ),
                ],
              ),
              IconButton(onPressed: () {}, icon: _arrowIcon())
            ],
          )),
    );

    //ABOUT US BUTTON
    Widget aboutUsWidget = InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const AboutUs()));
      },
      child: Container(
          height: MediaQuery.of(context).size.height * 0.07,
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFD5D5D5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(EvaIcons.alertCircle),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    LocaleKeys.aboutUs.tr(),
                    style: GoogleFonts.ptSans(),
                  ),
                ],
              ),
              IconButton(onPressed: () {}, icon: _arrowIcon())
            ],
          )),
    );

    //CONTACT US BUTTON
    Widget contactUsWidget = InkWell(
      onTap: () {
        //Navigator.pushNamed(context, ContactUs.routeName);
      },
      child: Container(
          height: MediaQuery.of(context).size.height * 0.07,
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFD5D5D5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(EvaIcons.people),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    LocaleKeys.contactUs.tr(),
                    style: GoogleFonts.ptSans(),
                  ),
                ],
              ),
              IconButton(onPressed: () {}, icon: _arrowIcon())
            ],
          )),
    );

    //SEND EMAIL WITH THE RATING
    Future sendEmail() async{
      final url = Uri.parse(dotenv.env['EMAILJS_POSTURL']!);
      String serviceId = dotenv.env['EMAILJS_SERVICEID']!;
      String templateId = dotenv.env['EMAILJS_TEMPLATEID']!;
      String publicKey = dotenv.env['EMAILJS_PUBLICKEY']!;
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json', 'origin': 'http://localhost'},
          body: json.encode({
            'service_id': serviceId,
            'template_id': templateId,
            'user_id': publicKey,
            'template_params': {
              "subject": "APPLICATION RATING",
              "email": Provider.of<AuthProvider>(context).user,//context.read<FirebaseAuthServices>().user.email,
              "message": "$_rating/5",
            },
          }));
      return response.statusCode;
    }

    //BOTTOM SHEET TO RATE APP
    ratingBottomSheet(){
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20)
              )
          ),
          builder: (context){
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0, left: 10.0, bottom: 20.0, top: 20.0),
                  child: DraggableScrollableSheet(
                    expand: false,
                    initialChildSize: 0.3,
                    minChildSize: 0.3,
                    maxChildSize: 1.0,
                    builder: (_, controller){
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Column(
                          //controller: controller,
                          children: [

                            Text(LocaleKeys.rateUs.tr(), style: GoogleFonts.ptSans(fontSize:18,fontWeight: FontWeight.w700, color: isLight?MyThemes.primaryLight:Colors.white.withOpacity(0.8)),),
                            const SizedBox(height: 20,),

                            RatingBar.builder(
                              initialRating: _rating,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                setState(() {
                                  _rating=rating;
                                });
                              },
                            ),

                            const SizedBox(height: 20),

                            Text("$_rating/5.0", style: GoogleFonts.ptSans(fontSize:18,fontWeight: FontWeight.w700, color: isLight?MyThemes.primaryLight:Colors.white.withOpacity(0.8)),),

                            const SizedBox(height: 25),
                            CustomButton(text: LocaleKeys.done.tr(), onPressed: ()async{
                              sendEmail();
                              setState(() {
                                _rating=5.0;
                              });
                              Navigator.pop(context);
                              mySnackBar(LocaleKeys.ratingSentSuccessfully.tr(), Colors.green);
                            }),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            );
          });
    }

    //SEND US YOUR FEEDBACK BUTTON
    Widget rateUsWidget = InkWell(
      onTap: () {ratingBottomSheet();},
      child: Container(
          height: MediaQuery.of(context).size.height * 0.07,
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFD5D5D5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(CupertinoIcons.star_fill),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    LocaleKeys.rateUs.tr(),
                    style: GoogleFonts.ptSans(),
                  ),
                ],
              ),
              IconButton(onPressed: () {}, icon: _arrowIcon())
            ],
          )),
    );

    //LEAVE APP BUTTON
    Widget leaveAppWidget = InkWell(
      onTap: () {
        customConfirmationCoolAlert(context, LocaleKeys.leaveApp.tr(), LocaleKeys.areYouSureYouWantToLeaveApp.tr(), "assets/lottie/sad-dog.json", () => exit(0));
      },
      child: Container(
          height: MediaQuery.of(context).size.height * 0.07,
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFD5D5D5)),
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              const Icon(
                EvaIcons.logOut,
                color: Colors.red,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(LocaleKeys.leaveApp.tr(),
                  style: GoogleFonts.ptSans(
                    textStyle: const TextStyle(
                      color: Colors.red,
                    ),
                  )),
            ],
          )),
    );

    //LOGOUT BUTTON
    Widget logoutWidget = InkWell(
      onTap: () {
        customConfirmationCoolAlert(
            context,
            LocaleKeys.logout.tr(),
            LocaleKeys.areYouSureYouWantToLogout.tr(),
            "assets/lottie/sad-dog.json", () {
              context.read<FirebaseAuthServices>().signOut(context);
        });
      },
      child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.08,
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFD5D5D5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(EvaIcons.power, color: Colors.white),
              const SizedBox(
                width: 10,
              ),
              Text(LocaleKeys.logout.tr(),
                  style: GoogleFonts.ptSans(
                    textStyle: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  )),
            ],
          )),
    );

    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: MyAppBar(implyLeading: true, title: LocaleKeys.settings.tr(), action: Container(),),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 600,
            ),
            child: Column(
              children: [
                themeWidget,
                languageWidget,
                editProfileWidget,
                videosLikedWidget,
                aboutUsWidget,
                contactUsWidget,
                rateUsWidget,
                leaveAppWidget,
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 600,
          ),
          child: logoutWidget),
    );
  }
}

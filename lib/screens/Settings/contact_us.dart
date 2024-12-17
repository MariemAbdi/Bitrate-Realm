import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bitrate_realm/config/utils.dart';
import 'package:bitrate_realm/config/app_style.dart';
import 'package:bitrate_realm/widgets/my_appbar.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../../providers/auth_provider.dart';
import '../../services/firebase_auth_services.dart';
import '../../translations/locale_keys.g.dart';
import '../../widgets/input/custom_text_field.dart';
import '../../widgets/input/multi_line_field.dart';
import '../../widgets/utils/custom_button.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _subject = TextEditingController();
  final TextEditingController _body = TextEditingController();


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
        "subject": _subject.text.trim(),
        "email": Provider.of<AuthProvider>(context).user!.email,//context.read<FirebaseAuthServices>().user.email,
        "message": _body.text.trim(),
      },
    }));
    return response.statusCode;
  }
  
  // This function is triggered when the copy icon is pressed
  Future<void> _copyToClipboard(String toCopy) async {
    await Clipboard.setData(ClipboardData(text: toCopy));

    if (!mounted) return;
    mySnackBar(LocaleKeys.copiedToClipboard.tr(), Colors.orangeAccent);
  }

  Future<void> launchPhoneDialer(String contactNumber) async {
    try {
      await launchUrl(Uri(
          scheme: "tel",
          path: contactNumber
      ));
    } catch (error) {
      throw("Cannot dial");
    }
  }

  @override
  void dispose() {
    _subject.dispose();
    _body.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(implyLeading: true, title: LocaleKeys.contactUs.tr(), action: Container()),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 600,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [

                    //--------------------------------LOTTIE ASSET--------------------------------
                    Lottie.asset("assets/lottie/contact-us.json"),

                    //--------------------------------CALL US || EMAIL US BUTTONS--------------------------------
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      width: 230,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          cardWidget(LocaleKeys.callUs.tr(), Icons.phone, Colors.green, ()async{
                            final Uri url= Uri(scheme: 'tel', path: "+216 23 456 789");
                            await launchUrl(url);
                          }),

                          cardWidget(LocaleKeys.emailUs.tr(), Icons.email, Colors.orange, (){
                            emailBottomSheet();
                          }),
                        ],
                      ),
                    ),

                    //--------------------------------INFORMATION--------------------------------
                    ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                     children: [
                       listRow(LocaleKeys.phone.tr(),"+216 23 456 789", Icons.phone_android),
                       listRow(LocaleKeys.fax.tr(),"+216 79 456 789", Icons.fax),
                       listRow(LocaleKeys.email.tr(),"bitrate.realm@isetr.tn", Icons.email),
                       listRow(LocaleKeys.address.tr(),"ISET RADES", Icons.map),
                     ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //LIST TILE WIDGET FOR MORE INFORMATION
  listRow(String title,String subtitle, IconData icon){
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          minLeadingWidth: 10,
          leading: SizedBox(
              height: double.infinity,
              child: Icon(icon, color: MyThemes.primaryLight)),
          title: Text(title, style: GoogleFonts.ptSans(fontWeight: FontWeight.w700, color: MyThemes.primaryLight),),
          subtitle: Text(subtitle, style: GoogleFonts.ptSans(fontWeight: FontWeight.w500, color: Colors.grey.shade600,),),
          trailing: IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () { _copyToClipboard(subtitle); },

          ),
        ),
      ),
    );
  }
  
  //CARD WIDGET FOR CALL US | EMAIL US
  cardWidget(String title, IconData icon,Color color, VoidCallback function){
    return InkWell(
      onTap: function,
      child: Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color
                ),
                padding: const EdgeInsets.all(10.0),
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(height: 10,),
              Text(title, style: GoogleFonts.ptSans(fontWeight: FontWeight.w800, color: MyThemes.primaryLight, fontSize: 16),)
            ],
          ),
        ),
      ),
    );

  }

  //BOTTOM SHEET TO SEND AN EMAIL
  emailBottomSheet(){
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20)
          )
        ),
        builder: (context){
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 1.0,
        builder: (_, controller){
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: ListView(
              padding: const EdgeInsets.only(right: 10.0, left: 10.0, bottom: 20.0, top: 15.0),
              controller: controller,
              children: [

               Form(
                   key: _formKey,
                   child: Column(children: [
                 Text(LocaleKeys.sendEmail.tr(), style: GoogleFonts.ptSans(fontSize:18,fontWeight: FontWeight.w700, color: MyThemes.primaryLight),),
                 const SizedBox(height: 20,),

                 CustomTextField(controller: _subject, label: LocaleKeys.emailSubject.tr(), hint: LocaleKeys.enterSubject.tr(), errorMessage: LocaleKeys.subjectCantBeEmpty.tr()),
                 const SizedBox(height: 15),

                 MultilineField(controller: _body, label: LocaleKeys.emailBody.tr(), hint: LocaleKeys.enterBody.tr()),
               ],)),

                const SizedBox(height: 25),
                CustomButton(text: LocaleKeys.send.tr(), onPressed: ()async{

                  if (_formKey.currentState?.validate() ?? false){
                    sendEmail();
                    _subject.clear();
                    _body.clear();
                  }
                }),
              ],
            ),
          );
        },
      );
    });
  }
}

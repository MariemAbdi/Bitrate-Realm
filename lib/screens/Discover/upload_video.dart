import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:language_picker/language_picker_dialog.dart';
import 'package:language_picker/languages.dart';
import 'package:livestream/translations/locale_keys.g.dart';

import '../../services/livestream_services.dart';
import '../../widgets/input/custom_text_field.dart';
import '../../widgets/input/multi_line_field.dart';
import '../../widgets/my_appbar.dart';
import '../../models/live_stream.dart';
import '../../services/firebase_storage_services.dart';
import '../../config/utils.dart';
import '../../config/app_style.dart';
import '../../widgets/utils/custom_button.dart';

class UploadVideoScreen extends StatefulWidget {
  const UploadVideoScreen({Key? key}) : super(key: key);

  @override
  State<UploadVideoScreen> createState() => _UploadVideoScreenState();
}

class _UploadVideoScreenState extends State<UploadVideoScreen> {
  FirebaseStorageServices storage= FirebaseStorageServices();

  String fileName="";
  String _dropdownValue = "Gaming";


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  Uint8List? image; // IF WE USE FILE TYPE INSTEAD THEN WE WON'T BE ABLE TO USE IT ON WEB
  Uint8List? video; // IF WE USE FILE TYPE INSTEAD THEN WE WON'T BE ABLE TO USE IT ON WEB

  late Language _selectedDialogLanguage = Languages.abkhazian;

  List<String> tags = []; // List to store the tags

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    tags.clear();
    super.dispose();
  }


  void _openLanguagePickerDialog() => showDialog(
    context: context,
    builder: (context) => Theme(
        data: Theme.of(context).copyWith(primaryColor: Colors.pink),
        child: LanguagePickerDialog(
            titlePadding: const EdgeInsets.all(8.0),
            searchCursorColor: Colors.pinkAccent,
            searchInputDecoration:
            InputDecoration(hintText: LocaleKeys.search.tr()),
            isSearchable: true,
            title: Text(LocaleKeys.selectLanguage.tr()),
            onValuePicked: (Language language) => setState(() {
              _selectedDialogLanguage = language;
            }),
            itemBuilder: _buildDialogItem)),
  );

  // It's sample code of Dialog Item.
  Widget _buildDialogItem(Language language) => Row(
    children: <Widget>[
      Text(language.name),
      const SizedBox(width: 8.0),
      Flexible(child: Text("(${language.isoCode})"))
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(implyLeading: true, title: LocaleKeys.upload.tr(), action: Container()),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 600,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            Uint8List? pickedImage = await pickFile(context, FileType.image);
                            if (pickedImage != null) {
                              setState(() {
                                image = pickedImage;
                              });
                            }
                          },
                          onLongPress: () {
                            setState(() {
                              image = null;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5, left: 5),
                            child: image != null
                                ? Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                  color: MyThemes.primaryLight.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: MemoryImage(image!),
                                      fit: BoxFit.cover)),
                            )
                                : DottedBorder(
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(10),
                                dashPattern: const [10, 4],
                                color: MyThemes.primaryLight,
                                strokeCap: StrokeCap.round,
                                child: Container(
                                  width: double.infinity,
                                  height: 200,
                                  decoration: BoxDecoration(
                                      color:
                                      MyThemes.primaryLight.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.folder_open,
                                        color: MyThemes.primaryLight,
                                        size: 40,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(LocaleKeys.selectThumbnail.tr(),
                                          style: GoogleFonts.ptSans(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                  Colors.grey.shade400))),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () async {
                            Uint8List? pickedVideo = await pickFile(context, FileType.video);
                            if (pickedVideo != null) {
                              setState(() {
                                video = pickedVideo;
                              });
                            }
                          },
                          onLongPress: () {
                            setState(() {
                              video = null;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5, left: 5),
                            child: DottedBorder(
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(10),
                                dashPattern: const [10, 4],
                                color: MyThemes.primaryLight,
                                strokeCap: StrokeCap.round,
                                child: Container(
                                  width: double.infinity,
                                  height: 80,
                                  decoration: BoxDecoration(
                                      color:
                                      MyThemes.primaryLight.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.video_call_sharp,
                                        color: MyThemes.primaryLight,
                                        size: 40,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(video==null?LocaleKeys.selectVideo.tr():LocaleKeys.videoSelected.tr(),
                                          style: GoogleFonts.ptSans(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                  Colors.grey.shade400))),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(LocaleKeys.videoInfo.tr(),
                                        style: GoogleFonts.ptSans(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold)),

                                    const SizedBox(
                                      height: 15,
                                    ),

                                    //TITLE FIELD
                                    CustomTextField(
                                      controller: _titleController,
                                      label: LocaleKeys.title.tr(),
                                      hint: LocaleKeys.enterLiveInfo.tr(),
                                      errorMessage: LocaleKeys.enterLiveInfo.tr(),
                                    ),

                                    const SizedBox(
                                      height: 10,
                                    ),

                                    //DESCRIPTION FIELD
                                    MultilineField(
                                        controller: _descriptionController,
                                        label: LocaleKeys.description.tr(),
                                        hint: LocaleKeys.enterDescription.tr()),

                                    const SizedBox(
                                      height: 10,
                                    ),

                                    TextFormField(
                                        onTap: _openLanguagePickerDialog,
                                        readOnly: true,
                                        enableInteractiveSelection: false,
                                        focusNode: FocusNode(),
                                        decoration: InputDecoration(
                                          labelText:
                                          "${_selectedDialogLanguage.name}(${_selectedDialogLanguage.isoCode})",
                                          prefixIcon: const Icon(Icons.language),
                                          border: const OutlineInputBorder(),
                                        )),

                                    const SizedBox(
                                      height: 10,
                                    ),

                                    DropdownButtonFormField(
                                        icon: const Icon(Icons.keyboard_arrow_down),
                                        value: _dropdownValue,
                                        items: <String>['Gaming', 'Tutorial', 'Vlog']
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
                                          });
                                        }),

                                    const SizedBox(
                                      height: 10,
                                    ),

                                    Wrap(
                                      spacing: 8.0, // Space between tags
                                      runSpacing: 4.0, // Space between lines
                                      children: [
                                        InputChip(
                                          label: Text(LocaleKeys.addTag.tr()),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                String newTag = "";
                                                return AlertDialog(
                                                  actionsAlignment:
                                                  MainAxisAlignment.start,
                                                  title: Text(
                                                    LocaleKeys.addTag.tr(),
                                                    style:
                                                    GoogleFonts.poppins(),
                                                  ),
                                                  content: TextFormField(
                                                    onChanged: (value) {
                                                      newTag = value;
                                                    },
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      child: Text(
                                                        LocaleKeys.done.tr(),
                                                        style: GoogleFonts
                                                            .poppins(),
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          tags.add(newTag);
                                                        });
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text(
                                                        LocaleKeys.cancel.tr(),
                                                        style:
                                                        GoogleFonts.poppins(
                                                            color:
                                                            Colors.red),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ] +
                                          tags.map((tag) {
                                            return InputChip(
                                              label: Text(tag),
                                              onDeleted: () {
                                                setState(() {
                                                  tags.remove(tag);
                                                });
                                              },
                                            );
                                          }).toList(),
                                    ),

                                    const SizedBox(
                                      height: 20,
                                    ),

                                    //BUTTON
                                    CustomButton(
                                      text: LocaleKeys.upload.tr(),
                                      onPressed: () async {
                                        if (_formKey.currentState?.validate() ??
                                            false) {
                                          //CHECK IF THUMBNAIL PHOTO EXISTS
                                          if (image == null) {
                                            mySnackBar(
                                                LocaleKeys.pleaseSelectAThumbnail.tr(),
                                                Colors.red);
                                          }else if (video == null) {
                                            mySnackBar(
                                                LocaleKeys.pleaseSelectAVideo.tr(),
                                                Colors.red);
                                          } else {

                                            //CREATE VIDEO AND UPLOAD IT
                                            LiveStream newVideo = LiveStream(
                                                title: _titleController.text.trim(),
                                                description: _descriptionController.text.trim(),
                                                language: "${_selectedDialogLanguage.name}(${_selectedDialogLanguage.isoCode})",
                                                tags: tags,
                                                category: _dropdownValue,
                                              thumbnail: image,
                                              video: video
                                            );
                                            await LiveStreamServices().uploadVideo(newVideo);

                                            setState(() {
                                              _titleController.clear();
                                              _descriptionController.clear();
                                              tags.clear();
                                              _selectedDialogLanguage = Languages.abkhazian;
                                              _dropdownValue = "Gaming";
                                              image=null;
                                              video=null;
                                            });


                                          }
                                        }
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
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
}

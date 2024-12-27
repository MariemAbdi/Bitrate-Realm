import 'dart:typed_data';

import 'package:bitrate_realm/services/firebase_auth_services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../models/live_stream.dart';
import '../../services/livestream_services.dart';
import '../../translations/locale_keys.g.dart';
import '../../config/utils.dart';
import '../../widgets/live/go_live_thumbnail.dart';
import '../../widgets/utils/custom_app_bar.dart';
import '../../constants/spacing.dart';
import '../../models/category.dart';
import '../../widgets/live/go_live_form.dart';
class GoLiveScreen extends StatefulWidget {
  const GoLiveScreen({Key? key}) : super(key: key);

  @override
  State<GoLiveScreen> createState() => _GoLiveScreenState();
}

class _GoLiveScreenState extends State<GoLiveScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController, _descriptionController;
  Uint8List? _pickedThumbnail; // IF WE USE FILE TYPE INSTEAD THEN WE WON'T BE ABLE TO USE IT ON WEB
  Category? _selectedCategory;
  final List<String> _selectedTags = []; // List to store the tags

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  _launchLive() async {
    if (_formKey.currentState?.validate() ?? false) {
      //CHECK IF THUMBNAIL PHOTO EXISTS
      if (_pickedThumbnail == null) {
        showToast(toastType: ToastType.error, message: LocaleKeys.pleaseSelectAThumbnail.tr());
      } else {
        //CREATE LIVE AND LAUNCH IT
        LiveStream liveStream = LiveStream(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          tags: _selectedTags,
          category: _selectedCategory?.id ?? "",
          streamer: FirebaseAuthServices().user!.email!,
          thumbnail: _pickedThumbnail,
        );
        await LiveStreamServices().startLiveStream(liveStream);
      }
    }
  }

  _selectThumbnail() async {
    Uint8List? pickedImage = await pickFile(FileType.image);
    if (pickedImage != null) {
      setState(() {
        _pickedThumbnail = pickedImage;
      });
    }
  }

  _updateCategory(Category? category){
    setState(() {
      _selectedCategory = category!;
    });
  }

  addTag(String tag){
    setState(() {
      _selectedTags.add(tag);
    });
  }

  removeTag(String tag){
    setState(() {
      _selectedTags.remove(tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: CustomAppBar(title: LocaleKeys.startLive.tr(), canGoBack: false),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20,20,20,100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GoLiveThumbnail(
                  pickedThumbnail: _pickedThumbnail,
                  selectThumbnail: _selectThumbnail,
                ),
                kVerticalSpace,

                GoLiveForm(
                  formKey: _formKey,
                  titleController: _titleController,
                  descriptionController: _descriptionController,
                  selectedCategory: _selectedCategory,
                  selectedTags: _selectedTags,
                  updateCategory: _updateCategory,
                  addTag: addTag,
                  removeTag: removeTag,
                  submitForm: _launchLive,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:bitrate_realm/config/validators.dart';
import 'package:bitrate_realm/models/category.dart';
import 'package:bitrate_realm/widgets/input/category_dropdown.dart';
import 'package:bitrate_realm/widgets/input/tags_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

import '../../constants/spacing.dart';
import '../../translations/locale_keys.g.dart';
import '../input/custom_text_field.dart';
import '../input/multi_line_field.dart';
import '../utils/custom_button.dart';

class GoLiveForm extends StatelessWidget {
  const GoLiveForm({Key? key, required this.formKey, required this.titleController, required this.descriptionController, this.submitForm, required this.selectedCategory, this.updateCategory, required this.selectedTags, required this.addTag, required this.removeTag}) : super(key: key);

  final GlobalKey<FormState> formKey;
  final TextEditingController titleController, descriptionController;
  final Category? selectedCategory;
  final List<String> selectedTags;
  final void Function()? submitForm;
  final void Function(Category?)? updateCategory;
  final void Function(String) addTag, removeTag;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(LocaleKeys.liveInfo.tr(), style: context.textTheme.bodyLarge),
          kVerticalSpace,

          //TITLE FIELD
          CustomTextField(
            controller: titleController,
            label: LocaleKeys.title.tr(),
            hint: LocaleKeys.enterLiveInfo.tr(),
            errorMessage: LocaleKeys.enterLiveInfo.tr(),
          ),
          kSmallVerticalSpace,

          //DESCRIPTION FIELD
          MultilineField(
              validator: Validators().defaultValidation,
              controller: descriptionController,
              label: LocaleKeys.description.tr(),
              hint: LocaleKeys.enterDescription.tr()
          ),
          kSmallVerticalSpace,

          CategoryDropdown(
            selectedCategory: selectedCategory,
            onChanged: updateCategory,
          ),
          kSmallVerticalSpace,

          TagsField(
            selectedTags: selectedTags,
            addTag: addTag,
            removeTag: removeTag,
          ),
          kVerticalSpace,

          //BUTTON
          CustomButton(
              isUppercase: true,
              text: LocaleKeys.startLive.tr(),
              onPressed: submitForm
          )
        ],
      ),
    );
  }
}

import 'package:bitrate_realm/constants/spacing.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

import '../../translations/locale_keys.g.dart';

class TagsField extends StatefulWidget {
  const TagsField({
    Key? key,
    required this.selectedTags,
    required this.addTag,
    required this.removeTag,
  }) : super(key: key);

  final List<String> selectedTags;
  final void Function(String) addTag, removeTag;

  @override
  State<TagsField> createState() => _TagsFieldState();
}

class _TagsFieldState extends State<TagsField> {
  final TextEditingController _controller = TextEditingController();

  void _addTag() {
    final newTag = _controller.text.trim();
    if (newTag.isNotEmpty && !widget.selectedTags.contains(newTag)) {
      widget.addTag(newTag);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          style: context.textTheme.headlineSmall,
          controller: _controller,
          decoration: InputDecoration(
            labelText: LocaleKeys.addTag.tr(),
            hintText: LocaleKeys.addTag.tr(),
            prefixIcon: const Icon(Icons.tag),
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addTag,
            ),
          ),
          onSubmitted: (_) => _addTag(),
        ),
        kSmallVerticalSpace,

        Wrap(
          spacing: 8, // Space between tags
          runSpacing: 4, // Space between lines
          children: widget.selectedTags.map((tag) {
            return InputChip(
              label: Text(tag),
              onDeleted: () {
                widget.removeTag(tag);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:textfield_tags/textfield_tags.dart';

import '../../config/app_style.dart';
import '../../translations/locale_keys.g.dart';

class TagTextField extends StatefulWidget {
  final TextfieldTagsController controller;
  const TagTextField({Key? key, required this.controller}) : super(key: key);

  @override
  State<TagTextField> createState() => _TagTextFieldState();
}

class _TagTextFieldState extends State<TagTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFieldTags(
      textfieldTagsController: widget.controller,
      textSeparators: const [' '],
      letterCase: LetterCase.normal,
      inputfieldBuilder: (context, tec, fn, error, onChanged, onSubmitted) {
        return ((context, controller, tags, onTagDelete) {
          return TextFormField(
            validator: (tag) {
             if (widget.controller.getTags!.contains(tag)) {
                return LocaleKeys.tagAlreadyEntered.tr();
              }
              return null;
            },
            controller: tec,
            focusNode: fn,
            maxLines: null,
            style: context.textTheme.headlineSmall,
            decoration: InputDecoration(
             // prefixIcon: const Icon(Icons.numbers),
              isDense: true,
              border: const OutlineInputBorder(),
              hintText: LocaleKeys.tags.tr(),
              errorText: error,

              suffixIcon: !widget.controller.hasTags
                  ? null
                  : IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  widget.controller.clearTags();
                  setState(() {});
                },
              ),
              prefixIconConstraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width *0.74, maxHeight: 50),
              prefixIcon: tags.isNotEmpty
                  ? SingleChildScrollView(
                controller: controller,
                scrollDirection: Axis.horizontal,
                child: Row(
                    children: tags.map((String tag) {
                      //THE CONTAINER OF THE ADDED WORDS
                      return Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                          color: MyThemes.primaryColor,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              child: Text(
                                tag,
                                style: const TextStyle(color: Colors.white),
                              ),
                              onTap: () {
                                debugPrint("$tag selected");
                              },
                            ),
                            const SizedBox(width: 4.0),
                            InkWell(
                              child: const Icon(
                                Icons.cancel,
                                size: 14.0,
                                color: Color.fromARGB(255, 233, 233, 233),
                              ),
                              onTap: () {
                                onTagDelete(tag);
                              },
                            )
                          ],
                        ),
                      );
                    }).toList()),
              )
                  : null,
            ),
            //NEEDED TO ADD TAGS IN THE FIELD
            onChanged: onChanged,
            //onSubmitted: onSubmitted,
          );
        });
      },
    );
  }
}

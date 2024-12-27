import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

import '../../config/validators.dart';
import '../../translations/locale_keys.g.dart';

class SendInput extends StatefulWidget {
  const SendInput({Key? key, required this.controller, this.onConfirm, this.clearAfter = false}) : super(key: key);

  final TextEditingController controller;
  final bool clearAfter;
  final void Function(String)? onConfirm;

  @override
  State<SendInput> createState() => SendInputState();
}

class SendInputState extends State<SendInput> {
  final FocusNode _focusNode = FocusNode();

  void _submitText() {
    String trimmedText = widget.controller.text.trim();

    // Only call onConfirm if the text is not empty
    if (trimmedText.isNotEmpty) {
      widget.onConfirm?.call(trimmedText);
    }

    // Clear the text field if clearAfter is true
    if (widget.clearAfter) {
      _clearField();
    }

    // Request focus back to the TextField
    _focusNode.requestFocus();
  }

  void _clearField() {
    widget.controller.clear();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        validator: Validators().defaultValidation,
        controller: widget.controller,
        focusNode: _focusNode,
        keyboardType: TextInputType.text,
        style: context.textTheme.headlineSmall,
        decoration: InputDecoration(
          hintText: LocaleKeys.search.tr(),
          suffixIcon: IconButton(
              icon: Icon(widget.clearAfter ? Icons.send : Icons.search, color: Colors.white),
              onPressed: _submitText
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(10)),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(10)),
        ),
        onFieldSubmitted: (_)=>_submitText(),
      ),
    );
  }
}

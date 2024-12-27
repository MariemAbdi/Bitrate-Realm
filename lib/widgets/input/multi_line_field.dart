import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MultilineField extends StatefulWidget {
  final TextEditingController controller;
  final String label, hint;

  final String? Function(String?)? validator;
  const MultilineField({Key? key, required this.controller, required this.label, required this.hint, this.validator}) : super(key: key);

  @override
  State<MultilineField> createState() => _MultilineFieldState();
}

class _MultilineFieldState extends State<MultilineField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      controller: widget.controller,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      style: context.textTheme.headlineSmall,
      decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          prefixIcon: const Icon(Icons.abc),
          border: const OutlineInputBorder(),
          suffixIcon: widget.controller.text.isEmpty
              ? null
              : IconButton(
            icon: const Icon(Icons.close, size: 14),
            onPressed: () {
              setState(() {
                widget.controller.clear();
              });
            },
          )),
      onChanged: (value) {
        setState(() {});
      },
    );
  }
}

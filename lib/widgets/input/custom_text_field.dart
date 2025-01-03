import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String errorMessage;
  const CustomTextField({Key? key, required this.controller, required this.label, required this.hint, required this.errorMessage}) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (title) {
        if (title!.isEmpty) {
          return widget.errorMessage;
        }
        return null;
      },
      controller: widget.controller,
      keyboardType: TextInputType.text,
      style: context.textTheme.headlineSmall,
      decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          prefixIcon: const Icon(Icons.abc),
          border: const OutlineInputBorder(),
          suffixIcon: widget.controller.text.isEmpty
              ? null
              : IconButton(
            icon: const Icon(Icons.close, size: 16),
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

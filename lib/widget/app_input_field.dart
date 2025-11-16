import 'package:flutter/material.dart';
class AppInputField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final TextInputType textInputType;
  const AppInputField({
    required this.controller,
    required this.labelText,
    required this.textInputType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: textInputType,
      decoration: InputDecoration(
          hintText: labelText,
          label: Text(labelText),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.greenAccent)
          )
      ),
    );
  }
}

import 'package:flutter/material.dart';
class AppInputField extends StatelessWidget {
  final String labelText;//stsring nise pass korse labeltext e
  final TextEditingController controller;//controller pass korse user input nite
  final TextInputType textInputType;//textinput user theke nite
  const AppInputField({
    required this.controller,//declear
    required this.labelText,//declear
    required this.textInputType,//delclear
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,//user input
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

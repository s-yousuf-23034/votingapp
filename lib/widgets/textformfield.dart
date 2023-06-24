import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final Icon icon;
  final bool value;
  final String hinttext;
  final String labeltext;
  final Color color;
  final TextInputType type;
  final TextInputAction action;
  final TextEditingController controller;
  MyTextField(
      {required this.icon,
      required this.value,
      required this.hinttext,
      required this.labeltext,
      required this.color,
      required this.type,
      required this.action,
      required this.controller, String? errorText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: value,
      decoration: InputDecoration(
        prefixIcon: icon,
        hintText: hinttext,
        labelText: labeltext,
        labelStyle: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      keyboardType: type,
      textInputAction: action,
    );
  }
}

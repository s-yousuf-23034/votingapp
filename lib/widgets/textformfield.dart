import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final Icon icon;
  final Widget? suffixIcon;
  final bool value;
  final String hinttext;
  final String labeltext;
  final String prefixText;
  final Color color;
  final TextInputType type;
  final TextInputAction action;
  final TextEditingController controller;
  final String? errortext;
  const MyTextField({super.key, 
    required this.icon,
    required this.value,
    required this.hinttext,
    required this.labeltext,
    required this.color,
    required this.type,
    required this.action,
    required this.controller,
    this.errortext,
    required this.prefixText,
    required this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: value,
      decoration: InputDecoration(
        prefixIcon: icon,
        suffixIcon: suffixIcon,
        hintText: hinttext,
        labelText: labeltext,
        prefixText: prefixText,
        errorText: errortext,
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

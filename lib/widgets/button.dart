import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String buttonName;
  final Color color;
  final Color textcolor;
  final Function onPressed;
  const MyButton({super.key, 
    required this.buttonName,
    required this.color,
    required this.textcolor,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: TextButton.styleFrom(
        minimumSize: const Size(140, 45),
        backgroundColor: color,
        side: const BorderSide(color: Color.fromRGBO(85, 24, 93, 9), width: 2),
        shape: const StadiumBorder(),
      ),
      onPressed: onPressed as void Function()?,
      child: Text(
        buttonName,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: textcolor, fontSize: 18),
      ),
    );
  }
}

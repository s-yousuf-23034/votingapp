import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String buttonName;
  final Color color;
  final Color textcolor;
  final Function onPressed;
  MyButton({
    required this.buttonName,
    required this.color,
    required this.textcolor,
    required this.onPressed,
  });
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        buttonName,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: textcolor, fontSize: 18),
      ),
      style: TextButton.styleFrom(
        minimumSize: Size(140, 45),
        backgroundColor: color,
        side: BorderSide(color: Color.fromRGBO(85, 24, 93, 9), width: 2),
        shape: StadiumBorder(),
      ),
      onPressed: onPressed as void Function()?,
    );
  }
}

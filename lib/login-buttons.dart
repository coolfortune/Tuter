import 'package:flutter/material.dart';



class LoginButton extends StatelessWidget {
  LoginButton(
    {this.text, this.padding = 120.0, this.color = Colors.black, this.onPressed});

  final String text;
  final double padding;
  final Function onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      padding: EdgeInsets.symmetric(horizontal: padding),
      fillColor: color,
      elevation: 2.0,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          text,
          maxLines: 1,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
      shape: const StadiumBorder(),
      onPressed: onPressed,
    );
  }
}

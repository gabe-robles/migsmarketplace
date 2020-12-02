import 'package:flutter/material.dart';

class CustomRoundButton extends StatelessWidget {

  final String buttonTitle;
  final Color buttonColor;
  final double buttonWidth;
  final Function onPressed;

  const CustomRoundButton({
    @required this.buttonTitle,
    @required this.buttonColor,
    this.buttonWidth,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: buttonColor,
      borderRadius: BorderRadius.all(Radius.circular(30.0)),
      elevation: 5.0,
      child: MaterialButton(
        onPressed: onPressed,
        minWidth: buttonWidth,
        height: 44.0,
        child: Text(
          buttonTitle,
          style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}
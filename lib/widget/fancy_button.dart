import 'package:flutter/material.dart';

class FancyButton extends StatelessWidget {

  FancyButton({this.color, this.onPressed, this.child, this.textColor, this.elevation});

  final Color color;
  final Color textColor;
  final void Function() onPressed;
  final Widget child;
  final double elevation;

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: double.infinity,
      height: 55,
      child: Container(
        margin: EdgeInsets.only(right: 45, left: 45),
        child: RaisedButton(
          elevation: elevation,
          onPressed: onPressed,
          textColor: textColor,
          color: color,
          padding: EdgeInsets.all(8),
          child: child,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );

  }

}
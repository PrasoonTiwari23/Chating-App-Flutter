import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Color colour;
  final String text;
  final Function onpressedName;
  RoundedButton({this.colour, this.text, @required this.onpressedName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour, //Colors.lightBlueAccent,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onpressedName,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
            ),//'Log In',
          ),
        ),
      ),
    );
  }
}

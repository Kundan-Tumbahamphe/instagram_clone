import 'package:flutter/material.dart';

class CustomFlatButton extends StatelessWidget {
  final String buttonText;
  final Function onPressed;

  const CustomFlatButton({@required this.buttonText, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220.0,
      child: FlatButton(
        onPressed: onPressed,
        child: Text(
          '$buttonText',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        padding: const EdgeInsets.all(10.0),
        color: Colors.blue,
      ),
    );
  }
}

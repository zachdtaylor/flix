import 'package:flutter/material.dart';

class LoginErrorText extends StatelessWidget {
  final String text;
  final bool error;

  LoginErrorText({
    Key key,
    this.text,
    this.error
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16, left: 40, right: 40),
      width: MediaQuery.of(context).size.width,
      child: Text(
        error ? text : '',
        style: TextStyle(
          color: Colors.red,
          fontSize: 16
        )
      )
    );
  }

}

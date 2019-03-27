import 'package:flutter/material.dart';

class LoginLogo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        "FLIX",
        style: TextStyle(
          fontSize: 72,
          color: Theme.of(context).accentColor,
          fontWeight: FontWeight.bold
        )
      )
    );
  }
}

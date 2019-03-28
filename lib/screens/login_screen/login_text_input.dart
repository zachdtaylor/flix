import 'package:flutter/material.dart';

class LoginTextInput extends StatelessWidget {
  final String label;
  final String hint;
  final bool password;
  final Function onChanged;
  final bool error;

  LoginTextInput({
      Key key,
      this.label,
      this.hint,
      this.password=false,
      this.onChanged,
      this.error=false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: Text(
                    label.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: this.error ? Colors.red : Theme.of(context).accentColor,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 40.0, right: 40.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: this.error ? Colors.red : Theme.of(context).accentColor,
                  width: 0.5,
                  style: BorderStyle.solid),
              ),
            ),
            padding: const EdgeInsets.only(left: 0.0, right: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    obscureText: password,
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.black),
                    onChanged: onChanged,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hint,
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]
      )
    );
  }
}

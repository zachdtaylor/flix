import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final String text;
  final Function onPress;
  final Color backgroundColor;
  final Color textColor;
  final bool loading;

  LoginButton({
      Key key,
      this.text,
      this.onPress,
      this.backgroundColor,
      this.textColor=Colors.white,
      this.loading=false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        color: this.backgroundColor,
        borderRadius: BorderRadius.circular(30.0)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.085,
            child: FlatButton(
              onPressed: this.onPress,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 20.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: !loading ? Text(
                        this.text.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: this.textColor,
                          fontWeight: FontWeight.bold
                        )
                      ) :
                      SizedBox(
                        child: CircularProgressIndicator(strokeWidth: 3, valueColor: AlwaysStoppedAnimation<Color>(textColor)),
                        width: 20,
                      )
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

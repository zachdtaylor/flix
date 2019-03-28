import 'package:flutter/material.dart';
import 'login_button.dart';
import 'login_logo.dart';

class HomePage extends StatelessWidget {
  final Function onSignupPressed;
  final Function onLoginPressed;

  HomePage({
    Key key,
    this.onSignupPressed,
    this.onLoginPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
      ),
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Flexible(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                LoginLogo()
              ]
            ),
          ),
          Flexible(
            flex: 3,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  LoginButton(
                    text: 'Signup',
                    onPress: this.onSignupPressed,
                    backgroundColor: Colors.white,
                    textColor: Theme.of(context).accentColor,
                  ),
                  LoginButton(
                    text: 'Login',
                    onPress: this.onLoginPressed,
                    backgroundColor: Theme.of(context).accentColor,
                  ),
                ]
              )
            )
          )
        ]
      ),
    );
  }

}

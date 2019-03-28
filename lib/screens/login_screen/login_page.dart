import 'package:flutter/material.dart';
import 'login_text_input.dart';
import 'login_button.dart';
import 'login_logo.dart';

class LoginPage extends StatefulWidget {
  final Function onLogin;

  LoginPage({
    Key key,
    this.onLogin
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  String _username;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget> [
                LoginTextInput(
                  label: 'Email Address',
                  hint: 'example@email.com',
                  onChanged: (value) => {
                    setState(() {
                      _username = value;
                    })
                  }
                ),
                LoginTextInput(
                  label: 'Password',
                  hint: 'password',
                  password: true,
                  onChanged: (value) => {
                    setState(() {
                      _password = value;
                    })
                  }
                ),
                Container(
                  margin: EdgeInsets.only(top: 32),
                  child: LoginButton(
                    text: 'Login',
                    backgroundColor: Theme.of(context).accentColor,
                    onPress: () {
                      print("<<<<<<<<<<<<< login pressed <<<<<<<<<<<<<<<");
                      widget.onLogin(username: _username, password: _password)
                      .then((val) => print("<<<<<<<<<<<<< login: $val <<<<<<<<<<<<"));
                    }
                  )
                )
              ]
            )
          ),
        ]
      )
    );
  }
}
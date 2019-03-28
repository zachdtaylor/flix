import 'package:flutter/material.dart';
import 'login_text_input.dart';
import 'login_button.dart';
import 'login_logo.dart';
import 'login_error_text.dart';

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
  String _username = "";
  String _password = "";
  bool _error = false;
  String _errorMessage = "";

  _loginPressed() async {
    if (_username == "" || _password == ""){
      setState(() {
        _error = true;
        _errorMessage = "All fields are required";
      });
      return;
    }
    bool success = await widget.onLogin(username: _username, password: _password);
    if (!success){
      setState(() {
        _error = true;
        _errorMessage = "Invalid username or password";
      });
    }
  }

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
                  error: _error,
                  onChanged: (value) => {
                    setState(() {
                      _error = false;
                      _username = value;
                    })
                  }
                ),
                LoginTextInput(
                  label: 'Password',
                  hint: 'password',
                  password: true,
                  error: _error,
                  onChanged: (value) => {
                    setState(() {
                      _error = false;
                      _password = value;
                    })
                  }
                ),
                LoginErrorText(text: _errorMessage, error: _error),
                Container(
                  margin: EdgeInsets.only(top: 32),
                  child: LoginButton(
                    text: 'Login',
                    backgroundColor: Theme.of(context).accentColor,
                    onPress: () => { _loginPressed() }
                  )
                )
              ]
            ),
          ),
        ]
      )
    );
  }
}
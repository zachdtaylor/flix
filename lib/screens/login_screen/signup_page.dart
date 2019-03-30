import 'package:flutter/material.dart';
import 'login_text_input.dart';
import 'login_button.dart';
import 'login_logo.dart';
import 'login_error_text.dart';

class SignupPage extends StatefulWidget {
  final Function onSignup;

  SignupPage({
    Key key,
    this.onSignup
  }) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>{
  String _name = "";
  String _email = "";
  String _password = "";
  bool _loading = false;
  bool _error = false;
  String _errorMessage = "";
  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();

  _signupPressed() async {
    if (_name == "" || _email == "" || _password == ""){
      setState(() {
        _error = true;
        _errorMessage = "All fields are required";
      });
      return;
    }

    setState(() {
      _loading = true;
    });
    bool success = await widget.onSignup(name: _name, email: _email, password: _password);
    setState(() {
      _loading = false;
    });

    if (!success){
      setState(() {
        _error = true;
        _errorMessage = "Failed to create account - Contact Support";
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
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                LoginLogo()
              ]
            ),
          ),
          Flexible(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget> [
                LoginTextInput(
                  label: 'Your Name',
                  hint: 'First Last',
                  autofocus: true,
                  onEditingComplete: () => FocusScope.of(context).requestFocus(emailNode),
                  error: _error,
                  onChanged: (value) => {
                    setState(() {
                      _error = false;
                      _name = value;
                    })
                  }
                ),
                LoginTextInput(
                  label: 'Email Address',
                  hint: 'example@email.com',
                  focus: emailNode,
                  onEditingComplete: () => FocusScope.of(context).requestFocus(passwordNode),
                  error: _error,
                  onChanged: (value) => {
                    setState(() {
                      _error = false;
                      _email = value;
                    })
                  }
                ),
                LoginTextInput(
                  label: 'Password',
                  hint: 'password',
                  focus: passwordNode,
                  onEditingComplete: _signupPressed,
                  action: TextInputAction.done,
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
                    text: 'Signup',
                    loading: _loading,
                    backgroundColor: Theme.of(context).accentColor,
                    onPress: () => { _signupPressed() }
                  )
                )
              ]
            )
          )
        ]
      )
    );
  }
}

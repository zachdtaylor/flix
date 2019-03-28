import 'package:flutter/material.dart';
import 'login_text_input.dart';
import 'login_button.dart';
import 'login_logo.dart';

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
  String _name;
  String _email;
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
                  onChanged: (value) => {
                    setState(() {
                      _name = value;
                    })
                  }
                ),
                LoginTextInput(
                  label: 'Email Address',
                  hint: 'example@email.com',
                  onChanged: (value) => {
                    setState(() {
                      _email = value;
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
                    text: 'Signup',
                    backgroundColor: Theme.of(context).accentColor,
                    onPress: () => widget.onSignup(name: _name, email: _email, password: _password)
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

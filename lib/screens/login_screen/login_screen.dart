import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'signup_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  Future<bool> _login({String username, String password}) async {
    QueryResult result = await GraphQLProvider.of(context).value.mutate (
      MutationOptions(
        document: await rootBundle.loadString('graphql/users/mutations/login.gql'),
        variables: {
          'username': username,
          'password': password
        }
      )
    );
    if (result.errors != null && result.errors.length > 0) {
     return false;
    } else {
      Map<String, dynamic> data = result.data['tokenAuth'];
      if (data['token'] != null) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('auth_token', data['token']);
        Navigator.of(context).pushReplacementNamed('/home');
      }
    }
    return true;
  }

  Future<bool> _signup({String name, String email, String password}) async {
    QueryResult result = await GraphQLProvider.of(context).value.mutate(
      MutationOptions(
        document: await rootBundle.loadString('graphql/users/mutations/signup.gql'),
        variables: {
          'name': name,
          'email': email,
          'password': password
        }
      )
    );
    if (result.errors != null && result.errors.length > 0) {
      return false;
    } else {
     return await _login(username: email, password: password);
    }
  }

  _gotoLogin() {
    _controller.animateToPage(
      0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  _gotoSignup() {
    _controller.animateToPage(
      2,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  PageController _controller = PageController(initialPage: 1, viewportFraction: 1.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        body: PageView(
          controller: _controller,
          physics: AlwaysScrollableScrollPhysics(),
          children: <Widget>[
            SingleChildScrollView(
              child: LoginPage(
                onLogin: _login,
              )
            ),
            HomePage(
              onSignupPressed: _gotoSignup,
              onLoginPressed: _gotoLogin
            ),
            SingleChildScrollView(
              child: SignupPage(
                onSignup: _signup,
              )
            ),
          ],
          scrollDirection: Axis.horizontal,
      ))
    );
  }
}

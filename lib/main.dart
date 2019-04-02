import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
import 'package:flix_list/screens/login_screen/login_screen.dart';
import 'package:flix_list/screens/movie_search_screen/movie_search_screen.dart';
import 'package:flix_list/screens/user_search_screen/user_search_screen.dart';
import 'package:flutter/services.dart';

void main() async {
  Widget _homeScreen = LoginScreen();
  bool loggedIn = (await SharedPreferences.getInstance()).getString('auth_token') != null;
  if (loggedIn) {
    _homeScreen = Home();
  }
  runApp(MyApp(home: _homeScreen));
}

class MyApp extends StatelessWidget {
  final Widget home;

  MyApp({
    Key key,
    this.home,
  }) : super(key: key);

  final HttpLink httpLink = HttpLink(
    uri: 'https://flix-kdn.herokuapp.com/graphql',
  );

  final AuthLink authLink = AuthLink(
    getToken: (() async {
      String token = (await SharedPreferences.getInstance()).getString('auth_token');
      if (token != null) {
        return 'JWT ' + token;
      } else {
        return null;
      }
    })
  );

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    final Link link = authLink.concat(httpLink);

    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        cache: InMemoryCache(),
        link: link,
      ),
    );

    const Color primaryColor = Color(0xFF2B2B2B);//Color(0xFF204CA0);
    const Color secondaryColor = Color(0xFF6B727C);
    final ColorScheme colorScheme = const ColorScheme.dark().copyWith(
      primary: primaryColor,
      secondary: secondaryColor,
    );

    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        title: 'Flix',
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => Home(),
          '/login': (BuildContext context) => LoginScreen(),
          '/search/movies': (BuildContext context) => MovieSearchScreen(),
          '/search/users': (BuildContext context) => UserSearchScreen()
        },
        theme: ThemeData(
          brightness: Brightness.dark,
          accentColorBrightness: Brightness.dark,
          primaryColor: primaryColor,
          // primaryColorDark: const Color(0xFF0050a0),
          primaryColorLight: secondaryColor,
          buttonColor: primaryColor,
          indicatorColor: Colors.white,
          toggleableActiveColor: const Color(0xFF6997DF),
          accentColor: const Color(0xFF6997DF),
          // canvasColor: const Color(0xFF202124),
          scaffoldBackgroundColor: const Color(0xFF202124),
          backgroundColor: const Color(0xFF2B2B2B),
          errorColor: const Color(0xFFB00020),
          buttonTheme: ButtonThemeData(
            colorScheme: colorScheme,
            textTheme: ButtonTextTheme.primary,
          ),
        ),
        home: this.home,
        debugShowCheckedModeBanner: false
      )
    );
  }
}

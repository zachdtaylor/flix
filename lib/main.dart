import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  final HttpLink httpLink = HttpLink(
    uri: 'http://192.168.1.100:8000/graphql',
  );

  final AuthLink authLink = AuthLink(
    getToken: (() async => 'JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6ImthZGVuYmFybG93QGdtYWlsLmNvbSIsImV4cCI6MTU1MzM3MDY2Niwib3JpZ0lhdCI6MTU1MzM3MDM2Nn0.W3Y_7GssfjtLIoGvhmSewjFlbPxbM2AMPeRgsn_ILl4'),
  );

  @override
  Widget build(BuildContext context) {

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
        theme: ThemeData(
          brightness: Brightness.dark,
          accentColorBrightness: Brightness.dark,
          primaryColor: primaryColor,
          // primaryColorDark: const Color(0xFF0050a0),
          primaryColorLight: secondaryColor,
          buttonColor: primaryColor,
          indicatorColor: Colors.white,
          toggleableActiveColor: const Color(0xFF6997DF),
          accentColor: Color(0xFF204CA0),
          // canvasColor: const Color(0xFF202124),
          scaffoldBackgroundColor: const Color(0xFF202124),
          backgroundColor: const Color(0xFF2B2B2B),
          errorColor: const Color(0xFFB00020),
          buttonTheme: ButtonThemeData(
            colorScheme: colorScheme,
            textTheme: ButtonTextTheme.primary,
          ),
        ),
        home: Home(),
        debugShowCheckedModeBanner: false
      )
    );
  }
}

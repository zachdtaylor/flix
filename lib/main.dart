import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  final HttpLink httpLink = HttpLink(
    uri: 'https://api.github.com/graphql',
  );

  final AuthLink authLink = AuthLink(
    getToken: (() async => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>'),
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

    const Color primaryColor = Color(0xFF003F91);
    const Color secondaryColor = Color(0xFF6B727C);
    final ColorScheme colorScheme = const ColorScheme.dark().copyWith(
      primary: primaryColor,
      secondary: secondaryColor,
    );

    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        title: 'FlixList',
        theme: ThemeData(
          brightness: Brightness.dark,
          accentColorBrightness: Brightness.dark,
          primaryColor: primaryColor,
          // primaryColorDark: const Color(0xFF0050a0),
          primaryColorLight: secondaryColor,
          buttonColor: primaryColor,
          indicatorColor: Colors.white,
          // toggleableActiveColor: const Color(0xFF6997DF),
          accentColor: secondaryColor,
          // canvasColor: const Color(0xFF202124),
          scaffoldBackgroundColor: const Color(0xFF202124),
          backgroundColor: const Color(0xFF202124),
          errorColor: const Color(0xFFB00020),
          buttonTheme: ButtonThemeData(
            colorScheme: colorScheme,
            textTheme: ButtonTextTheme.primary,
          ),
        ),
        // home: InboxScreen(title: 'Minbox Demo'),
      )
    );
  }
}

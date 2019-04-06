import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flix_list/util/preferences.dart';
import 'dart:async';

abstract class GraphqlOperation {
  GraphqlOperation({@required String operation}) {
    this.operation = operation;
    this.client = createClient();
  }

  String operation;
  GraphQLClient client;

  static GraphQLClient createClient() {
    final HttpLink httpLink = HttpLink(
      uri: 'http://192.168.0.105:8000/graphql',
    );

    final AuthLink authLink = AuthLink(
      getToken: (() async {
          String token = await Preferences.getString('auth_token');
          if (token != null) {
            return 'JWT ' + token;
          } else {
            return null;
          }
      })
    );

    final Link link = authLink.concat(httpLink);

    return GraphQLClient(
      cache: InMemoryCache(),
      link: link
    );
  }

  Future<Map<String, dynamic>> execute({Map<String, dynamic> variables});
}

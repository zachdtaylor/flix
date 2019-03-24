import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';

class MovieSearchDelegate extends SearchDelegate {
  List<dynamic> _movies = [];
  ScrollController _controller;
  Timer _debounce;

  _search(BuildContext context, String searchText) async {
    QueryResult result = await GraphQLProvider.of(context).value.query(
      QueryOptions(
        document: await rootBundle.loadString('graphql/movies/queries/search_movies.gql'),
        variables: {
          'text': searchText
        }
      )
    );

    Map<String, dynamic>  data = result.data;
    return data['searchMovies'];
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Text(
            "No results were found.",
          ),
        )
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes. 
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    return Column();
  }
}
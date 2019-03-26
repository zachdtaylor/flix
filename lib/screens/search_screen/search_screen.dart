import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'movie_search_card.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<dynamic> _movies = [];
  Timer _debounce;

  _search(String searchText) async {
    QueryResult result = await GraphQLProvider.of(context).value.query(
      QueryOptions(
        document: await rootBundle.loadString('graphql/movies/queries/search_movies.gql'),
        variables: {
          'text': searchText
        }
      )
    );
    Map<String, dynamic>  data = result.data;
    setState(() {
      _movies = data['searchMovies'];
    });
  }

  _debounceSearch(String value) {
    print("<<<<<<<<<<<< $value <<<<<<<<<<<<<");
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      _search(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingSearchBar.builder(
      itemCount: _movies.length,
      itemBuilder: (context, index) {
        var movie = _movies[index];
        var tmdbId = int.parse(movie['tmdbId']);
        var cover = movie['cover'];
        var title = movie['title'];
        return MovieSearchCard(tmdbId: tmdbId, title: title, imageUrl: cover);
      },
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      trailing: IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {},
      ),
      onChanged: (String value) => _debounceSearch(value),
      decoration: InputDecoration.collapsed(hintText: "Search...")
    );
  }
}
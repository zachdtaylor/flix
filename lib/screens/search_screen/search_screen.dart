import 'package:flix_list/widgets/search/floating_bar.dart';
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
  bool loading = false;
  List<dynamic> _movies;
  Timer _debounce;
  TextEditingController _textController = TextEditingController();

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
      loading = false;
    });
  }

  _debounceSearch(String value) {
    setState(() {
      loading = true;
      _movies = null;
    });
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      _search(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.01),
          child: FloatingSearchBar.builder(
            controller: _textController,
            itemCount: _movies != null ? _movies.length : 0,
            itemBuilder: (context, index) {
              var movie = _movies[index];
              var tmdbId = int.parse(movie['tmdbId']);
              var cover = movie['cover'];
              var title = movie['title'];
              return MovieSearchCard(tmdbId: tmdbId, title: title, imageUrl: cover);
            },
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop()
            ),
            trailing: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _textController.clear();
                _search("");
              }
            ),
            onChanged: (String value) => _debounceSearch(value),
            decoration: InputDecoration.collapsed(hintText: "Search...")
          )
        ),
        Center(
          child: loading ? CircularProgressIndicator(strokeWidth: 3) : null
        ),
        Center(
          child: (_movies != null && _movies.isEmpty) ? Text("No results", style: Theme.of(context).textTheme.title) : null
        )
      ]
    );
  }
}

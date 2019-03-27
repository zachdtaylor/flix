import 'package:flutter/material.dart';
import '../../widgets/movie_card.dart';
import 'vote_bar.dart';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';

class MyMoviesScreen extends StatefulWidget {
  final Color white = Color(0xFFFFFFFF);
  final Color blue = Color(0xFF204CA0);

  @override
  _MyMoviesScreenState createState() => _MyMoviesScreenState();
}

class _MyMoviesScreenState extends State<MyMoviesScreen> {
  String _endCursor;
  bool _hasNextPage = true;
  int _pageCount = 24;
  List<dynamic> _movies = [];
  ScrollController _controller;
  Timer _debounce;

  @override
  initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    if (_controller.position.extentAfter < 200) {
      if (_debounce?.isActive ?? false) _debounce.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
          _queryMovies();
      });
    }
  }

  _queryMovies() async {
    if (_hasNextPage) {
      QueryResult result = await GraphQLProvider.of(this.context).value.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.networkOnly,
          document: await rootBundle.loadString('graphql/movies/queries/paginated_movies.gql'),
          variables: {
            'first': _pageCount,
            'after': _endCursor
          }
        )
      );

      Map<String, dynamic>  data = result.data;
      var moviesData = data['user']['movies']['edges'];
      var newData = moviesData.map((movie) => movie['node']).toList();
      print(data['user']['movies']['pageInfo']);
      if (newData.length >= 0) {
        setState(() {
            _endCursor = data['user']['movies']['pageInfo']['endCursor'];
            _hasNextPage = data['user']['movies']['pageInfo']['hasNextPage'];
            _movies.addAll(newData);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_movies.length == 0 && _hasNextPage) {
      _queryMovies();
    }
    return Container(
      child: GridView.builder(
        controller: _controller,
        itemCount: _movies.length,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.585,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        ),
        padding: EdgeInsets.all(10.0),
        itemBuilder: (context, index) {
          var movie = _movies[index];
          var cover = movie['cover'];
          var like = movie['userResponse']['like'];
          var tmdbId = int.parse(movie['tmdbId']);
          return MovieCard(tmdbId: tmdbId, child: VoteBar(liked: like), imageUrl: cover);
        }
      )
    );
  }
}

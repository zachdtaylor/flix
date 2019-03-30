import 'package:flutter/material.dart';
import 'package:flix_list/widgets/movies/movie_card.dart';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';

class MovieGrid extends StatefulWidget {
  final String query;
  final String emptyText;
  final Function buildVoteBar;
  final Function resultData;
  final Function pageData;

  MovieGrid({
    Key key,
    this.query,
    this.emptyText,
    this.buildVoteBar,
    this.resultData,
    this.pageData,
  }) : super(key: key);

  @override
  _MovieGridState createState() => _MovieGridState();
}

class _MovieGridState extends State<MovieGrid> {
  String _endCursor;
  bool _hasNextPage = true;
  int _pageCount = 24;
  bool _hasQueried = false;
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
          document: await rootBundle.loadString(widget.query),
          variables: {
            'first': _pageCount,
            'after': _endCursor
          }
        )
      );

      Map<String, dynamic>  data = result.data;
      var newData = widget.resultData(data);
      var pageData = widget.pageData(data);
      if (newData.length >= 0) {
        setState(() {
            _hasQueried = true;
            _endCursor = pageData['endCursor'];
            _hasNextPage = pageData['hasNextPage'];
            _movies.addAll(newData);
        });
      }
    }
  }

  Widget _child() {
    if (!_hasQueried) {
      return Center(child: CircularProgressIndicator(strokeWidth: 3,));
    } else if (_movies.isEmpty) {
      return Center(child: Text(widget.emptyText));
    }

    return GridView.builder(
      controller: _controller,
      itemCount: _movies != null ? _movies.length : 0,
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
        var tmdbId = int.parse(movie['tmdbId']);
        return MovieCard(tmdbId: tmdbId, child: widget.buildVoteBar(movie), imageUrl: cover);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_hasNextPage || !_hasQueried) {
      _queryMovies();
    }
    return Container(
      child: _child()
    );
  }
}

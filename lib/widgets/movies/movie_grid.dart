import 'package:flutter/material.dart';
import 'package:flix_list/util/utils.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/rendering.dart';
import 'dart:async';

class MovieGrid extends StatefulWidget {
  final String query;
  final String emptyText;
  final Function buildWidget;
  final Function resultData;
  final Function pageData;
  final Function(bool) showButton;
  final int userId;

  MovieGrid({
    Key key,
    this.query,
    this.emptyText,
    this.buildWidget,
    this.resultData,
    this.pageData,
    this.showButton,
    this.userId
  }) : super(key: key);

  @override
  _MovieGridState createState() => _MovieGridState();
}

class _MovieGridState extends State<MovieGrid> {
  String _endCursor;
  bool _hasNextPage = true;
  int _pageCount = 24;
  bool _hasQueried = false;
  bool _loading = true;
  List<dynamic> _movies = [];
  ScrollController _controller;
  Timer _debounce;

  @override
  initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    _controller.addListener(_buttonListener);
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

  _buttonListener() {
    if (_controller.offset == _controller.position.minScrollExtent) {
      if (widget.showButton != null) widget.showButton(true);
    } else {
      if (widget.showButton != null) widget.showButton(false);
    }
  }

  _queryMovies() async {

    if (_hasNextPage) {
      setState((){
        _loading = true;
      });
      var variables = {
        'first': _pageCount,
        'after': _endCursor
      };
      if (widget.userId != null) {
        variables['userId'] = widget.userId;
        variables['responseUserId'] = widget.userId;
      }

      QueryResult result = await GraphQLProvider.of(this.context).value.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.networkOnly,
          document: await rootBundle.loadString(widget.query),
          variables: variables
        )
      );
      setState((){
          _hasQueried=true;
          _loading = false;
      });

      Map<String, dynamic>  data = result.data;
      // print('<<<<<<<<<<<<<<<<<<<<<<<,');
      // print(data);
      var newData = widget.resultData(data);
      var pageData = widget.pageData(data);
      if (newData.length >= 0) {
        setState(() {
            _endCursor = pageData['endCursor'];
            _hasNextPage = pageData['hasNextPage'];
            _movies.addAll(newData);
        });
      }
    }
  }

  _onResponseChange(like, tmdbId) {
    submitResponse(GraphQLProvider.of(context), tmdbId, like, () {});
  }

  Future<void> _refresh() async {
    setState((){
      _endCursor = null;
      _movies = [];
      _hasNextPage = true;
    });
    await _queryMovies();
  }

  Widget _child() {
    Widget view;
    if (_hasQueried && _movies.isEmpty) {
      view = SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          margin: EdgeInsets.only(left: 32, right: 32),
          child: Center(
            child: Text(widget.emptyText, textAlign: TextAlign.center,)
          )
        )
      );
    } else {
      view = GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
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
          var tmdbId = int.parse(movie['tmdbId']);
          return widget.buildWidget(movie, (like) => _onResponseChange(like, tmdbId));
        }
      );
    }

    return _loading ? Center(child: CircularProgressIndicator(strokeWidth: 4,)) : RefreshIndicator(
      onRefresh: _refresh,
      child: view
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasQueried) {
      _queryMovies();
    }
    return Container(
      child: _child()
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flix_list/widgets/users/user_card.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';

class UserGrid extends StatefulWidget {
  final String query;
  final String emptyText;
  final Function buildNameBar;
  final Function resultData;
  final Function pageData;

  UserGrid({
    Key key,
    this.query,
    this.emptyText,
    this.buildNameBar,
    this.resultData,
    this.pageData,
  }) : super(key: key);

  @override
  _UserGridState createState() => _UserGridState();
}

class _UserGridState extends State<UserGrid> {
  String _endCursor;
  bool _hasNextPage = true;
  int _pageCount = 24;
  bool _hasQueried = false;
  bool _loading = true;
  List<dynamic> _users = [];
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
      setState((){
        _loading = true;
      });
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
      setState((){
          _hasQueried = true;
          _loading = false;
      });

      Map<String, dynamic>  data = result.data;
      var newData = widget.resultData(data);
      print('<<<<<<<<<<< newData <<<<<<<<<<<<');
      print(newData);
      var pageData = widget.pageData(data);
      if (newData.length >= 0) {
        setState(() {
            _endCursor = pageData['endCursor'];
            _hasNextPage = pageData['hasNextPage'];
            _users.addAll(newData);
        });
      }
    }
  }

  Future<void> _refresh() async {
    setState((){
      _endCursor = null;
      _users = [];
      _hasNextPage = true;
    });
    await _queryMovies();
  }

  Widget _child() {
    Widget view;
    if (_hasQueried && _users.isEmpty) {
      view = SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          margin: EdgeInsets.only(left: 32, right: 32),
          child: Center(
            child: Text(widget.emptyText, textAlign: TextAlign.center)
          )
        )
      );
    } else {
      view = GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _controller,
        itemCount: _users != null ? _users.length : 0,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.585,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        ),
        padding: EdgeInsets.all(10.0),
        itemBuilder: (context, index) {
          var user = _users[index];
          var name = user['name'];
          var userId = int.parse(user['userId']);
          return UserCard(userId: userId, child: widget.buildNameBar(name));
        }
      );
    }

    return _loading ? Center(child: CircularProgressIndicator(strokeWidth: 4)) : RefreshIndicator(
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
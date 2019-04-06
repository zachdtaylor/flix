import 'package:flix_list/widgets/search/floating_bar.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class Search extends StatefulWidget {
  final Function(String) search;
  final Widget Function(dynamic) buildResult;
  final String searchText;

  Search({
    Key key,
    this.search,
    this.buildResult,
    this.searchText,
  }) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool _loading = false;
  var _results;
  Timer _debounce;
  TextEditingController _textController = TextEditingController();

  _debounceSearch(String value) {
    setState(() {
      _loading = true;
      _results = null;
    });
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () async {
        var results = await widget.search(value);
        setState((){
          _results = results;
          _loading = false;
        });
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
            itemCount: _results != null ? _results.length : 0,
            itemBuilder: (context, index) {
              print(_results);
              return widget.buildResult(_results[index]);
            },
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop()
            ),
            trailing: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _textController.clear();
                widget.search("");
              }
            ),
            onChanged: (String value) => _debounceSearch(value),
            decoration: InputDecoration.collapsed(hintText: widget.searchText == null ? "Search..." : widget.searchText)
          )
        ),
        Center(
          child: _loading ? CircularProgressIndicator(strokeWidth: 3) : null
        ),
        Center(
          child: (_results != null && _results.isEmpty) ? Text("No results", style: Theme.of(context).textTheme.title) : null
        )
      ]
    );
  }
}

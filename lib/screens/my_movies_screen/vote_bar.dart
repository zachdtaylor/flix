import 'package:flutter/material.dart';

class VoteBar extends StatefulWidget {
  final bool liked;
  final onChange;

  VoteBar({Key key, @required this.liked, @required this.onChange}) : super(key: key);

  @override
  _VoteBarState createState() => _VoteBarState();
}

class _VoteBarState extends State<VoteBar> {
  bool _liked;
  bool _disliked;

  @override
  void initState() {
    _liked = widget.liked;
    _disliked = !widget.liked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color black = Color(0xFF000000);
    Color blue = Theme.of(context).accentColor;

    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.thumb_up, color: _liked ? blue : black),
          onPressed: () {
            widget.onChange(_liked ? null : true);
            setState(() {
              _liked = _liked ? false : true;
              _disliked = false;
            });
          }
        ),
        IconButton(
          icon: Icon(Icons.thumb_down, color: _disliked ? blue : black),
          onPressed: () {
            widget.onChange(_disliked ? null : false);
            setState(() {
              _liked = false;
              _disliked = _disliked ? false : true;
            });
          }
        )
      ]
    );
  }
}
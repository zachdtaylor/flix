import 'package:flutter/material.dart';

class VoteBar extends StatefulWidget {
  VoteBar({Key key}) : super(key: key);

  @override
  _VoteBarState createState() => _VoteBarState();
}

class _VoteBarState extends State<VoteBar> {

  bool _liked = false;
  bool _disliked = false;

  void _like() {
    setState(() {
      _liked = true;
      _disliked = false;
    });
  }

  void _dislike() {
    setState(() {
      _liked = false;
      _disliked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color black = Color(0xFF000000);
    Color blue = Theme.of(context).accentColor;

    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.thumb_up, color: _liked ? blue : black),
          onPressed: _like,
        ),
        IconButton(
          icon: Icon(Icons.thumb_down, color: _disliked ? blue : black),
          onPressed: _dislike,
        )
      ]
    );
  }
}
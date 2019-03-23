import 'package:flutter/material.dart';

class CountVoteBar extends StatefulWidget {
  CountVoteBar({Key key, @required this.likes, @required this.dislikes}) : super(key: key);

  int likes;
  int dislikes;

  @override
  _CountVoteBarState createState() => _CountVoteBarState();
}

class _CountVoteBarState extends State<CountVoteBar> {

  bool _liked = false;
  bool _disliked = false;

  void _like() {
    if (!_liked) {
      widget.likes += 1;
    }
    if (_disliked) {
      widget.dislikes -= 1;
    }
    setState(() {
      _liked = true;
      _disliked = false;
    });
  }

  void _dislike() {
    if (!_disliked) {
      widget.dislikes += 1;
    }
    if (_liked) {
      widget.likes -= 1;
    }
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
        SizedBox(
          width: 18,
          child: Container(
            child: Text(
              widget.likes.toString(),
              style: TextStyle(color: _liked ? blue : black, fontWeight: FontWeight.bold)
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.thumb_down, color: _disliked ? blue : black),
          onPressed: _dislike,
        ),
        SizedBox(
          width: 18,
          child: Container(
            child: Text(
              widget.dislikes.toString(),
              style: TextStyle(color: _disliked ? blue : black, fontWeight: FontWeight.bold)
            ),
          ),
        )
      ],
    );
  }
}
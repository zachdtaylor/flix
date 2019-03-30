import 'package:flutter/material.dart';

class CountVoteBar extends StatefulWidget {
  CountVoteBar({Key key, @required this.movie}) : super(key: key);
  final movie;

  @override
  _CountVoteBarState createState() => _CountVoteBarState();
}

class _CountVoteBarState extends State<CountVoteBar> {
  bool _liked = false;
  bool _disliked = false;
  int _likes = 0;
  int _dislikes = 0;

  @override
  initState(){
    _likes = widget.movie['followeeLikes'];
    _dislikes = widget.movie['followeeDislikes'];
    super.initState();
  }

  void _like() {
    if (!_liked) {
      _likes += 1;
    }
    if (_disliked) {
      _dislikes -= 1;
    }
    setState(() {
      _liked = true;
      _disliked = false;
    });
  }

  void _dislike() {
    if (!_disliked) {
      _dislikes += 1;
    }
    if (_liked) {
      _likes -= 1;
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
              _likes.toString(),
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
              _dislikes.toString(),
              style: TextStyle(color: _disliked ? blue : black, fontWeight: FontWeight.bold)
            ),
          ),
        )
      ],
    );
  }
}

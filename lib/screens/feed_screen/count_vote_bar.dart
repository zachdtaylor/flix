import 'package:flutter/material.dart';
import 'package:flix_list/util/utils.dart';

class CountVoteBar extends StatefulWidget {
  CountVoteBar({Key key, @required this.movie, @required this.onChange}) : super(key: key);
  final movie;
  final onChange;

  @override
  _CountVoteBarState createState() => _CountVoteBarState();
}

class _CountVoteBarState extends State<CountVoteBar> {
  bool _liked;
  bool _disliked;
  int _likes = 0;
  int _dislikes = 0;

  @override
  initState(){
    _liked = liked(widget.movie['userResponse']);
    _disliked = disliked(widget.movie['userResponse']);
    _likes = widget.movie['followeeLikes'] + (_liked ? 1 : 0);
    _dislikes = widget.movie['followeeDislikes'] + (_disliked ? 1 : 0);
    super.initState();
  }

  void _like() {
    widget.onChange(_liked ? null : true);
    setState(() {
      if (!_liked) {
        _likes += 1;
        _liked = true;
      } else {
        _likes -= 1;
        _liked = false;
      }
      if (_disliked) {
        _dislikes -= 1;
        _disliked = false;
      }
    });
  }

  void _dislike() {
    widget.onChange(_disliked ? null : false);
    setState(() {
      if (!_disliked) {
        _dislikes += 1;
        _disliked = true;
      } else {
        _dislikes -= 1;
        _disliked = false;
      }
      if (_liked) {
        _likes -= 1;
        _liked = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Color black = Color(0xFF000000);
    Color blue = Theme.of(context).accentColor;
    Color red = Theme.of(context).errorColor;

    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.thumb_down, color: _disliked ? red : black),
          onPressed: _dislike,
        ),
        SizedBox(
          width: 18,
          child: Container(
            child: Text(
              _dislikes.toString(),
              style: TextStyle(color: _disliked ? red : black, fontWeight: FontWeight.bold)
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.thumb_up, color: _liked ? blue : black),
          onPressed: _like
        ),
        SizedBox(
          width: 18,
          child: Container(
            child: Text(
              _likes.toString(),
              style: TextStyle(color: _liked ? blue : black, fontWeight: FontWeight.bold)
            ),
          ),
        )
      ],
    );
  }
}

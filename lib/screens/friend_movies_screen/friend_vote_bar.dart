import 'package:flutter/material.dart';

class FriendVoteBar extends StatefulWidget {
  final bool liked;
  final bool disliked;
  final onChange;

  FriendVoteBar({Key key, @required this.liked, @required this.disliked, @required this.onChange}) : super(key: key);

  @override
  _FriendVoteBarState createState() => _FriendVoteBarState();
}

class _FriendVoteBarState extends State<FriendVoteBar> {
  bool _liked;
  bool _disliked;

  @override
  void initState() {
    _liked = widget.liked;
    _disliked = widget.disliked;
    super.initState();
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
          onPressed: () {
            widget.onChange(_disliked ? null : false);
            setState(() {
              _liked = false;
              _disliked = _disliked ? false : true;
            });
          }
        ),
        IconButton(
          icon: Icon(Icons.thumb_up, color: _liked ? blue : black),
          onPressed: () {
            widget.onChange(_liked ? null : true);
            setState(() {
              _liked = _liked ? false : true;
              _disliked = false;
            });
          }
        )
      ]
    );
  }
}
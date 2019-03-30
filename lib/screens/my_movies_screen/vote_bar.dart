import 'package:flutter/material.dart';

class VoteBar extends StatefulWidget {
  final bool liked;
  final onChange;

  VoteBar({Key key, @required this.liked, @required this.onChange}) : super(key: key);

  @override
  _VoteBarState createState() => _VoteBarState();
}

class _VoteBarState extends State<VoteBar> {
  bool liked;
  bool disliked;

  @override
  void initState() {
    liked = widget.liked;
    disliked = !widget.liked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color black = Color(0xFF000000);
    Color blue = Theme.of(context).accentColor;

    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.thumb_up, color: liked ? blue : black),
          onPressed: () {
            widget.onChange(liked ? null : true);
            setState(() {
              liked = liked ? false : true;
              disliked = false;
            });
          }
        ),
        IconButton(
          icon: Icon(Icons.thumb_down, color: disliked ? blue : black),
          onPressed: () {
            widget.onChange(disliked ? null : false);
            setState(() {
              liked = false;
              disliked = disliked ? false : true;
            });
          }
        )
      ]
    );
  }
}
import 'package:flutter/material.dart';

class VoteBar extends StatelessWidget {
  VoteBar({Key key, this.liked}) : super(key: key);

  final bool liked;

  @override
  Widget build(BuildContext context) {
    Color black = Color(0xFF000000);
    Color blue = Theme.of(context).accentColor;

    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.thumb_up, color: liked ? blue : black),
        ),
        IconButton(
          icon: Icon(Icons.thumb_down, color: !liked ? blue : black),
        )
      ]
    );
  }

}

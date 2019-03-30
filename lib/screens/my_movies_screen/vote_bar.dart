import 'package:flutter/material.dart';

class VoteBar extends StatelessWidget {
  VoteBar({Key key, @required this.liked, @required this.onChange}) : super(key: key);

  final bool liked;
  final onChange;

  @override
  Widget build(BuildContext context) {
    Color black = Color(0xFF000000);
    Color blue = Theme.of(context).accentColor;

    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.thumb_up, color: liked ? blue : black),
          onPressed: () => onChange(liked ? null : true),
        ),
        IconButton(
          icon: Icon(Icons.thumb_down, color: !liked ? blue : black),
          onPressed: () => onChange(liked ? false : null),
        )
      ]
    );
  }
}

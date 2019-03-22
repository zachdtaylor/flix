import 'package:flutter/material.dart';

class VoteBar extends StatefulWidget {
  VoteBar({Key key, @required this.likes, @required this.dislikes}) : super(key: key);

  int likes;
  int dislikes;

  @override
  _VoteBarState createState() => _VoteBarState();
}

class _VoteBarState extends State<VoteBar> {

  void _like() {
    widget.likes += 1;
  }

  @override
  Widget build(BuildContext context) {
    Color black = Color(0xFF000000);

    return Row(
      children: <Widget>[
        IconButton(icon: Icon(Icons.thumb_up, color: black)),
        SizedBox(
          width: 18,
          child: Container(
            child: Text(widget.likes.toString(), style: TextStyle(color: black, fontWeight: FontWeight.bold)),
          ),
        ),
        IconButton(icon: Icon(Icons.thumb_down, color: black)),
        SizedBox(
          width: 18,
          child: Container(
            child: Text(widget.dislikes.toString(), style: TextStyle(color: black, fontWeight: FontWeight.bold)),
          ),
        )
      ],
    );
  }
}
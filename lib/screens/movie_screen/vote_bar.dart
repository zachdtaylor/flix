import 'package:flutter/material.dart';

class VoteBar extends StatefulWidget {
  VoteBar({Key key}) : super(key: key);

  @override
  _VoteBarState createState() => _VoteBarState();
}

class _VoteBarState extends State<VoteBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(icon: Icon(Icons.thumb_up)),
        SizedBox(
          width: 18,
          child: Container(
            child: Text('50'),
          ),
        ),
        IconButton(icon: Icon(Icons.thumb_down)),
        SizedBox(
          width: 18,
          child: Container(
            child: Text('25'),
          ),
        )
      ],
    );
  }
}
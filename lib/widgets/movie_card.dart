import 'package:flutter/material.dart';

class MovieCard extends StatefulWidget {
  MovieCard({Key key, @required this.child}) : super(key: key);

  final Widget child;

  @override
  _MovieCardState createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/endgame.jpg')
                )
              )
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[ widget.child ],
            )
          ],
        )
      ),
    );
  }
}
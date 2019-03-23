import 'package:flutter/material.dart';

class MovieCard extends StatefulWidget {
  MovieCard({Key key, @required this.child, @required this.imageUrl}) : super(key: key);

  final Widget child;
  final String imageUrl;

  @override
  _MovieCardState createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color:Color(0xFFFFFFFF),
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 270,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(widget.imageUrl)
                )
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[ widget.child ],
            )
          ],
        )
      ),
    );
  }
}
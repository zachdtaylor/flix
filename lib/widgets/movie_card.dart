import 'package:flutter/material.dart';
import '../utils.dart';

class MovieCard extends StatefulWidget {
  MovieCard({Key key, @required this.child, @required this.imageUrl, this.tmdbId}) : super(key: key);

  final int tmdbId;
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
            Expanded(
              flex: 17,
              child: GestureDetector(
                onTap: () => goToMovieScreen(context, widget.tmdbId),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(widget.imageUrl)
                    )
                  ),
                )
              )
            ),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[ widget.child ],
              )
            )
          ],
        )
      )
    );
  }
}
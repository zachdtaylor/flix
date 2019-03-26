import 'package:flutter/material.dart';
import '../../utils.dart';

class MovieSearchCard extends StatelessWidget {
  MovieSearchCard({Key key, this.tmdbId, this.title, this.imageUrl}) : super(key: key);

  final int tmdbId;
  final String title;
  final String imageUrl;

  _image() {
    try {
      NetworkImage image = NetworkImage(imageUrl);
      return image;
    } catch (Exception) {
      return AssetImage("images/cover_unavailable.jpg");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => goToMovieScreen(context, tmdbId),
      child: Card(
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.15,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: _image()
                  )
                ),
              )
            ),
            Expanded(
              flex: 4,
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                width:MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(title, softWrap: true, style: TextStyle(fontSize: 18),)
                  ],
                ),
              )
            )
          ]
        )
      )
    );
  }

  
}
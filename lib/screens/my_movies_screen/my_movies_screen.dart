import 'package:flutter/material.dart';
import '../../widgets/movie_card.dart';
import 'vote_bar.dart';

class MyMoviesScreen extends StatelessWidget {
  Color white = Color(0xFFFFFFFF);
  Color blue = Color(0xFF204CA0);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 0.585,
        padding: EdgeInsets.all(10.0),
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        children: <Widget>[
          MovieCard(
            child: VoteBar(), 
            imageUrl: "https://images-na.ssl-images-amazon.com/images/I/51poKKV63GL.jpg"
          ),
          MovieCard(
            child: VoteBar(),
            imageUrl: "https://m.media-amazon.com/images/M/MV5BZmUwNGU2ZmItMmRiNC00MjhlLTg5YWUtODMyNzkxODYzMmZlXkEyXkFqcGdeQXVyNTIzOTk5ODM@._V1_.jpg"
          ),
          MovieCard(
            child: VoteBar(),
            imageUrl: "https://m.media-amazon.com/images/M/MV5BMTE0YWFmOTMtYTU2ZS00ZTIxLWE3OTEtYTNiYzBkZjViZThiXkEyXkFqcGdeQXVyODMzMzQ4OTI@._V1_.jpg"
          ),
          MovieCard(
            child: VoteBar(),
            imageUrl: "http://cdn.collider.com/wp-content/uploads/2019/03/avengers-endgame-poster-405x600.jpg"
          )
        ]
      )
    );
  }
}
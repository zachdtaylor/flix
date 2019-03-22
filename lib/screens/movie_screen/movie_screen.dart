import 'package:flutter/material.dart';
import '../../widgets/movie_card.dart';
import 'vote_bar.dart';

class MovieScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movies"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            tooltip: "Search",
          )
        ],
      ),
      body: Container(
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 0.585,
          padding: EdgeInsets.all(10.0),
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          children: <Widget>[
            MovieCard(
              child: VoteBar(likes: 10, dislikes:30), 
              imageUrl: "https://images-na.ssl-images-amazon.com/images/I/51poKKV63GL.jpg"
            ),
            MovieCard(
              child: VoteBar(likes: 27, dislikes: 6),
              imageUrl: "https://m.media-amazon.com/images/M/MV5BZmUwNGU2ZmItMmRiNC00MjhlLTg5YWUtODMyNzkxODYzMmZlXkEyXkFqcGdeQXVyNTIzOTk5ODM@._V1_.jpg"
            ),
            MovieCard(
              child: VoteBar(likes: 15, dislikes: 8),
              imageUrl: "https://m.media-amazon.com/images/M/MV5BMTE0YWFmOTMtYTU2ZS00ZTIxLWE3OTEtYTNiYzBkZjViZThiXkEyXkFqcGdeQXVyODMzMzQ4OTI@._V1_.jpg"
            ),
            MovieCard(
              child: VoteBar(likes: 42, dislikes: 1),
              imageUrl: "http://cdn.collider.com/wp-content/uploads/2019/03/avengers-endgame-poster-405x600.jpg"
            )
          ]
        )
      )
    );
  }
}
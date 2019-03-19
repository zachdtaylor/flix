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
          childAspectRatio: 1.0,
          padding: EdgeInsets.all(4.0),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          children: <Widget>[
            MovieCard(child: VoteBar()),
            MovieCard(child: VoteBar()),
            MovieCard(child: VoteBar()),
            MovieCard(child: VoteBar())
          ]
        )
      )
    );
  }
}
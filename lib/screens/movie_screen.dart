import 'package:flutter/material.dart';
import '../widgets/movie_card.dart';

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
      body: Center(
        child: MovieCard()
      )
    );
  }
}
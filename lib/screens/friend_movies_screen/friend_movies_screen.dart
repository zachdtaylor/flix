import 'package:flutter/material.dart';
import 'package:flix_list/widgets/movies/movie_grid.dart';

class FriendMoviesScreen extends StatelessWidget {
  FriendMoviesScreen({Key key, this.name, this.userId}) : super(key: key);

  final String name;
  final int userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name + "'s Movies"),
      ),
      body: Text("Hey")
    );
  }

}
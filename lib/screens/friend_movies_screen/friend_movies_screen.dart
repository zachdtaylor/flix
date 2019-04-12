import 'package:flutter/material.dart';
import 'package:flix_list/widgets/movies/movie_grid.dart';
import 'package:flix_list/widgets/movies/movie_card.dart';
import 'package:flix_list/widgets/movies/movie_filter.dart';
import 'package:flix_list/util/utils.dart';
import 'friend_vote_bar.dart';

class FriendMoviesScreen extends StatefulWidget {
  FriendMoviesScreen({Key key, this.name, this.userId}) : super(key: key);

  final String name;
  final int userId;

  @override
  _FriendMoviesScreenState createState() => _FriendMoviesScreenState();
}

class _FriendMoviesScreenState extends State<FriendMoviesScreen>{
  MovieFilter _filter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name + "'s Movies"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.white),
            tooltip: "Filter",
            onPressed: () async {
              MovieFilter filter = await MovieFilterDialog.createDialog(context, currentValue: _filter);
              if (filter != null) {
                setState((){
                    _filter = filter;
                });
              }
            },
          ),
        ]
      ),
      body: MovieGrid(
        query: () => MovieFilterDialog.query(_filter),
        emptyText: 'This user has not saved any movies!',
        filter: _filter,
        buildWidget: (movie, onChange) {
          print(movie);
          return MovieCard(
            tmdbId: int.parse(movie['tmdbId']),
            child: FriendVoteBar(
              liked: liked(movie['userResponse']),
              disliked: disliked(movie['userResponse'])
            ),
            imageUrl: movie['cover']);
        },
        resultData: (data) {
          var moviesData = data['user'][MovieFilterDialog.movieKey(_filter)]['edges'];
          return moviesData.map((movie) => movie['node']).toList();
        },
        pageData: (data) {
          return data['user'][MovieFilterDialog.movieKey(_filter)]['pageInfo'];
        },
        userId: widget.userId,
      )
    );
  }

}

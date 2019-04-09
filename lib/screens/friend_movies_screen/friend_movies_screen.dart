import 'package:flutter/material.dart';
import 'package:flix_list/widgets/movies/movie_grid.dart';
import 'package:flix_list/widgets/movies/movie_card.dart';
import 'package:flix_list/util/utils.dart';
import 'friend_vote_bar.dart';

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
      body: MovieGrid(
        query: 'graphql/movies/queries/paginated_movies.gql',
        emptyText: 'This user has not saved any movies!',
        buildWidget: (movie, onChange) {
          return MovieCard(
            tmdbId: int.parse(movie['tmdbId']), 
            child: FriendVoteBar(
              liked: liked(movie['userResponse']), 
              disliked: disliked(movie['userResponse']), 
              onChange: onChange
            ), 
            imageUrl: movie['cover']);
        },
        resultData: (data) {
          var moviesData = data['user']['movies']['edges'];
          return moviesData.map((movie) => movie['node']).toList();
        },
        pageData: (data) {
          return data['user']['movies']['pageInfo'];
        },
        userId: userId,
      )
    );
  }

}
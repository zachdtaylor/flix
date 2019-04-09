import 'package:flutter/material.dart';
import 'package:flix_list/widgets/movies/movie_card.dart';
import 'package:flix_list/widgets/movies/movie_grid.dart';
import 'vote_bar.dart';

class MyMoviesScreen extends StatelessWidget {
  MyMoviesScreen({Key key, this.showButton}) : super(key: key);
  final Function(bool) showButton;
  @override
  Widget build(BuildContext context) {
    return MovieGrid(
      showButton: showButton,
      query: 'graphql/movies/queries/paginated_movies.gql',
      emptyText: 'You haven\'t saved any movies yet!',
      buildWidget: (movie, onChange) {
        return MovieCard(
          tmdbId: int.parse(movie['tmdbId']), 
          child: VoteBar(liked: movie['userResponse']['like'], onChange: onChange), 
          imageUrl: movie['cover']);
      },
      resultData: (data) {
        var moviesData = data['user']['movies']['edges'];
        return moviesData.map((movie) => movie['node']).toList();
      },
      pageData: (data) {
        return data['user']['movies']['pageInfo'];
      }
    );
  }
}

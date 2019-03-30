import 'package:flutter/material.dart';
import 'package:flix_list/widgets/movies/movie_grid.dart';
import 'vote_bar.dart';

class MyMoviesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MovieGrid(
      query: 'graphql/movies/queries/paginated_movies.gql',
      emptyText: 'You haven\'t saved any movies yet!',
      buildVoteBar: (movie, onChange) {
        return VoteBar(liked: movie['userResponse']['like'], onChange: onChange);
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

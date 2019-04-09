import 'package:flutter/material.dart';
import 'package:flix_list/widgets/movies/movie_grid.dart';
import 'package:flix_list/screens/feed_screen/count_vote_bar.dart';
import 'package:flix_list/widgets/movies/movie_card.dart';

class FeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MovieGrid(
      query: 'graphql/movies/queries/recent_movies.gql',
      emptyText: 'Looking for new movies? When someone you\'re following rates a movie, you\'ll see it here.',
      buildWidget: (movie, onChange) {
        return MovieCard(
          tmdbId: int.parse(movie['tmdbId']), 
          child: CountVoteBar(movie: movie, onChange: onChange), 
          imageUrl: movie['cover']
        );
      },
      resultData: (data) {
        var moviesData = data['recentMovies']['edges'];
        return moviesData.map((movie) => movie['node']).toList();
      },
      pageData: (data) {
        return data['recentMovies']['pageInfo'];
      }
    );
  }
}

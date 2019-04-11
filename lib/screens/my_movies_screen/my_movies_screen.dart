import 'package:flutter/material.dart';
import 'package:flix_list/widgets/movies/movie_card.dart';
import 'package:flix_list/widgets/movies/movie_grid.dart';
import 'package:flix_list/widgets/movies/movie_filter.dart';
import 'vote_bar.dart';

class MyMoviesScreen extends StatefulWidget {
  MyMoviesScreen({Key key, this.showButton, this.filter}) : super(key: key);
  final Function(bool) showButton;
  final Function filter;

  @override
  _MyMoviesScreenState createState() => _MyMoviesScreenState();
}

class _MyMoviesScreenState extends State<MyMoviesScreen>{

  _query() {
    MovieFilter value = widget.filter();
    print(value);
    if (value != null) {
      if (value == MovieFilter.LIKED) {
        print('liked');
        return 'graphql/users/queries/user_details_filter_liked.gql';
      } else if (value == MovieFilter.DISLIKED) {
        print('disliked');
        return 'graphql/users/queries/user_details_filter_disliked.gql';
      }
    }
    return 'graphql/movies/queries/paginated_movies.gql';
  }

  _movieKey() {
    MovieFilter value = widget.filter();
    if (value != null) {
      if (value == MovieFilter.LIKED) {
        return 'likedMovies';
      } else if (value == MovieFilter.DISLIKED) {
        return 'dislikedMovies';
      }
    }
    return 'movies';
  }

  @override
  Widget build(BuildContext context) {
    return MovieGrid(
      showButton: widget.showButton,
      query: _query,
      filter: widget.filter(),
      emptyText: 'You haven\'t saved any movies yet!',
      buildWidget: (movie, onChange) {
        return MovieCard(
          tmdbId: int.parse(movie['tmdbId']),
          child: VoteBar(liked: movie['userResponse']['like'], onChange: onChange),
          imageUrl: movie['cover']);
      },
      resultData: (data) {
        print(data);
        var moviesData = data['user'][_movieKey()]['edges'];
        return moviesData.map((movie) => movie['node']).toList();
      },
      pageData: (data) {
        return data['user'][_movieKey()]['pageInfo'];
      }
    );
  }
}

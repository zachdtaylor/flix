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

  @override
  Widget build(BuildContext context) {
    return MovieGrid(
      showButton: widget.showButton,
      query: () => MovieFilterDialog.query(widget.filter()),
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
        var moviesData = data['user'][MovieFilterDialog.movieKey(widget.filter())]['edges'];
        return moviesData.map((movie) => movie['node']).toList();
      },
      pageData: (data) {
        return data['user'][MovieFilterDialog.movieKey(widget.filter())]['pageInfo'];
      }
    );
  }
}

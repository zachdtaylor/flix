import 'package:flutter/material.dart';
import 'screens/movie_screen/movie_screen.dart';

goToMovieScreen(BuildContext context, int tmdbId) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => MovieScreen(tmdbId: tmdbId))
  );
}
import 'package:flutter/material.dart';
import 'package:flix_list/util/utils.dart';
import 'package:flix_list/widgets/search/search_card.dart';

class MovieSearchCard extends StatelessWidget {
  MovieSearchCard({Key key, this.tmdbId, this.title, this.imageUrl}) : super(key: key);

  final int tmdbId;
  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return SearchCard(
      title: title,
      imageUrl: imageUrl,
      loadingImageUrl: 'images/cover_unavailable.jpg',
      onTap: () => goToMovieScreen(context, tmdbId),
      height: 0.15
    );
  }

}

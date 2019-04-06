import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'movie_search_card.dart';
import 'package:flix_list/widgets/search/search.dart';

class MovieSearchScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Search(
      search: (String searchText) async {
        QueryResult result = await GraphQLProvider.of(context).value.query(
          QueryOptions(
            document: await rootBundle.loadString('graphql/movies/queries/search_movies.gql'),
            variables: {
              'text': searchText
            }
          )
        );
        Map<String, dynamic>  data = result.data;
        return data['searchMovies'];
      },
      searchText: 'Search movies...',
      buildResult: (movie) {
        var tmdbId = int.parse(movie['tmdbId']);
        var cover = movie['cover'];
        var title = movie['title'];
        return MovieSearchCard(tmdbId: tmdbId, title: title, imageUrl: cover);
      }
    );
  }
}

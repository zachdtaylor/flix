import 'package:flutter/material.dart';
import 'package:flix_list/screens/movie_screen/movie_screen.dart';
import 'package:flix_list/screens/user_screen/user_screen.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:graphql_flutter/graphql_flutter.dart';

goToMovieScreen(BuildContext context, int tmdbId) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => MovieScreen(tmdbId: tmdbId))
  );
}

goToUserScreen(BuildContext context, int userId) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => UserScreen(userId: userId))
  );
}

bool liked(userResponse) {
  if (userResponse != null) {
    return userResponse['like'] == true;
  }
  return false;
}

bool disliked(userResponse) {
  if (userResponse != null) {
    return userResponse['like'] == false;
  }
  return false;
}

submitResponse(graphql, tmdbId, like, callback) async {
  graphql.value.mutate(
    MutationOptions(
      document: await rootBundle.loadString('graphql/movies/mutations/movie_response.gql'),
      variables: like == null ? 
      {
        'tmdbId': tmdbId
      }
      : {
        'like': like,
        'tmdbId': tmdbId
      }
    )
  ).then(
    (result) => callback()
  );
}
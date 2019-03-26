import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';

class MovieScreen extends StatefulWidget {
  MovieScreen({Key key, this.tmdbId}) : super(key: key);

  final int tmdbId;

  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {

  _getInfo() {
    QueryResult result = await GraphQLProvider.of(context).value.query(
      QueryOptions(
        document: await rootBundle.loadString('graphql/movies/queries/paginated_movies.gql'),
        variables: {
          'first': _pageCount,
          'after': _endCursor
        }
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    _getInfo();

    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: 270,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(imageUrl)
            )
          ),
        ),
      ]
    );
  }

}
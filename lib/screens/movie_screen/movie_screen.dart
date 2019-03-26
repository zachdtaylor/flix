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
  String imageUrl;
  String summary;
  String title;

  _getInfo() async {
    QueryResult result = await GraphQLProvider.of(context).value.query(
      QueryOptions(
        document: await rootBundle.loadString('graphql/movies/queries/movie_details.gql'),
        variables: {
          'tmdbId': widget.tmdbId
        }
      )
    );

    Map<String, dynamic> data = result.data;
    print('<<<<<<<<<<<<<< data <<<<<<<<<<<<<');
    print(widget.tmdbId);
    print(data);
    var movie = data['movie'];
    setState(() {
      imageUrl = movie['cover'];
      summary = movie['summary'];
      title = movie['title'];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null && summary == null && title == null) {
      _getInfo();
    }

    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: 270,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fitWidth,
              image: imageUrl != null ? NetworkImage(imageUrl) : AssetImage('images/cover_unavailable.png')
            )
          ),
        ),
        Card(
          margin: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Text("Summary", style: TextStyle(fontSize: 24)),
              Text(summary != null ? summary : "No summary", softWrap: true)
            ]
          )
        )
      ]
    );
  }

}

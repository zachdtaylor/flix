import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flix_list/util/utils.dart';

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
  Map<String, dynamic> userResponse;

  _getInfo() async {
    QueryResult result = await GraphQLProvider.of(context).value.query(
      QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: await rootBundle.loadString('graphql/movies/queries/movie_details.gql'),
        variables: {
          'tmdbId': widget.tmdbId
        }
      )
    );

    Map<String, dynamic> data = result.data;
    var movie = data['movie'];
    print("<<<<<<<<<<<< movie <<<<<<<<<<<<");
    print(movie);
    setState(() {
      imageUrl = movie['cover'];
      summary = movie['summary'];
      title = movie['title'];
      userResponse = movie['userResponse'];
    });
  }

  _respondToMovie(like) {
    submitResponse(GraphQLProvider.of(context), widget.tmdbId, like, _getInfo);
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null && summary == null && title == null) {
      _getInfo();
    }

    Color white = Color(0xFFFFFFFF);
    Color blue = Theme.of(context).accentColor;

    return imageUrl == null ? Center(child:CircularProgressIndicator(strokeWidth: 3,)) : Scaffold(
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.55,
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                    image: NetworkImage(imageUrl)
                  )
                )
              ),
              Positioned(
                left: MediaQuery.of(context).size.width*0.01,
                top:MediaQuery.of(context).size.height*0.01,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ),
              Positioned(
                right: MediaQuery.of(context).size.width*0.01,
                top:MediaQuery.of(context).size.height*0.01,
                child: Column(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.thumb_up, color: liked(userResponse) ? blue : white),
                      onPressed: () => _respondToMovie(liked(userResponse) ? null : true)
                    ),
                    IconButton(
                      icon: Icon(Icons.thumb_down, color: disliked(userResponse) ? blue : white),
                      onPressed: () => _respondToMovie(disliked(userResponse) ? null : false)
                    ),
                    IconButton(
                      icon: Icon(Icons.share, color: white)
                    )
                  ]
                )
              )
            ]
          ),
          Card(
            margin: EdgeInsets.fromLTRB(5, 10, 5, 5),
            child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(title, style: TextStyle(fontSize: 24)),
                  ),
                  SizedBox(height:MediaQuery.of(context).size.height*0.015),
                  Text(summary, softWrap: true)
                ]
              )
            )
          )
        ]
      )
    );
  }
}

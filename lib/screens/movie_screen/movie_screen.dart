import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

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
    print('<<<<<<<<<<<<<< data <<<<<<<<<<<<<');
    print(widget.tmdbId);
    print(data);
    var movie = data['movie'];
    setState(() {
      imageUrl = movie['cover'];
      summary = movie['summary'];
      title = movie['title'];
      userResponse = movie['userResponse'];
    });
  }

  _submitResponse(bool like) async {
    GraphQLProvider.of(context).value.mutate(
      MutationOptions(
        document: await rootBundle.loadString('graphql/movies/mutations/movie_response.gql'),
        variables: {
          'like': like,
          'tmdbId': widget.tmdbId
        }
      )
    ).then(
      (result) {
        print("<<<<<<<<<<<<<<, result <<<<<<<<<<<<<<");
        print(result.data);
        _getInfo();
      }
    );
  }

  bool _liked() {
    return (userResponse != null && userResponse['like'] == true) ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null && summary == null && title == null) {
      _getInfo();
    }

    Color white = Color(0xFFFFFFFF);
    Color blue = Theme.of(context).accentColor;

    return ListView(
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
                  image: imageUrl != null ? NetworkImage(imageUrl) : AssetImage('images/cover_unavailable.png')
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
              child: IconButton(
                icon: Icon(Icons.thumb_up),
                onPressed: () => _submitResponse(true)
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
                  child: Text(title != null ? title : "No title", style: TextStyle(fontSize: 24)),
                ),
                SizedBox(height:MediaQuery.of(context).size.height*0.015),
                Text(summary != null ? summary : "No summary", softWrap: true)
              ]
            )
          )
        ),
        Card(
          margin: EdgeInsets.all(5),
          child: Container(
            padding: EdgeInsets.all(5),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.thumb_up, color: _liked() ? blue : white),
                  onPressed: () => _submitResponse(true),
                ),
                IconButton(
                  icon: Icon(Icons.thumb_down, color: _liked() ? white : blue),
                  onPressed: () => _submitResponse(false),
                )
              ]
            )
          )
        )
      ]
    );
  }
}

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flix_list/util/utils.dart';
import 'package:intl/intl.dart';
import 'package:flix_list/screens/user_selection_screen/user_selection_screen.dart';
import 'package:flix_list/util/graphql/graphql_mutation.dart';
import 'package:flix_list/util/graphql/graphql_constants.dart';

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
  String year;
  int totalLikes;
  int totalDislikes;
  int followeeLikes;
  int followeeDislikes;
  bool _liked;
  bool _disliked;
  bool _hasQueried = false;
  int _movieId;

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
        _movieId = int.parse(movie['movieId']);
        year = DateFormat.yMMMM().format(DateTime.parse(movie['releaseDate']));
        totalLikes = movie['totalLikes'];
        totalDislikes = movie['totalDislikes'];
        followeeLikes = movie['followeeLikes'];
        followeeDislikes = movie['followeeDislikes'];
        if (!_hasQueried) {
          _liked = liked(movie['userResponse']);
          _disliked = disliked(movie['userResponse']);
          _hasQueried = true;
        }
    });
  }

  _respondToMovie(like) {
    submitResponse(GraphQLProvider.of(context), widget.tmdbId, like, _getInfo);
  }

  Future<bool>_recommendMovie(userId) async {
    try {
      await GraphqlMutation(operation: GQL_M_RECOMMEND_MOVIE)
      .execute(variables: {
          'movieId': _movieId,
          'userId': userId
      });
      return true;
    } catch(error) {
      return false;
    }
  }

  _ratingTotals(title, dislike, like) {
    return Container(
      child: Row(
        children: <Widget>[
          Padding(
            child: Text(title),
            padding: EdgeInsets.all(4),
          ),
          Padding(
            child: Text(dislike.toString()),
            padding: EdgeInsets.all(4),
          ),
          Padding(
            child: Icon(Icons.thumb_down, color: Colors.white),
            padding: EdgeInsets.all(4),
          ),
          Padding(
            child: Text(like.toString()),
            padding: EdgeInsets.all(4),
          ),
          Padding(
            child: Icon(Icons.thumb_up, color: Colors.white),
            padding: EdgeInsets.all(4),
          ),
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null && summary == null && title == null) {
      _getInfo();
    }

    Color white = Color(0xFFFFFFFF);
    Color black = Color(0xFF000000);
    Color blue = Theme.of(context).accentColor;
    Color red = Theme.of(context).errorColor;

    return imageUrl == null ? Center(child:CircularProgressIndicator(strokeWidth: 4)) : Scaffold(
      body: Scaffold(
        body: Builder(
          builder: (BuildContext context){
            return Stack(
              children: <Widget>[
                ListView(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height*0.8,
                      alignment: Alignment.topLeft,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.topCenter,
                          image: NetworkImage(imageUrl)
                        )
                      )
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.send, color: white),
                          onPressed: () async {
                            var userId = await Navigator.of(context).push(MaterialPageRoute<int>(
                                builder: (BuildContext context) {
                                  return UserSelectionScreen();
                                },
                                fullscreenDialog: true
                            ));
                            if (userId != null) {
                              bool success = await _recommendMovie(userId);
                              if (success) {
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Recommendation Sent'),
                                  )
                                );
                              }
                            }
                          }
                        ),
                        // IconButton(
                        //   icon: Icon(Icons.share, color: white)
                        // ),
                        IconButton(
                          icon: Icon(Icons.thumb_down, color: _disliked ? red : white),
                          onPressed: () {
                            _respondToMovie(_disliked ? null : false);
                            setState(() {
                                _liked = false;
                                _disliked = _disliked ? false : true;
                            });
                          }
                        ),
                        IconButton(
                          icon: Icon(Icons.thumb_up, color: _liked ? blue : white),
                          onPressed: () {
                            _respondToMovie(_liked ? null : true);
                            setState(() {
                                _liked = _liked ? false : true;
                                _disliked = false;
                            });
                          }
                        )
                      ],
                    ),
                    Card(
                      margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
                      child: Container(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(title, style: TextStyle(fontSize: 24))
                                  ),
                                  Spacer(),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: _ratingTotals("Total:", totalDislikes, totalLikes)
                                  )
                                ]
                              )
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(year, style: TextStyle(fontSize: 16))
                                  ),
                                  Spacer(),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: _ratingTotals("Friends:", totalDislikes, totalLikes)
                                  )
                                ]
                              )
                            ),
                            SizedBox(height:MediaQuery.of(context).size.height*0.015),
                            Text(summary, softWrap: true)  ,
                            // Divider(
                            //   height: 24.0,
                            //   color: white
                            // ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //   children: <Widget>[
                            //     Text('$totalDislikes ' + (totalDislikes == 1 ? 'Total Dislike' : 'Total Dislikes')),
                            //     Text('$totalLikes ' + (totalLikes == 1 ? 'Total Like' : 'Total Likes'))
                            //   ]
                            // ),
                          ]
                        )
                      )
                    )
                  ]
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 5,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width*0.15,
                    child: RawMaterialButton(
                      shape: CircleBorder(),
                      fillColor: black,
                      padding:EdgeInsets.all(10.0),
                      child: Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  )
                )
              ]
            );
          }
        )
      )
    );
  }
}






// SliverAppBar(
//   title: Text(title),
//   expandedHeight: MediaQuery.of(context).size.height*0.80,
//   pinned: true,
//   floating: false,
//   flexibleSpace: FlexibleSpaceBar(
//     background: Image.network(
//       imageUrl,
//       fit: BoxFit.cover
//     ),
//   ),
// ),

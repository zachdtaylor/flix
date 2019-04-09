import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flix_list/screens/friend_movies_screen/friend_movies_screen.dart';
import 'package:flix_list/util/utils.dart';
import 'package:flutter/services.dart' show rootBundle;

class UserScreen extends StatefulWidget {
  UserScreen({Key key, this.userId}) : super(key: key);

  final int userId;

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  String imageUrl = 'http://readyandresilient.army.mil/img/no-profile.png';
  String name;
  String email;
  int followeeCount;
  int followerCount;
  bool following;
  List<dynamic> recentMovies;
  bool _hasQueried = false;

  _getInfo() async {
    QueryResult result = await GraphQLProvider.of(context).value.query(
      QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: await rootBundle.loadString('graphql/users/queries/user_details.gql'),
        variables: {
          'userId': widget.userId,
          'first': 3,
        }
      )
    );
    Map<String, dynamic> data = result.data;
    var user = data['user'];
    // print("<<<<<<<<<<<< user <<<<<<<<<<<<");
    // print(user);
    setState(() {
      name = user['name'];
      email = user['email'];
      followeeCount = user['followeeCount'];
      followerCount = user['followerCount'];
      recentMovies = user['movies']['edges'].map((movie) => movie['node']).toList();
      if (!_hasQueried) {
        following = user['following'];
        _hasQueried = true;
      }
    });
  }

  _respond(String response) async {
    GraphQLProvider.of(context).value.mutate(
      MutationOptions(
        document: await rootBundle.loadString('graphql/users/mutations/$response.gql'),
        variables: {
          'userId': widget.userId
        }
      )
    ).then(
      (response) => _getInfo()
    );
  }

  _follow() {
    _respond('follow');
  }

  _unfollow() {
    _respond('unfollow');
  }

  List<Widget> _recentMovieCovers() {
    List<Widget> covers = [];
    for (dynamic movie in recentMovies) {
      covers.add(
        GestureDetector(
          onTap: () => goToMovieScreen(context, int.parse(movie['tmdbId'])),
          child: Container(
            width: MediaQuery.of(context).size.width*0.25,
            height: MediaQuery.of(context).size.height*0.2,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(movie['cover'])
              )
            ),
          )
        )
      );
    }
    return covers;
  }

  @override
  Widget build(BuildContext context) {
    if (name == null && email == null) {
      _getInfo();
    }

    Color white = Color(0xFFFFFFFF);
    Color black = Color(0xFF000000);
    Color blue = Theme.of(context).accentColor;

    return name == null ? Center(child:CircularProgressIndicator(strokeWidth: 4)) : Scaffold(
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.535,
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                    image: NetworkImage(imageUrl)
                  )
                )
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: GestureDetector(
                  onTap: () {
                    print('<<<<<<<<< following: $following');
                    following ? _unfollow() : _follow();
                    setState(() {
                      following = following ? false : true;
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(following ? 'Following' : 'Follow', style: TextStyle(fontSize: 18)),
                      IconButton(icon: Icon(following ? Icons.check : Icons.add, color: following ? blue : white)),
                    ]
                  )
                ),
              ),
              Card(
                margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(name, style: TextStyle(fontSize: 24))
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(email, style: TextStyle(fontSize: 16))
                      ),
                      SizedBox(height:MediaQuery.of(context).size.height*0.015),
                      Divider(
                        height: 24.0,
                        color: white
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('Followers: $followerCount'),
                          Text('Following: $followeeCount')
                        ]
                      )
                    ]
                  )
                )
              ),
              Card(
                margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text('Recent Movies', style: TextStyle(fontSize: 24)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: _recentMovieCovers()
                        )
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FriendMoviesScreen(
                              userId: widget.userId,
                              name: name
                            )
                          )
                        ),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text('SEE ALL', style: TextStyle(color: blue))
                          )
                        )
                      )
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
      )
    );
  }
}

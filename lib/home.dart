import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:badges/badges.dart';

import 'screens/feed_screen/feed_screen.dart';
import 'screens/my_movies_screen/my_movies_screen.dart';
import 'screens/friends_screen/friends_screen.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  int _notificationCount = 0;
  final List<Widget> _children = [FeedScreen(), MyMoviesScreen(), FriendsScreen()];
  final List<String> _titles = ["Feed", "My Movies", "Friends"];
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
        var page = _pageController.page.round();
        if (page == 0) _getUnreadNotificationCount();
        setState((){
            _currentIndex = page;
        });
    });
  }

  Future<void> _getUnreadNotificationCount() async {
    QueryResult result = await GraphQLProvider.of(context).value.query(
      QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: await rootBundle.loadString('graphql/users/queries/notification_count.gql')
      )
    );
    if (result.errors == null || result.errors.length == 0) {
      setState(() {
        _notificationCount = result.data['user']['unreadNotificationCount'];
      });
    }
  }

  void _onTabTapped(int index) {
    if (index == 0) _getUnreadNotificationCount();
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease
    );
  }

  _feedActions(context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.filter_list, color: Colors.white),
        tooltip: "Filter"
      ),
      BadgeIconButton(
        itemCount: _notificationCount, // required
        icon: Icon(Icons.notifications), // required
        badgeColor: Theme.of(context).accentColor, // default: Colors.red
        badgeTextColor: Colors.white, // default: Colors.white
        hideZeroCount: true, // default: true
        onPressed: () => Navigator.pushNamed(context, '/notifications'),
      ),
    ];
  }

  _movieActions(context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.filter_list, color: Colors.white),
        tooltip: "Filter"
      ),
      IconButton(
        icon: Icon(Icons.search, color: Colors.white),
        tooltip: "Search",
        onPressed: () {
          Navigator.pushNamed(context, '/search/movies');
        },
      )
    ];
  }

  _followerActions(context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.filter_list, color: Colors.white),
        tooltip: "Filter"
      ),
      IconButton(
        icon: Icon(Icons.search, color: Colors.white),
        tooltip: "Search",
        onPressed: () {
          Navigator.pushNamed(context, '/search/users');
        },
      )
    ];
  }

  List<Widget> _actions(context, index) {
    if (index == 0) return _feedActions(context);
    else if (index == 1) return _movieActions(context);
    else return _followerActions(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        actions: _actions(context, _currentIndex)
      ),
      body: PageView(
        children: _children,
        controller: _pageController,
        scrollDirection: Axis.horizontal,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.movie), title: Text(_titles[0])),
          BottomNavigationBarItem(icon: Icon(Icons.list), title: Text(_titles[1])),
          BottomNavigationBarItem(icon: Icon(Icons.people), title: Text(_titles[2]))
        ],
        onTap: _onTabTapped,
        currentIndex: _currentIndex,
        fixedColor: Theme.of(context).toggleableActiveColor
      ),
    );
  }
}

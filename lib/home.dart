import 'package:flutter/material.dart';
import 'package:badges/badges.dart';

import 'package:flix_list/util/graphql/graphql_query.dart';
import 'package:flix_list/util/graphql/graphql_constants.dart';

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
  bool _showFloatingButton = true;
  final List<String> _titles = ["Friends' Recent Ratings", "My Movies", "Following"];
  final List<String> _tabs = ["Home", "My Movies", "Following"];
  List<Widget> _children = [];
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

    _children = [
      FeedScreen(),
      MyMoviesScreen(showButton: _showButton),
      FriendsScreen(showButton: _showButton)
    ];

      _getUnreadNotificationCount();
  }

  Future<void> _getUnreadNotificationCount() async {
    GraphqlQuery(operation: GQL_Q_NOTIFICATION_COUNT).execute()
    .then((Map<String, dynamic> result){
      print(result);
      setState(() {
          _notificationCount = result['user']['unreadNotificationCount'];
      });
    })
    .catchError((error) {
      print(error);
    });
  }

  void _onTabTapped(int index) {
    if (index == 0) _getUnreadNotificationCount();
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease
    );
  }

  _showButton(value) {
    if (value != _showFloatingButton){
      setState(() {
          _showFloatingButton = value;
      });
    }
  }

  _floatingButton() {
    if (_currentIndex > 0) {
      String path = _currentIndex == 1 ? '/search/movies' : '/search/users';
      return FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, path),
        child: Icon(Icons.add,)
      );
    } else {
      return null;
    }
  }

  _feedActions(context) {
    return <Widget>[
      // IconButton(
      //   icon: Icon(Icons.filter_list, color: Colors.white),
      //   tooltip: "Filter"
      // ),
      BadgeIconButton(
        itemCount: _notificationCount, // required
        icon: Icon(Icons.notifications), // required
        badgeColor: Theme.of(context).accentColor, // default: Colors.red
        badgeTextColor: Colors.white, // default: Colors.white
        hideZeroCount: true, // default: true
        onPressed: () {
          Navigator.pushNamed(context, '/notifications');
          _notificationCount = 0;
        },
      ),
    ];
  }

  _movieActions(context) {
    return <Widget>[
      // IconButton(
      //   icon: Icon(Icons.filter_list, color: Colors.white),
      //   tooltip: "Filter"
      // ),
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
      // IconButton(
      //   icon: Icon(Icons.filter_list, color: Colors.white),
      //   tooltip: "Filter"
      // ),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text(_tabs[0])),
          BottomNavigationBarItem(icon: Icon(Icons.list), title: Text(_tabs[1])),
          BottomNavigationBarItem(icon: Icon(Icons.people), title: Text(_tabs[2]))
        ],
        onTap: _onTabTapped,
        currentIndex: _currentIndex,
        fixedColor: Theme.of(context).toggleableActiveColor
      ),
      floatingActionButton: _showFloatingButton ? _floatingButton() : null,
    );
  }
}

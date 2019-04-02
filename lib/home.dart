import 'package:flutter/material.dart';

import 'screens/feed_screen/feed_screen.dart';
import 'screens/my_movies_screen/my_movies_screen.dart';
import 'screens/friends_screen/friends_screen.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [FeedScreen(), MyMoviesScreen(), FriendsScreen()];
  final List<String> _titles = ["Feed", "My Movies", "Friends"];
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
        setState((){
            _currentIndex = _pageController.page.round();
        });
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      // _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease
      );
    });
  }

  _feedActions(context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.filter_list, color: Colors.white),
        tooltip: "Filter"
      ),
      IconButton(
        icon: Icon(Icons.notifications, color: Colors.white),
        tooltip: "Notification",
      )
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

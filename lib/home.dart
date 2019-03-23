import 'package:flutter/material.dart';
import 'screens/movie_screen/movie_screen.dart';
import 'screens/my_movies_screen/my_movies_screen.dart';
import 'screens/friends_screen/friends_screen.dart';
import 'movie_search_delegate.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [MovieScreen(), MyMoviesScreen(), FriendsScreen()];
  final List<String> _titles = ["Movies", "My Movies", "Friends"];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color white = Color(0xFFFFFFFF);
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list, color: white),
            tooltip: "Filter"
          ),
          IconButton(
            icon: Icon(Icons.search, color: white),
            tooltip: "Search",
            onPressed: () {
              showSearch(
                context: context,
                delegate: MovieSearchDelegate()
              );
            },
          )
        ],
      ),
      body: _children[_currentIndex],
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
import 'package:flutter/material.dart';

class MovieCard extends StatefulWidget {
  MovieCard({Key key}) : super(key: key);

  @override
  _MovieCardState createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  final imageSection = Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: NetworkImage("https://www.google.com/url?sa=i&source=images&cd=&cad=rja&uact=8&ved=2ahUKEwjt8e6WzYXhAhUI7IMKHeckB0sQjRx6BAgBEAU&url=http%3A%2F%2Fcollider.com%2Favengers-endgame-new-poster%2F&psig=AOvVaw0KZG7nABkBULEdZEVWz0f8&ust=1552789331058568")
      )
    )
  );

  final voteSection = Container(
    child: Row(
      children: <Widget>[
        IconButton(icon: Icon(Icons.thumb_up)),
        SizedBox(
          width: 18,
          child: Container(
            child: Text('50'),
          ),
        ),
        IconButton(icon: Icon(Icons.thumb_down)),
        SizedBox(
          width: 18,
          child: Container(
            child: Text('25'),
          ),
        )
      ],
    )
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          children: <Widget>[
            imageSection,
            voteSection
          ],
        )
      ),
    );
  }
}
import 'package:flutter/material.dart';

class MovieSearchCard extends StatelessWidget {
  MovieSearchCard({Key key, this.title, this.imageUrl}) : super(key: key);

  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.15,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(imageUrl)
                )
              ),
            )
          ),
          Expanded(
            flex: 4,
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              width:MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(title, softWrap: true, style: TextStyle(fontSize: 18),)
                ],
              ),
            )
          )
        ]
      )
    );
  }

  
}
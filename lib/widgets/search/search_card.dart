import 'package:flutter/material.dart';

class SearchCard extends StatelessWidget {
  SearchCard({Key key, this.title, this.imageUrl, this.loadingImageUrl, this.onTap, this.height}) : super(key: key);

  final String title;
  final String imageUrl;
  final String loadingImageUrl;
  final Function onTap;
  final double height;

  _image() {
    try {
      NetworkImage image = NetworkImage(imageUrl);
      return image;
    } catch (Exception) {
      return AssetImage(loadingImageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Container(
                margin: EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: _image()
                  )
                ),
              )
            ),
            Expanded(
              flex: 16,
              child: Container(
                padding: EdgeInsets.fromLTRB(5, 10, 10, 10),
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
      )
    );
  }


}

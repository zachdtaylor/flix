import 'package:flutter/material.dart';

class SearchCard extends StatelessWidget {
  SearchCard({Key key, this.title, this.imageUrl, this.loadingImageUrl, this.onTap}) : super(key: key);

  final String title;
  final String imageUrl;
  final String loadingImageUrl;
  final Function onTap;

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
              flex: 1,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.15,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: _image()
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
      )
    );
  }


}

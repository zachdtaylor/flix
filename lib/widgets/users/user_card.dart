import 'package:flutter/material.dart';
import 'package:flix_list/util/utils.dart';

class UserCard extends StatelessWidget {
  UserCard({Key key, @required this.child, this.userId}) : super(key: key);

  final int userId;
  final Widget child;
  final String imageUrl = 'http://www.mhbcplan.com/usercontent/TeamImages//missing-profile-female.jpg';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color:Color(0xFFFFFFFF),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 17,
              child: GestureDetector(
                onTap: () => goToUserScreen(context, userId),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(imageUrl)
                    )
                  ),
                )
              )
            ),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[ child ],
              )
            )
          ],
        )
      )
    );
  }
}
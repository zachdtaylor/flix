import 'package:flutter/material.dart';
import 'package:flix_list/util/utils.dart';

class UserCard extends StatelessWidget {
  UserCard({Key key, @required this.child, this.userId, this.onTap}) : super(key: key);

  final int userId;
  final Widget child;
  final String imageUrl = 'http://readyandresilient.army.mil/img/no-profile.png';
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: this.onTap != null ? () => this.onTap(userId) : () => goToUserScreen(context, userId),
        child: Card(
          color:Color(0xFFFFFFFF),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 15,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(imageUrl)
                    )
                  ),
                )
              ),
              Expanded(
                flex: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[ child ],
                )
              )
            ],
          )
        )
      )
    );
  }
}

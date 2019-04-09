import 'package:flutter/material.dart';
import 'package:flix_list/util/utils.dart';
import 'package:flix_list/widgets/search/search_card.dart';

class UserSearchCard extends StatelessWidget {
  UserSearchCard({Key key, this.userId, this.name, this.profileUrl}) : super(key: key);

  final int userId;
  final String name;
  final String profileUrl;

  @override
  Widget build(BuildContext context) {
    return SearchCard(
      title: name,
      imageUrl: profileUrl,
      loadingImageUrl: 'images/cover_unavailable.jpg',
      onTap: () => goToUserScreen(context, userId),
      height: 0.1
    );
  }

}

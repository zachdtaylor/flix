import 'package:flutter/material.dart';
import 'package:flix_list/widgets/users/user_grid.dart';

class FriendsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return UserGrid(
      query: 'graphql/users/queries/paginated_users.gql',
      emptyText: 'You haven\'t followed anyone yet!',
      buildNameBar: (name) => Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF000000))),
      resultData: (data) {
        var usersData = data['user']['followees']['edges'];
        return usersData.map((user) => user['node']).toList();
      },
      pageData: (data) => data['user']['followees']['pageInfo'],
    );
  }
}
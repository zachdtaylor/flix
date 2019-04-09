import 'package:flutter/material.dart';
import 'package:flix_list/widgets/users/user_grid.dart';

class UserSelectionScreen extends StatelessWidget {
  UserSelectionScreen({Key key, this.showButton, this.onSelect}) : super(key: key);
  final Function(bool) showButton;
  final Function(int) onSelect;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: const Text('Send to...'),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.search, color: Colors.white),
        //     tooltip: "Search",
        //     onPressed: () {
        //       Navigator.pushNamed(context, '/search/users');
        //     },
        //   )
        // ]
      ),
      body: UserGrid(
        showButton: showButton,
        query: 'graphql/users/queries/paginated_users.gql',
        emptyText: 'You haven\'t followed anyone yet!',
        buildNameBar: (name) => Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF000000))),
        onTap: (userId) {
          Navigator.of(context).pop(userId);
        },
        resultData: (data) {
          var usersData = data['user']['followees']['edges'];
          return usersData.map((user) => user['node']).toList();
        },
        pageData: (data) => data['user']['followees']['pageInfo'],
      )
    );
  }
}

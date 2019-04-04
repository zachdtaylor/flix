import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flix_list/widgets/search/search.dart';
import 'package:flix_list/screens/user_search_screen/user_search_card.dart';

class UserSearchScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Search(
      search: (String searchText) async {
        QueryResult result = await GraphQLProvider.of(context).value.query(
          QueryOptions(
            document: await rootBundle.loadString('graphql/users/queries/search_users.gql'),
            variables: {
              'text': searchText,
            }
          )
        );
        Map<String, dynamic>  data = result.data;
        return data['searchUsers']['edges'].map((user) => user['node']).toList();
      },
      buildResult: (user) {
        var userId = int.parse(user['userId']);
        var name = user['name'];
        var profile = 'https://meng.uic.edu/wp-content/uploads/sites/92/2018/07/empty-profile.png'; //user['profile'];
        return UserSearchCard(userId: userId, name: name, profileUrl: profile);
      }
    );
  }
}

import 'package:flix_list/util/graphql/graphql_operation.dart';
import 'package:flix_list/util/graphql/graphql_exception.dart';

import 'dart:async';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/services.dart';

class GraphqlQuery extends GraphqlOperation {
  GraphqlQuery({String operation}) : super(operation: operation);

  Future<Map<String, dynamic>> execute({Map<String, dynamic> variables}) async {
    QueryResult result = await this.client.query(
      QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: await rootBundle.loadString(this.operation),
        variables: variables
      )
    );

    if (result.errors != null && result.errors.length > 0) {
      throw GraphqlException(result.errors.join(','));
    }

    return result.data;
  }

}

// Example query
// import 'package:flix_list/util/graphql/graphql_query.dart';
// import 'package:flix_list/util/graphql/graphql_constants.dart';
// class Example extends StatefulWidget {
//   @override
//   _ExampleState createState() => _ExampleState();
// }

// class _ExampleState extends State<Example> with Pagination {

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   })

//   _loadData() {
//     // toggle loading flag or something
//     GraphqlQuery(operation: SOME_CONSTANT_PATH)
//     .execute({'variable': 5})
//     .then((result){
//       // store data in state or whatever
//     })
//     .catchError((error){
//       print(error);
//       // handle data

//     })
//   }
// }

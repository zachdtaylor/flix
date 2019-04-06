import 'package:flix_list/util/graphql/graphql_page_info.dart';
import 'package:flutter/material.dart';
import 'dart:async';

abstract class Pagination {
  GraphqlPageInfo pageInfo = GraphqlPageInfo();
  ScrollController paginationController;
  Timer debounce;

  Map<String, dynamic> paginatedVariables({Map<String, dynamic> variables}) {
    variables.addAll({
      'after': pageInfo.endCursor,
      'first': pageInfo.pageSize
    });
    return variables;
  }

  initializePaginationController({Function callback}) {
    paginationController = ScrollController();
    paginationController.addListener(() {
      if (paginationController.position.extentAfter < 200) {
        if (debounce?.isActive ?? false) debounce.cancel();
        debounce = Timer(const Duration(milliseconds: 500), () {
            callback();
        });
      }
    });
  }
}


// Examples with pagination
// import 'package:flix_list/util/graphql/graphql_query.dart';
// import 'package:flix_list/util/graphql/pagination.dart';
// import 'package:flix_list/util/graphql/graphql_constants.dart';
// class Example extends StatefulWidget {
//   @override
//   _ExampleState createState() => _ExampleState();
// }

// class _ExampleState extends State<Example> with Pagination {

//   @override
//   void initState() {
//     super.initState();
//     _loadMoreData();
//   })

//   // Everytime load more data is called it will grab the next page available
//   _loadMoreData() {
//     // toggle loading flag or something
//     GraphqlQuery(operation: SOME_CONSTANT_PATH)
//     .execute(_paginatedVariables({'variable': 5}))
//     .then((result){
//       _pageInfo.update(result['data']['pageInfo'])
//       // store data in state or whatever
//     })
//     .catchError((error){
//       print(error);
//       // handle data

//     })
//   }

//   _resetPagination() {
//     // reloading page or something
//     _pageInfo.reset();
//   }
// }

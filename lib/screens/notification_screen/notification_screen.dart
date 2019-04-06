import 'package:flutter/material.dart';
import 'package:flix_list/util/graphql/pagination.dart';
import 'package:flix_list/util/graphql/graphql_query.dart';
import 'package:flix_list/util/graphql/graphql_constants.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with Pagination{
  List<dynamic> _notifications = [];
  bool _loading = true;
  bool _hasQueried = false;

  @override
  initState(){
    super.initState();
    _loadData();
    initializePaginationController(callback: _loadData);
  }

  _loadData() {
    setState((){
      _loading = true;
    });
    GraphqlQuery(operation: GQL_Q_NOTIFICATIONS)
    .execute()
    .then((Map<String, dynamic> result) {
      var info = result['user']['notifications']['pageInfo'];
      pageInfo.update(info: info);

      var data = result['user']['notifications']['edges'].map((edge) => edge['node']).toList();
      setState((){
        _notifications.addAll(data);
        _loading = false;
      });
    })
    .catchError((error){
      print('In error');
      print(error.toString());
      setState((){
        _loading = false;
      });
    });
  }

  Future<void> _refresh() async {
    pageInfo.reset();
    setState((){
      _notifications = [];
    });
    await _loadData();
  }

  Widget _recomendationNotification(notification) {
    return Text(notification['fromUser']['name'] + " has recommended you a movie.\nCheck out " + notification['movie']['title']);
  }

  Widget _newFollowerNotification(notification) {
    return Text(notification['follower']['name'] + " is now following you.");
  }

  Widget _child(){
    Widget view;
    if (_hasQueried && _notifications.isEmpty) {
      view = SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          margin: EdgeInsets.only(left: 32, right: 32),
          child: Center(
            child: Text('You have no notifications', textAlign: TextAlign.center,)
          )
        )
      );
    } else {
      view = ListView.builder(
        controller: paginationController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _notifications != null ? _notifications.length : 0,
        itemBuilder: (context, index) {
          var notification = _notifications[index];
          String type = notification['__typename'];
          print(type);
          switch(type) {
            case "MovieRecomendationNotificationType":
            return _recomendationNotification(notification);
            case "NewFollowerNotificationType":
            return _newFollowerNotification(notification);
            default:
            print('Bad notification type');
            return null;
          }
        }
      );
    }

    return _loading ? Center(child: CircularProgressIndicator(strokeWidth: 4,)) : RefreshIndicator(
      onRefresh: _refresh,
      child: view
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Container(
        child: _child()
      )
    );
  }
}

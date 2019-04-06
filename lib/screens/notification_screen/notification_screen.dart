import 'package:flutter/material.dart';
import 'package:flix_list/util/graphql/pagination.dart';
import 'package:flix_list/util/graphql/graphql_query.dart';
import 'package:flix_list/util/graphql/graphql_mutation.dart';
import 'package:flix_list/util/graphql/graphql_constants.dart';
import 'package:flix_list/util/utils.dart';

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
        _hasQueried = true;
      });

      GraphqlMutation(operation: GQL_M_MARK_ALL_READ).execute();
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
    return GestureDetector(
      onTap: () => goToMovieScreen(context, int.parse(notification['movie']['tmdbId'])),
      child: Container(
        child: Card(
          child: Row(
            children: <Widget>[
              Column(
                children:<Widget>[
                  Container(
                    child: Container(
                      margin: EdgeInsets.only(left: 8, top: 6, bottom: 6),
                      width: MediaQuery.of(context).size.width * 0.18,
                      height: MediaQuery.of(context).size.height * 0.12,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(notification['movie']['cover'])
                        )
                      ),
                    )
                  )
                ]
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0)
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    Text(
                      notification['fromUser']['name'] + " has recommended the movie " + notification['movie']['title'] + " to you.",
                      textAlign: TextAlign.center
                    )
                  ]
                )
              )
            ]
          )
        )
      )
    );
  }

  Widget _newFollowerNotification(notification) {
    return GestureDetector(
      onTap: () => goToUserScreen(context, int.parse(notification['follower']['userId'])),
      child: Container(
        child: Card(
          child: Row(
            children: <Widget>[
              Column(
                children:<Widget>[
                  Container(
                    child: Container(
                      margin: EdgeInsets.only(left: 8, top: 6, bottom: 6),
                      width: MediaQuery.of(context).size.width * 0.18,
                      height: MediaQuery.of(context).size.height * 0.12,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage('http://readyandresilient.army.mil/img/no-profile.png')
                        )
                      ),
                    )
                  )
                ]
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0)
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    Text(
                      notification['follower']['name'] + " is now following you.",
                      textAlign: TextAlign.center
                    ),
                  ]
                )

              )
            ]
          )
        )
      )
    );
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

      var length = _notifications.length + 1;
      var readIndex = _notifications.indexWhere((notification) => notification['read'] == true);
      if (readIndex != -1) {
       length += 1;
      }

      view = ListView.builder(
        controller: paginationController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _notifications != null ? length : 0,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Card(
              child: Container(
                margin: EdgeInsets.all(12),
                child: Text('New')
              )
            );
          }
          if (readIndex != -1 && index == readIndex + 1) {
            return Card(
              margin: EdgeInsets.only(top: 12, bottom: 4),
              child: Container(
                margin: EdgeInsets.all(12),
                child: Text('Earlier')
              )
            );
          }
          var pos = index - 1;
          if (readIndex != -1 && index > readIndex + 1) pos -= 1;

          var notification = _notifications[pos];
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

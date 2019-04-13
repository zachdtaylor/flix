class GraphqlPageInfo {

  bool hasNextPage = true;
  String startCursor;
  String endCursor;
  int pageSize = 25;

  void update({Map<String, dynamic> info}) {
    if (info.containsKey('hasNextPage')) hasNextPage = info['hasNextPage'];
    if (info.containsKey('startCursor') && info['startCursor'] != null) startCursor = info['startCursor'];
    if (info.containsKey('endCursor') && info['endCursor'] != null) endCursor = info['endCursor'];
  }

  void reset() {
    hasNextPage = true;
    startCursor = null;
    endCursor = null;
  }
}

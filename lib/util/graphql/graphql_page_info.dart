class GraphqlPageInfo {

  bool hasNextPage = true;
  String startCursor;
  String endCursor;
  int pageSize = 25;

  void update({Map<String, dynamic> info}) {
    if (info.containsKey('hasNextPage')) hasNextPage = info['hasNextPage'];
    if (info.containsKey('startCursor')) startCursor = info['startCursor'];
    if (info.containsKey('endCursor')) endCursor = info['endCursor'];
  }

  void reset() {
    hasNextPage = true;
    startCursor = null;
    endCursor = null;
  }
}

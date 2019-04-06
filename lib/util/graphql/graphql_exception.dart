class GraphqlException implements Exception {
  final String message;
  const GraphqlException([this.message = ""]);
  String toString() => "GraphqlException: $message";
}

class ApiException implements Exception {
  ApiException(this.errorMessage);

  dynamic errorMessage;

  @override
  String toString() => errorMessage;
  // String toString() {
  //   return ErrorFilter.check(errorMessage).error;
  // }
}

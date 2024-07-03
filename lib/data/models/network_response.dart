class NetworkResponse {
  final int statusCode;
  final bool isSuccess;
  final dynamic responseData;
  final String? errorMassege;

  NetworkResponse(
      {required this.statusCode,
      required this.isSuccess,
      this.responseData,
      this.errorMassege = 'Something went wrong'});
}

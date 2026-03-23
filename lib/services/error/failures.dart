class RemoteFailure {
  final int statusCode;
  final String message;

  const RemoteFailure({
    required this.statusCode,
    required this.message,
  });
}

// statusCode code
// 12163 => No internet connection / Disconnected
// 12133 => No data / End of Data

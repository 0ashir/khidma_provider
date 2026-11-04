class HandymanStatusUpdateResult {
  final bool error;
  final String message;
  final String newStatus;

  const HandymanStatusUpdateResult({
    required this.error,
    required this.message,
    required this.newStatus,
  });

  factory HandymanStatusUpdateResult.fromJson(Map<String, dynamic> json) {
    return HandymanStatusUpdateResult(
      error: json['error'] == true,
      message: json['message']?.toString() ?? '',
      newStatus: json['new_status']?.toString() ?? '',
    );
  }
}

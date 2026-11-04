class ReportReasonModel {
  final String? id;
  final String? reason;
  final String? translatedReason;
  final String? needsAdditionalInfo;
  final String? type;

  ReportReasonModel({
    this.id,
    this.reason,
    this.translatedReason,
    this.needsAdditionalInfo,
    this.type,
  });

  ReportReasonModel copyWith({
    String? id,
    String? reason,
    String? needsAdditionalInfo,
    String? translatedReason,
    String? type,
  }) {
    return ReportReasonModel(
      id: id ?? this.id,
      reason: reason ?? this.reason,
      translatedReason: translatedReason ?? this.translatedReason,
      needsAdditionalInfo: needsAdditionalInfo ?? this.needsAdditionalInfo,
      type: type ?? this.type,
    );
  }

  ReportReasonModel.fromJson(Map<String, dynamic> json)
    : id = json['id']?.toString() ?? '',
      reason = json['reason']?.toString() ?? '',
      translatedReason =
          (json['translated_reason']?.toString() ?? '').isNotEmpty
          ? json['translated_reason'].toString()
          : (json['reason']?.toString() ?? ''),

      needsAdditionalInfo = json['needs_additional_info']?.toString() ?? '',
      type = json['type']?.toString() ?? '';

  Map<String, dynamic> toJson() => {
    'id': id,
    'reason': reason,
    'translated_reason': translatedReason,
    'needs_additional_info': needsAdditionalInfo,
    'type': type,
  };
}

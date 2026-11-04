import 'package:edemand_partner/app/generalImports.dart';

enum VerificationRequestStatus { none, pending, approved, disapproved }

class VerificationStatusModel {
  VerificationStatusModel({
    required this.canSubmit,
    required this.status,
    this.rejectionReason,
    this.submittedAt,
    this.reviewedAt,
    required this.submittedFields,
    required this.submittedValues,
    required this.fields,
  });

  factory VerificationStatusModel.fromJson(Map<String, dynamic> json) {
    VerificationRequestStatus status;
    switch (json['status']?.toString()) {
      case '0':
        status = VerificationRequestStatus.pending;
        break;
      case '1':
        status = VerificationRequestStatus.approved;
        break;
      case '2':
        status = VerificationRequestStatus.disapproved;
        break;
      default:
        status = VerificationRequestStatus.none;
    }

    // Parse the submitted `values` array into CustomFieldModel + initialValues map
    // so they can be rendered by the existing CustomFieldsForm widget.
    final List<CustomFieldModel> submittedFields = [];
    final Map<String, dynamic> submittedValues = {};

    if (json['values'] is List) {
      final sorted = List<Map<String, dynamic>>.from(
        (json['values'] as List).map((e) => Map<String, dynamic>.from(e)),
      )..sort((a, b) {
          final aSort = int.tryParse(a['sort_order']?.toString() ?? '0') ?? 0;
          final bSort = int.tryParse(b['sort_order']?.toString() ?? '0') ?? 0;
          return aSort.compareTo(bSort);
        });

      for (final entry in sorted) {
        final id = entry['custom_field_id']?.toString() ?? '';
        final value = entry['value']?.toString() ?? '';

        // Build a map compatible with CustomFieldModel.fromJson
        final fieldMap = <String, dynamic>{
          'id': id,
          'original_label': entry['field_label'] ?? '',
          'field_type': entry['field_type'] ?? 'text',
          'field_options': entry['field_options'],
          'sort_order': entry['sort_order']?.toString() ?? '0',
          'required': '0',
          'visible': '1',
          'field_group': '',
        };

        submittedFields.add(CustomFieldModel.fromJson(fieldMap));
        submittedValues[id] = value;
      }
    }

    return VerificationStatusModel(
      canSubmit: json['can_submit'] == true || json['can_submit'] == 1,
      status: status,
      rejectionReason: json['rejection_reason']?.toString(),
      submittedAt: json['submitted_at']?.toString(),
      reviewedAt: json['reviewed_at']?.toString(),
      submittedFields: submittedFields,
      submittedValues: submittedValues,
      fields: json['fields'] is List
          ? (json['fields'] as List).map((e) {
              final Map<String, dynamic> map = Map.from(e);
              map['original_label'] ??= map['field_label'];
              return CustomFieldModel.fromJson(map);
            }).toList()
          : <CustomFieldModel>[],
    );
  }

  final bool canSubmit;
  final VerificationRequestStatus status;
  final String? rejectionReason;
  final String? submittedAt;
  final String? reviewedAt;

  /// Fields reconstructed from the submitted `values` array — used with
  /// [CustomFieldsForm] in read-only mode to display what was submitted.
  final List<CustomFieldModel> submittedFields;

  /// Keyed by custom_field_id — the submitted values for pre-populating the
  /// read-only [CustomFieldsForm].
  final Map<String, dynamic> submittedValues;

  /// The editable field definitions returned by the server (used when [canSubmit] is true).
  final List<CustomFieldModel> fields;
}

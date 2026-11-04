enum CustomFieldType { text, number, textarea, file, dropdown }

class CustomFieldModel {
  final int id;
  final String name; // mapped from translated/original label
  final String placeholder; // hint text; falls back to [name] when empty
  final CustomFieldType type;
  final String fieldGroup;
  final List<String> allowedExtensions;
  final List<String> options;
  final bool isRequired;
  final bool isVisible;
  final int sortOrder;

  CustomFieldModel({
    required this.id,
    required this.name,
    this.placeholder = '',
    required this.type,
    required this.fieldGroup,
    required this.allowedExtensions,
    this.options = const [],
    required this.isRequired,
    required this.isVisible,
    required this.sortOrder,
  });

  factory CustomFieldModel.fromJson(Map<String, dynamic> json) {
    CustomFieldType type = CustomFieldType.text;
    switch (json['field_type']) {
      case 'number':
        type = CustomFieldType.number;
        break;
      case 'textarea':
        type = CustomFieldType.textarea;
        break;
      case 'file':
        type = CustomFieldType.file;
        break;
      case 'dropdown':
        type = CustomFieldType.dropdown;
        break;
      case 'text':
      default:
        type = CustomFieldType.text;
        break;
    }

    List<String> extensions = [];
    if (json['file_config'] != null &&
        json['file_config']['allowed_types'] != null) {
      if (json['file_config']['allowed_types'] is List) {
        extensions = List<String>.from(json['file_config']['allowed_types']);
      }
    }

    List<String> options = [];
    if (json['field_options'] is List) {
      options = List<String>.from(
        (json['field_options'] as List).map((e) => e.toString()),
      );
    }

    final String name = json['label']?.toString() ?? '';
    final String placeholder = json['placeholder']?.toString() ?? '';

    return CustomFieldModel(
      id: int.tryParse((json['id'] ?? '0').toString()) ?? 0,
      name: name,
      placeholder: placeholder.isEmpty ? name : placeholder,
      type: type,
      fieldGroup: json['field_group']?.toString() ?? '',
      allowedExtensions: extensions,
      options: options,
      isRequired: json['required']?.toString() == '1',
      isVisible: json['visible']?.toString() == '1',
      sortOrder: int.tryParse(json['sort_order']?.toString() ?? '0') ?? 0,
    );
  }
}

class CustomFieldsResponse {
  final List<CustomFieldModel> fields;
  final Map<String, dynamic> savedValues;

  CustomFieldsResponse({required this.fields, required this.savedValues});
}

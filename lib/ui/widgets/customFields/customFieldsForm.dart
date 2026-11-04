import '../../../../app/generalImports.dart';

class CustomFieldsForm extends StatefulWidget {
  const CustomFieldsForm({
    super.key,
    required this.fields,
    this.initialValues,
    this.readOnly = false,
  });

  final List<CustomFieldModel> fields;
  final Map<String, dynamic>? initialValues;

  /// When true the form is displayed in read-only mode — all fields are
  /// non-interactive (no input, no file picking).
  final bool readOnly;

  @override
  State<CustomFieldsForm> createState() => CustomFieldsFormState();
}

class CustomFieldsFormState extends State<CustomFieldsForm> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, PlatformFile> _pickedFiles = {};

  @override
  void initState() {
    super.initState();
    for (final field in widget.fields) {
      final initial =
          widget.initialValues?[field.id.toString()]?.toString() ?? '';
      _controllers[field.id.toString()] = TextEditingController(text: initial);
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  List<Map<String, dynamic>> getValues() {
    final result = <Map<String, dynamic>>[];
    for (final field in widget.fields) {
      dynamic val;
      if (field.type == CustomFieldType.file) {
        final picked = _pickedFiles[field.id.toString()];
        if (picked != null && picked.path != null) {
          val = picked.path;
        }
      } else {
        val = _controllers[field.id.toString()]?.text.trim() ?? '';
      }

      if (val != null) {
        result.add({
          "custom_field_id": field.id,
          "value": val,
          "type": field.type.name,
        });
      }
    }
    return result;
  }

  Map<String, dynamic> getKeyValueMap() {
    final Map<String, dynamic> result = {};
    for (final field in widget.fields) {
      dynamic val;
      if (field.type == CustomFieldType.file) {
        final picked = _pickedFiles[field.id.toString()];
        if (picked != null && picked.path != null) {
          val = picked.path;
        } else {
          val = _controllers[field.id.toString()]?.text.trim() ?? '';
        }
      } else {
        val = _controllers[field.id.toString()]?.text.trim() ?? '';
      }
      if (val != null && val != '') {
        result[field.id.toString()] = val;
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.fields.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.fields.map((field) {
        return CustomField(
          key: ValueKey(field.id.toString()),
          field: field,
          controller: _controllers[field.id.toString()]!,
          readOnly: widget.readOnly,
          onFilePicked: widget.readOnly
              ? null
              : (file) {
                  _pickedFiles[field.id.toString()] = file;
                },
        );
      }).toList(),
    );
  }
}

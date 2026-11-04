import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import '../../../../app/generalImports.dart';

// ─── File-type categories (mirrors server-side classification) ─────────────────

enum _FileCategory { image, video, audio, document, other }

const _imageExts = {
  'jpg',
  'jpeg',
  'png',
  'gif',
  'webp',
  'bmp',
  'svg',
  'tif',
  'tiff',
};
const _videoExts = {'mp4', 'mov', 'avi', 'mkv', 'webm', 'wmv', 'flv', 'm4v'};
const _audioExts = {'mp3', 'wav', 'aac', 'ogg', 'flac', 'm4a', 'wma'};
const _docExts = {
  'pdf',
  'doc',
  'docx',
  'xls',
  'xlsx',
  'ppt',
  'pptx',
  'txt',
  'csv',
  'rtf',
};

_FileCategory _categoryOf(String ext) {
  final e = ext.toLowerCase();
  if (_imageExts.contains(e)) return _FileCategory.image;
  if (_videoExts.contains(e)) return _FileCategory.video;
  if (_audioExts.contains(e)) return _FileCategory.audio;
  if (_docExts.contains(e)) return _FileCategory.document;
  return _FileCategory.other;
}

// ─── Widget ────────────────────────────────────────────────────────────────────

class CustomField extends StatefulWidget {
  const CustomField({
    super.key,
    required this.field,
    required this.controller,
    this.bottomPadding = 10,
    this.onFilePicked,
    this.readOnly = false,
  });

  final CustomFieldModel field;
  final TextEditingController controller;
  final double bottomPadding;
  final void Function(PlatformFile file)? onFilePicked;

  /// When true the field is non-interactive — no typing, no file picking.
  final bool readOnly;

  @override
  State<CustomField> createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  PlatformFile? _pickedFile;
  bool _isPickingFile = false;

  // ── Derived state ────────────────────────────────────────────────────────────

  String get _ext {
    if (_pickedFile != null) {
      return p.extension(_pickedFile!.name).replaceFirst('.', '').toLowerCase();
    }
    final text = widget.controller.text;
    if (text.isEmpty) return '';
    try {
      final path = text.startsWith('http') ? Uri.parse(text).path : text;
      return p.extension(path).replaceFirst('.', '').toLowerCase();
    } catch (_) {
      return '';
    }
  }

  _FileCategory get _category => _categoryOf(_ext);

  bool get _hasFile => _pickedFile != null || widget.controller.text.isNotEmpty;

  /// Returns a valid local path if available (either from active pick or controller).
  String? get _localPath {
    if (_pickedFile?.path != null) return _pickedFile!.path;
    final text = widget.controller.text;
    if (text.isEmpty || text.startsWith('http')) return null;
    // If it's a path (contains separators), return as is.
    if (text.contains('/') || text.contains('\\')) return text;
    return null;
  }

  String get _displayName {
    if (_pickedFile != null) return _pickedFile!.name;
    final text = widget.controller.text;
    if (text.isEmpty) return '';
    return text.startsWith('http')
        ? Uri.parse(
            text,
          ).pathSegments.lastWhere((s) => s.isNotEmpty, orElse: () => text)
        : p.basename(text);
  }

  // ── Actions ──────────────────────────────────────────────────────────────────

  Future<void> _pickDropdownOption(BuildContext context) async {
    final options = widget.field.options;
    if (options.isEmpty) return;

    final itemList = options
        .map(
          (option) => {
            'title': option,
            'id': option,
            'isSelected': option == widget.controller.text,
          },
        )
        .toList();

    final result = await UiUtils.showModelBottomSheets(
      context: context,
      child: SelectableListBottomSheet(
        bottomSheetTitle: widget.field.name,
        itemList: itemList,
      ),
    );

    if (result != null && result['selectedItemName'] != null) {
      setState(() {
        widget.controller.text = result['selectedItemName'] as String;
      });
    }
  }

  Future<void> _pickFile() async {
    if (_isPickingFile) return;
    _isPickingFile = true;
    try {
      final exts = widget.field.allowedExtensions.isEmpty
          ? null
          : widget.field.allowedExtensions;
      final result = await FilePicker.platform.pickFiles(
        type: exts != null ? FileType.custom : FileType.any,
        allowedExtensions: exts,
      );
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        _pickedFile = file;
        widget.controller.text = file.name;
        widget.onFilePicked?.call(file);
        setState(() {});
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("File picking error: $e");
      }
    } finally {
      Future.delayed(const Duration(milliseconds: 300), () {
        _isPickingFile = false;
      });
    }
  }

  Future<void> _viewFile() async {
    final path = _localPath;
    if (path != null) {
      await OpenFile.open(path);
      return;
    }
    final url = widget.controller.text;
    if (!url.startsWith('http')) return;
    if (!mounted) return;

    UiUtils.showMessage(context, 'downloading', ToastificationType.info);
    try {
      final dir = await getApplicationDocumentsDirectory();
      final name = Uri.parse(
        url,
      ).pathSegments.lastWhere((s) => s.isNotEmpty, orElse: () => 'file');
      final savePath = '${dir.path}/$name';
      if (!File(savePath).existsSync()) {
        await Dio().download(url, savePath);
      }
      await OpenFile.open(savePath);
    } catch (_) {
      if (mounted) {
        UiUtils.showMessage(
          context,
          'somethingWentWrong',
          ToastificationType.error,
        );
      }
    }
  }

  // ── Validator ────────────────────────────────────────────────────────────────

  String? _validator(String? value) {
    if (!widget.field.isRequired) return null;
    if (widget.field.type == CustomFieldType.file) {
      if (_pickedFile == null && (value == null || value.trim().isEmpty)) {
        return 'pleaseSelectAFile'.translate(context: context);
      }
    } else {
      if (value == null || value.trim().isEmpty) {
        return 'fieldMustNotBeEmpty'.translate(context: context);
      }
    }
    return null;
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isFile = widget.field.type == CustomFieldType.file;
    final isNumber = widget.field.type == CustomFieldType.number;
    final isTextarea = widget.field.type == CustomFieldType.textarea;
    final isDropdown = widget.field.type == CustomFieldType.dropdown;
    final label = widget.field.isRequired
        ? '${widget.field.name} *'
        : widget.field.name;

    if (isDropdown && !widget.readOnly) {
      return Padding(
        padding: EdgeInsetsDirectional.only(bottom: widget.bottomPadding),
        child: CustomFormDropdown(
          onTap: () => _pickDropdownOption(context),
          initialTitle: label,
          selectedValue: widget.controller.text.isEmpty
              ? null
              : widget.controller.text,
          validator: _validator,
        ),
      );
    } else if (!isFile) {
      return CustomTextFormField(
        bottomPadding: widget.bottomPadding,
        controller: widget.controller,
        labelText: label,
        hintText: widget.field.placeholder,
        isReadOnly: widget.readOnly,
        textInputType: isNumber
            ? TextInputType.number
            : isTextarea
            ? TextInputType.multiline
            : TextInputType.text,
        minLines: isTextarea ? 3 : null,
        inputFormatters: widget.readOnly
            ? null
            : (isNumber ? UiUtils.allowOnlyDigits() : null),
        validator: widget.readOnly ? null : _validator,
      );
    }

    return FormField<String>(
      validator: widget.readOnly ? null : _validator,
      initialValue: widget.controller.text,
      builder: (state) {
        final scheme = context.colorScheme;
        final borderColor = state.hasError
            ? AppColors.redColor
            : scheme.blackColor.withValues(alpha: 0.25);

        return Padding(
          padding: EdgeInsetsDirectional.only(bottom: widget.bottomPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _hasFile
                  ? _buildPreview(context, scheme, state)
                  : widget.readOnly
                  ? _buildPlaceholder(context, scheme, label, borderColor)
                  : GestureDetector(
                      onTap: () async {
                        await _pickFile();
                        state.didChange(widget.controller.text);
                      },
                      child: _buildPlaceholder(
                        context,
                        scheme,
                        label,
                        borderColor,
                      ),
                    ),
              if (state.hasError)
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 12, top: 4),
                  child: CustomText(
                    state.errorText!,
                    fontSize: 10,
                    color: AppColors.redColor,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlaceholder(
    BuildContext context,
    ColorScheme scheme,
    String label,
    Color borderColor,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      constraints: const BoxConstraints(minHeight: 56),
      decoration: BoxDecoration(
        color: scheme.surfaceDim.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Row(
          children: [
            Icon(
              Icons.upload_file_rounded,
              size: 20,
              color: scheme.blackColor.withValues(alpha: 0.45),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CustomText(
                label,
                color: scheme.blackColor.withValues(alpha: 0.55),
                fontSize: 14,
                maxLines: 1,
              ),
            ),
            _chip(
              context,
              'upload'.translate(context: context),
              scheme.accentColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview(
    BuildContext context,
    ColorScheme scheme,
    FormFieldState<String> state,
  ) {
    final isImage = _category == _FileCategory.image;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: scheme.surfaceDim.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: state.hasError
              ? AppColors.redColor
              : scheme.blackColor.withAlpha(50),
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            if (isImage)
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: _localPath != null
                      ? Image.file(File(_localPath!), fit: BoxFit.cover)
                      : CustomCachedNetworkImage(
                          imageUrl: widget.controller.text,
                          fit: BoxFit.cover,
                          width: 60,
                          height: 60,
                        ),
                ),
              )
            else
              _FileTypeBadge(ext: _ext),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    widget.field.name,
                    fontSize: 11,
                    color: scheme.blackColor.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 2),
                  CustomText(
                    _displayName,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: scheme.blackColor,
                    maxLines: 2,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _chip(
                  context,
                  'view'.translate(context: context),
                  scheme.accentColor,
                  icon: Icons.visibility_rounded,
                  onTap: _viewFile,
                ),
                if (!widget.readOnly) ...[
                  const SizedBox(height: 4),
                  _chip(
                    context,
                    'change'.translate(context: context),
                    scheme.lightGreyColor,
                    icon: Icons.edit_rounded,
                    onTap: () async {
                      await _pickFile();
                      state.didChange(widget.controller.text);
                    },
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(
    BuildContext context,
    String label,
    Color color, {
    IconData? icon,
    Future<void> Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap != null ? () => onTap() : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 11, color: color),
              const SizedBox(width: 3),
            ],
            CustomText(
              label,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}

class _FileTypeBadge extends StatelessWidget {
  const _FileTypeBadge({required this.ext});
  final String ext;

  _FileCategory get _category => _categoryOf(ext);

  Color get _color {
    switch (_category) {
      case _FileCategory.image:
        return const Color(0xFF7B1FA2);
      case _FileCategory.video:
        return const Color(0xFF00796B);
      case _FileCategory.audio:
        return const Color(0xFF0288D1);
      case _FileCategory.document:
        switch (ext.toLowerCase()) {
          case 'pdf':
            return const Color(0xFFE53935);
          case 'doc':
          case 'docx':
            return const Color(0xFF1565C0);
          case 'xls':
          case 'xlsx':
            return const Color(0xFF2E7D32);
          case 'ppt':
          case 'pptx':
            return const Color(0xFFE65100);
          default:
            return const Color(0xFF546E7A);
        }
      case _FileCategory.other:
        return const Color(0xFF546E7A);
    }
  }

  IconData get _icon {
    switch (_category) {
      case _FileCategory.image:
        return Icons.image_rounded;
      case _FileCategory.video:
        return Icons.videocam_rounded;
      case _FileCategory.audio:
        return Icons.audiotrack_rounded;
      case _FileCategory.document:
        return Icons.description_rounded;
      case _FileCategory.other:
        return Icons.insert_drive_file_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final label = ext.length > 4
        ? ext.substring(0, 4).toUpperCase()
        : ext.toUpperCase();
    return Container(
      width: 44,
      height: 52,
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_icon, color: _color, size: 22),
          if (label.isNotEmpty)
            CustomText(
              label,
              fontSize: 8,
              fontWeight: FontWeight.w700,
              color: _color,
              letterSpacing: 0.5,
            ),
        ],
      ),
    );
  }
}

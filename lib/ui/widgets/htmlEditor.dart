import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class CustomHTMLEditor extends StatefulWidget {
  final HtmlEditorController controller;
  final bool shouldAutoExpand;
  final String hint;
  final String? initialHTML;
  final Function(String?)? onContentChanged;
  const CustomHTMLEditor({
    super.key,
    required this.controller,
    required this.initialHTML,
    required this.hint,
    this.shouldAutoExpand = true,
    this.onContentChanged,
  });

  @override
  State<CustomHTMLEditor> createState() => _CustomHTMLEditorState();
}

class _CustomHTMLEditorState extends State<CustomHTMLEditor> {
  bool _isDisposed = false;
  bool _isInitialized = false;
  String? _lastInitialContent;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  void didUpdateWidget(CustomHTMLEditor oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only update if content actually changed and is different
    if (_isInitialized &&
        oldWidget.initialHTML != widget.initialHTML &&
        widget.initialHTML != _lastInitialContent &&
        widget.initialHTML != null) {
      _lastInitialContent = widget.initialHTML;

      // Use a gentler approach with less delay
      Future.delayed(const Duration(milliseconds: 100), () {
        if (!_isDisposed && mounted) {
          widget.controller.setText(widget.initialHTML!);
        }
      });
    }
  }

  Future<void> _setContentWithRetry(String content, int attempt) async {
    if (_isDisposed || !mounted || attempt >= 3) return;

    try {
      widget.controller.setText(content);
      await Future.delayed(Duration(milliseconds: 100 * (attempt + 1)));

      // Verify content was set
      final verifyContent = await widget.controller.getText();
      if (verifyContent != content && attempt < 2) {
        _setContentWithRetry(content, attempt + 1);
      } else {}
    } catch (e) {
      if (attempt < 2) {
        Future.delayed(Duration(milliseconds: 200 * (attempt + 1)), () {
          _setContentWithRetry(content, attempt + 1);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isDisposed) {
      return const SizedBox.shrink();
    }

    return HtmlEditor(
      controller: widget.controller,
      htmlEditorOptions: HtmlEditorOptions(
        hint: widget.hint,
        shouldEnsureVisible: true,
        initialText: widget.initialHTML ?? '',
        autoAdjustHeight: true,
        adjustHeightForKeyboard: true,
      ),
      callbacks: Callbacks(
        onInit: () {
          if (!_isDisposed && mounted) {
            _isInitialized = true;
            _lastInitialContent = widget.initialHTML;

            // Enable fullscreen mode for better editing experience
            Future.delayed(const Duration(milliseconds: 100), () {
              if (!_isDisposed && mounted) {
                widget.controller.setFullScreen();
              }
            });

            // Set initial content after initialization
            if (widget.initialHTML != null && widget.initialHTML!.isNotEmpty) {
              Future.delayed(const Duration(milliseconds: 500), () {
                if (!_isDisposed && mounted) {
                  _setContentWithRetry(widget.initialHTML!, 0);
                }
              });
            }
          }
        },
        onChangeContent: (String? content) {
          // Handle content change safely and notify parent
          if (!_isDisposed && mounted && _isInitialized) {
            widget.onContentChanged?.call(content);
          }
        },
      ),
      htmlToolbarOptions: const HtmlToolbarOptions(
        toolbarPosition: ToolbarPosition.aboveEditor,
        toolbarType: ToolbarType.nativeExpandable,
        renderSeparatorWidget: false,
        defaultToolbarButtons: [
          StyleButtons(),
          FontSettingButtons(fontSizeUnit: true),
          FontButtons(clearAll: false),
          ColorButtons(),
          ListButtons(listStyles: false),
          ParagraphButtons(
            textDirection: true,
            lineHeight: true,
            caseConverter: false,
          ),
          InsertButtons(
            video: false,
            audio: false,
            table: true,
            hr: true,
            otherFile: false,
          ),
          OtherButtons(
            fullscreen: true,
            help: false,
            copy: false,
            paste: false,
          ),
        ],
      ),
    );
  }
}

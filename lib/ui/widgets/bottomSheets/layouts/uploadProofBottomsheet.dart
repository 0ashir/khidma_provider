import 'package:flutter/material.dart';

import '../../../../app/generalImports.dart';
import '../../customVideoPlayer/playVideoScreen.dart';

class UploadProofBottomSheet extends StatefulWidget {
  const UploadProofBottomSheet({super.key, this.preSelectedFiles});

  final List<Map<String, dynamic>>? preSelectedFiles;

  @override
  State<UploadProofBottomSheet> createState() => _UploadProofBottomSheetState();
}

class _UploadProofBottomSheetState extends State<UploadProofBottomSheet> {
  late ValueNotifier<List<Map<String, dynamic>>> uploadedMedia;

  @override
  void initState() {
    super.initState();
    // Validate and process pre-selected files
    final List<Map<String, dynamic>> validatedFiles = [];
    if (widget.preSelectedFiles != null) {
      for (final fileData in widget.preSelectedFiles!) {
        // Handle files that are File objects
        if (fileData['file'] != null && fileData['file'] is File) {
          final file = fileData['file'] as File;
          // Determine file type from file path
          final fileType = _getFileTypeFromPath(file.path);
          if (fileType != 'unknown') {
            validatedFiles.add({'file': file, 'fileType': fileType});
          }
        }
        // Handle files that already have fileType set
        else if (fileData['fileType'] != null &&
            (fileData['fileType'] == 'image' ||
                fileData['fileType'] == 'video')) {
          validatedFiles.add(fileData);
        }
      }
    }
    uploadedMedia = ValueNotifier(validatedFiles);
  }

  // Helper method to determine file type from path (static-safe for initState)
  String _getFileTypeFromPath(String filePath) {
    try {
      final extension = filePath.split('.').last.toLowerCase();
      if (_imageExtensions.contains(extension)) {
        return 'image';
      } else if (_videoExtensions.contains(extension)) {
        return 'video';
      }
    } catch (_) {}
    return 'unknown';
  }

  // Supported image extensions
  static const List<String> _imageExtensions = [
    'jpg',
    'jpeg',
    'jfif',
    'pjpeg',
    'pjp',
    'png',
    'gif',
    'apng',
    'webp',
    'avif',
  ];

  // Supported video extensions
  static const List<String> _videoExtensions = [
    '3g2',
    '3gp',
    'avi',
    'flv',
    'm2v',
    'm4v',
    'mkv',
    'mov',
    'mp4',
    'mpe',
    'mpeg',
    'mpg',
    'webm',
    'wmv',
  ];

  // All allowed extensions (images + videos)
  static List<String> get _allowedExtensions => [
    ..._imageExtensions,
    ..._videoExtensions,
  ];

  // Determine file type from file path
  String _getFileType(String filePath) {
    return _getFileTypeFromPath(filePath);
  }

  Future<void> selectMedia() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: _allowedExtensions,
      );

      if (result != null && result.paths.isNotEmpty) {
        final List<Map<String, dynamic>> validFiles = [];

        for (final String? path in result.paths) {
          if (path == null) continue;

          // Check if file type is supported (image or video only)
          final fileType = _getFileType(path);
          if (fileType == 'unknown') {
            // Skip unsupported file types
            continue;
          }

          // Check if file already exists in uploaded media
          bool fileExists = false;
          for (final existingFile in uploadedMedia.value) {
            if (existingFile['file']?.path == path) {
              fileExists = true;
              break;
            }
          }

          if (!fileExists) {
            validFiles.add({'file': File(path), 'fileType': fileType});
          }
        }

        if (validFiles.isNotEmpty) {
          uploadedMedia.value = uploadedMedia.value + validFiles;
        }
      } else {
        // User canceled the picker
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    uploadedMedia.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetLayout(
      title: 'chooseMedia',
      child: ValueListenableBuilder(
        valueListenable: uploadedMedia,
        builder: (BuildContext context, List<Map<String, dynamic>> value, Widget? child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      //if images are there then we will enable scroll
                      physics: value.isEmpty
                          ? const NeverScrollableScrollPhysics()
                          : const AlwaysScrollableScrollPhysics(),
                      child: Row(
                        children: [
                          CustomInkWellContainer(
                            onTap: selectMedia,
                            child: Padding(
                              padding: const EdgeInsetsDirectional.symmetric(
                                vertical: 15,
                                horizontal: 5,
                              ),
                              child: SetDottedBorderWithHint(
                                width: value.isEmpty
                                    ? MediaQuery.sizeOf(context).width - 30
                                    : 100,
                                height: 100,
                                radius: 5,
                                borderColor: Theme.of(
                                  context,
                                ).colorScheme.blackColor,
                                strPrefix: 'chooseMedia'.translate(
                                  context: context,
                                ),
                                str: '',
                              ),
                            ),
                          ),
                          if (value.isNotEmpty)
                            Row(
                              children: List.generate(
                                value.length,
                                (int index) => CustomContainer(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  height: 100,
                                  width: 100,
                                  border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .blackColor
                                        .withValues(alpha: 0.5),
                                  ),
                                  child: Stack(
                                    children: [
                                      // Display image preview
                                      if (value[index]['fileType'] == 'image')
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                          child: Image.file(
                                            File(value[index]['file']!.path),
                                            fit: BoxFit.cover,
                                            width: 100,
                                            height: 100,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Container(
                                                    width: 100,
                                                    height: 100,
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.primaryColor,
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.broken_image,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .lightGreyColor,
                                                      ),
                                                    ),
                                                  );
                                                },
                                          ),
                                        )
                                      // Display video preview with play icon
                                      else if (value[index]['fileType'] ==
                                          'video')
                                        Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primaryColor,
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                          ),
                                          child: CustomInkWellContainer(
                                            child: Center(
                                              child: Icon(
                                                Icons.play_circle_filled,
                                                size: 40,
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.accentColor,
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (BuildContext context) {
                                                    return PlayVideoScreen(
                                                      videoFile:
                                                          value[index]['file'],
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      Align(
                                        alignment: AlignmentDirectional.topEnd,
                                        child: CustomInkWellContainer(
                                          onTap: () async {
                                            //assigning new list, because listener will not notify if we remove the values only to the list
                                            uploadedMedia.value = List.from(
                                              uploadedMedia.value,
                                            )..removeAt(index);
                                          },
                                          child: CustomContainer(
                                            height: 20,
                                            width: 20,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .blackColor
                                                .withValues(alpha: 0.4),
                                            child: const Center(
                                              child: Icon(
                                                Icons.clear_rounded,
                                                size: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              CloseAndConfirmButton(
                closeButtonPressed: () {
                  Navigator.pop(context);
                },
                confirmButtonPressed: () {
                  Navigator.pop(context, uploadedMedia.value);
                },
                confirmButtonName: uploadedMedia.value.isNotEmpty
                    ? 'done'.translate(context: context)
                    : 'skip'.translate(context: context),
              ),
            ],
          );
        },
      ),
    );
  }
}

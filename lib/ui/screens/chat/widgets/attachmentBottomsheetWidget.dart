import 'package:edemand_partner/app/generalImports.dart';

import 'package:flutter/material.dart';

enum AttachmentFileSelectionType { camera, gallery, document }

class AttachmentDialogWidget extends StatefulWidget {
  final Function(List<MessageDocument> selectedFilePaths, bool isImage)
  onItemSelected;
  final Function() onCancel;
  final bool enableImageUpload;
  final bool enableFileUpload;

  const AttachmentDialogWidget({
    super.key,
    required this.onItemSelected,
    required this.onCancel,
    this.enableImageUpload = true,
    this.enableFileUpload = true,
  });

  @override
  State<AttachmentDialogWidget> createState() => _AttachmentDialogWidgetState();
}

class _AttachmentDialogWidgetState extends State<AttachmentDialogWidget> {
  AttachmentFileSelectionType selectionType =
      AttachmentFileSelectionType.camera;

  List<MessageDocument> selectedFiles = [];
  final List<String> selectedFilePaths = [];
  bool loading = false;

  Future<void> onFilesPicked() async {
    setState(() {
      loading = true;
    });
    try {
      List<MessageDocument> tempPaths = [];

      if (selectionType == AttachmentFileSelectionType.document) {
        //document picking logic
        final FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.custom,
          allowedExtensions: [
            // Documents
            'pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx',
            'odt', 'ods', 'odp', 'rtf', 'txt',
            // Archives
            'zip', 'rar', '7z', 'tar', 'gz',
            // Data files
            'csv', 'json', 'xml',
            // Videos
            'mp4', 'mov', 'avi', 'mkv', 'wmv', 'flv', 'webm', 'm4v', '3gp',
          ],
        );

        if (result != null) {
          tempPaths = result.files
              .map(
                (e) => MessageDocument(
                  fileName: e.name,
                  fileSize: e.size,
                  fileType: "document",
                  fileUrl: e.path ?? '',
                ),
              )
              .toList();
        }
      } else if (selectionType == AttachmentFileSelectionType.gallery) {
        //gallery picking logic
        final ImagePicker picker = ImagePicker();
        final result = await picker.pickMultiImage();
        if (result.isNotEmpty) {
          tempPaths = result.map<MessageDocument>((e) {
            return MessageDocument(
              fileName: e.name,
              fileSize: 0,
              fileType: e.mimeType ?? "document",
              fileUrl: e.path,
            );
          }).toList();
        }
      } else {
        //camara picking logic
        final ImagePicker picker = ImagePicker();
        final result = await picker.pickImage(source: ImageSource.camera);
        if (result != null) {
          tempPaths = [
            MessageDocument(
              fileName: result.name,
              fileSize: 0,
              fileType: result.mimeType ?? "image",
              fileUrl: result.path,
            ),
          ];
        }
      }
      int totalNumberOfFilesRemovedBecauseOfMaxNumberLimit = 0;
      int totalNumberOfFilesRemovedBecauseOfMaxSizeLimit = 0;
      for (int i = 0; i < tempPaths.length; i++) {
        if (!selectedFilePaths.contains(tempPaths[i].fileName)) {
          final chatSettings = context
              .read<FetchSystemSettingsCubit>()
              .chatSettings;
          //add if already not added the same file with size and total count validations
          if (selectedFilePaths.length >=
              chatSettings.maxFilesOrImagesInOneMessage) {
            totalNumberOfFilesRemovedBecauseOfMaxNumberLimit++;
          } else if ((await File(tempPaths[i].fileUrl).length()) >=
              (chatSettings.maxFileSizeInMBCanBeSent * 1000000)) {
            totalNumberOfFilesRemovedBecauseOfMaxSizeLimit++;
          } else {
            selectedFiles.add(tempPaths[i]);
            selectedFilePaths.add(tempPaths[i].fileName);
          }
        }
      }
      if (totalNumberOfFilesRemovedBecauseOfMaxNumberLimit != 0 ||
          totalNumberOfFilesRemovedBecauseOfMaxSizeLimit != 0) {
        if (context.mounted) {
          final chatSettings = context
              .read<FetchSystemSettingsCubit>()
              .chatSettings;
          UiUtils.showMessage(
            context,
            "${totalNumberOfFilesRemovedBecauseOfMaxNumberLimit != 0 ? "${"maxAllowedFilesAre".translate(context: context)} ${chatSettings.maxFilesOrImagesInOneMessage}, ${"removed".translate(context: context)} $totalNumberOfFilesRemovedBecauseOfMaxNumberLimit ${"extra".translate(context: context)}." : ''} ${totalNumberOfFilesRemovedBecauseOfMaxSizeLimit != 0 ? "${"removed".translate(context: context)} $totalNumberOfFilesRemovedBecauseOfMaxSizeLimit ${"filesAsTheyExceededTheLimitOf".translate(context: context)}  ${chatSettings.maxFileSizeInMBCanBeSent} ${"mb".translate(context: context)}" : ''}",
            ToastificationType.error,
          );
        }
      }
    } on PlatformException catch (_) {
      if (context.mounted) {
        UiUtils.showMessage(
          context,
          "permissionNotGiven",
          ToastificationType.error,
        );
      }
    } catch (e) {
      if (context.mounted) {
        UiUtils.showMessage(
          context,
          "somethingWentWrongTitle",
          ToastificationType.error,
        );
      }
    }
    loading = false;
    setState(() {});
  }

  void onClickSend() {
    widget.onItemSelected(
      selectedFiles,
      selectionType == AttachmentFileSelectionType.document ? false : true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      borderRadius: UiUtils.borderRadiusOf10,
      color: context.colorScheme.primaryColor,
      child: loading
          ? CustomContainer(
              height: 200,
              alignment: Alignment.center,
              child: SizedBox(
                height: 30,
                width: 30,
                child: CustomCircularProgressIndicator(
                  color: Theme.of(context).colorScheme.accentColor,
                ),
              ),
            )
          : selectedFiles.isEmpty
          ? Builder(
              builder: (context) {
                final options = [
                  if (widget.enableFileUpload)
                    {
                      "image": AppAssets.attFile,
                      "text": "uploadFile".translate(context: context),
                      "onTap": () {
                        selectionType = AttachmentFileSelectionType.document;
                        onFilesPicked();
                      },
                    },
                  if (widget.enableImageUpload)
                    {
                      "image": AppAssets.camera,
                      "text": "takePhoto".translate(context: context),
                      "onTap": () {
                        selectionType = AttachmentFileSelectionType.camera;
                        onFilesPicked();
                      },
                    },
                  if (widget.enableImageUpload)
                    {
                      "image": AppAssets.attGallary,
                      "text": "chooseMedia".translate(context: context),
                      "onTap": () {
                        selectionType = AttachmentFileSelectionType.gallery;
                        onFilesPicked();
                      },
                    },
                ];
                return CustomContainer(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: options.map<Widget>((e) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: CustomInkWellContainer(
                          onTap: e["onTap"] as Function(),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: CustomContainer(
                                  width: 50,
                                  height: 50,
                                  color: context.colorScheme.accentColor
                                      .withAlpha(30),
                                  borderRadius: UiUtils.borderRadiusOf8,
                                  padding: const EdgeInsets.all(12),
                                  child: CustomSvgPicture(
                                    svgImage: e["image"] as String,
                                    boxFit: BoxFit.cover,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.accentColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CustomText(
                                  e["text"] as String,
                                  maxLines: 1,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.blackColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomText(
                          "${(selectionType == AttachmentFileSelectionType.camera
                              ? "cameraImages"
                              : selectionType == AttachmentFileSelectionType.document
                              ? "selectedFiles"
                              : "pickedImages").translate(context: context)} (${selectedFiles.length})",
                          maxLines: 1,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.blackColor,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      const SizedBox(width: 5),
                      CustomInkWellContainer(
                        onTap: () {
                          onFilesPicked();
                        },
                        child: Icon(
                          Icons.add,
                          color: Theme.of(context).colorScheme.blackColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:
                        selectionType == AttachmentFileSelectionType.document
                        ? List.generate(selectedFiles.length, (index) {
                            return CustomContainer(
                              height: 100,
                              width: 150,
                              padding: const EdgeInsets.all(5),
                              child: Stack(
                                children: [
                                  CustomContainer(
                                    borderRadius: UiUtils.borderRadiusOf10,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondaryColor,
                                    padding: const EdgeInsets.all(5),
                                    height: 100,
                                    width: 150,
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CustomSvgPicture(
                                          svgImage: AppAssets.attFile,
                                          width: 25,
                                          height: 25,
                                          color: context.colorScheme.blackColor,
                                        ),
                                        const SizedBox(height: 5),
                                        CustomText(
                                          selectedFiles[index].fileName,
                                          color: context.colorScheme.blackColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional.topEnd,
                                    child: CustomContainer(
                                      margin: const EdgeInsets.all(5),
                                      padding: const EdgeInsets.all(2),
                                      borderRadius: 50,
                                      color: context.colorScheme.blackColor,
                                      child: InkWell(
                                        onTap: () {
                                          selectedFiles.removeAt(index);
                                          setState(() {});
                                        },
                                        child: const Icon(
                                          Icons.close_rounded,
                                          color: AppColors.redColor,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          })
                        : List.generate(selectedFiles.length, (index) {
                            //image files selected UI
                            return CustomContainer(
                              height: 100,
                              width: 130,
                              padding: const EdgeInsets.all(5),
                              child: Stack(
                                children: [
                                  CustomContainer(
                                    borderRadius: UiUtils.borderRadiusOf10,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.accentColor,
                                    height: 100,
                                    width: 130,
                                    clipBehavior: Clip.antiAlias,
                                    child: Image.file(
                                      File(selectedFiles[index].fileUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional.topEnd,
                                    child: CustomContainer(
                                      margin: const EdgeInsets.all(5),
                                      padding: const EdgeInsets.all(2),
                                      borderRadius: 50,
                                      color: context.colorScheme.blackColor,
                                      child: InkWell(
                                        onTap: () {
                                          selectedFiles.removeAt(index);
                                          setState(() {});
                                        },
                                        child: const Icon(
                                          Icons.close_rounded,
                                          color: AppColors.redColor,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                  ),
                ),
                CloseAndConfirmButton(
                  closeButtonPressed: () {
                    widget.onCancel();
                  },
                  confirmButtonPressed: () {
                    onClickSend();
                  },
                  confirmButtonName: "send".translate(context: context),
                ),
              ],
            ),
    );
  }
}

import 'package:edemand_partner/app/generalImports.dart';
import 'package:edemand_partner/utils/checkURLType.dart';
import 'package:flutter/material.dart';

class ReferenceFilesWidget extends StatefulWidget {
  const ReferenceFilesWidget({super.key, required this.files});

  final List<String> files;

  @override
  State<ReferenceFilesWidget> createState() => _ReferenceFilesWidgetState();
}

class _ReferenceFilesWidgetState extends State<ReferenceFilesWidget> {
  final Map<int, bool> _downloading = {};

  Future<void> _openFile(String url, int index) async {
    final fileName = url.split('/').last.split('?').first;
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/$fileName';
    final file = File(filePath);

    if (await file.exists()) {
      await OpenFile.open(filePath);
      return;
    }

    if (!mounted) return;
    setState(() => _downloading[index] = true);

    try {
      await Dio().download(url, filePath);
      await OpenFile.open(filePath);
    } catch (_) {
      if (mounted) {
        UiUtils.showMessage(
          context,
          'downloadFailed',
          ToastificationType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _downloading[index] = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.files.isEmpty) return const SizedBox.shrink();

    final mediaEntries = <MapEntry<int, String>>[];
    final docEntries = <MapEntry<int, String>>[];

    for (int i = 0; i < widget.files.length; i++) {
      final type = UrlTypeHelper.getType(widget.files[i]);
      if (type == UrlType.image || type == UrlType.video) {
        mediaEntries.add(MapEntry(i, widget.files[i]));
      } else {
        docEntries.add(MapEntry(i, widget.files[i]));
      }
    }

    return CustomContainer(
      borderRadius: 0,
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      color: Theme.of(context).colorScheme.secondaryColor,
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            'referenceFiles'.translate(context: context),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.blackColor,
          ),
          if (mediaEntries.isNotEmpty) ...[
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: mediaEntries.map((entry) {
                  final index = entry.key;
                  final url = entry.value;
                  final type = UrlTypeHelper.getType(url);
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.imagePreviewScreen,
                        arguments: {
                          'startFrom': mediaEntries.indexWhere(
                            (e) => e.key == index,
                          ),
                          'isReviewType': false,
                          'dataURL': mediaEntries.map((e) => e.value).toList(),
                        },
                      );
                    },
                    child: CustomContainer(
                      height: 90,
                      width: 90,
                      margin: const EdgeInsetsDirectional.only(end: 10),
                      borderRadius: UiUtils.borderRadiusOf8,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.lightGreyColor,
                        width: 0.5,
                      ),
                      color: Theme.of(context).colorScheme.primaryColor,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          UiUtils.borderRadiusOf8,
                        ),
                        child: type == UrlType.image
                            ? CustomCachedNetworkImage(
                                imageUrl: url,
                                height: 90,
                                width: 90,
                                fit: BoxFit.cover,
                              )
                            : Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .lightGreyColor
                                        .withValues(alpha: 0.3),
                                  ),
                                  Icon(
                                    Icons.play_circle_outline_rounded,
                                    size: 36,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.accentColor,
                                  ),
                                ],
                              ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
          if (docEntries.isNotEmpty) ...[
            const SizedBox(height: 10),
            ...docEntries.map((entry) {
              final index = entry.key;
              final url = entry.value;
              final fileName = url.split('/').last.split('?').first;
              return Column(
                children: [
                  InkWell(
                    onTap: () => _openFile(url, index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.insert_drive_file_outlined,
                            size: 24,
                            color: Theme.of(context).colorScheme.accentColor,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomText(
                              fileName,
                              fontSize: 13,
                              maxLines: 1,
                              color: Theme.of(context).colorScheme.blackColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _downloading[index] == true
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CustomCircularProgressIndicator(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.accentColor,
                                  ),
                                )
                              : Icon(
                                  Icons.download_outlined,
                                  size: 22,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.accentColor,
                                ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 0.5,
                    color: Theme.of(
                      context,
                    ).colorScheme.lightGreyColor.withValues(alpha: 0.4),
                  ),
                ],
              );
            }),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

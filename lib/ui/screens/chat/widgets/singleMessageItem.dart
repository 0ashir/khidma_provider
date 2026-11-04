import 'package:any_link_preview/any_link_preview.dart';
import 'package:edemand_partner/app/generalImports.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SingleChatMessageItem extends StatefulWidget {
  final ChatMessage chatMessage;
  final bool isLoading;
  final bool isError;
  final bool isMyMessage;
  final Function(ChatMessage chatMessage) onRetry;
  final bool showTime;
  final String? avatarUrl;

  const SingleChatMessageItem({
    super.key,
    required this.chatMessage,
    required this.isLoading,
    required this.isError,
    required this.onRetry,
    required this.isMyMessage,
    this.showTime = true,
    this.avatarUrl,
  });

  @override
  State<SingleChatMessageItem> createState() => _SingleChatMessageItemState();
}

class _SingleChatMessageItemState extends State<SingleChatMessageItem> {
  final double _messageItemBorderRadius = 12;

  final ValueNotifier _linkAddNotifier = ValueNotifier('');

  @override
  void dispose() {
    _linkAddNotifier.dispose();
    super.dispose();
  }

  Widget _buildTextMessageWidget({
    required BuildContext context,
    required BoxConstraints constraints,
    required ChatMessage textMessage,
  }) {
    return Row(
      mainAxisAlignment: widget.isMyMessage
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: constraints.maxWidth * 0.8,
              minWidth: constraints.maxWidth * 0.15,
            ),
            clipBehavior: Clip.antiAlias,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: widget.isMyMessage
                  ? Theme.of(context).colorScheme.accentColor
                  : Theme.of(context).colorScheme.secondaryColor,
              borderRadius: BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(_messageItemBorderRadius),
                topStart: Radius.circular(_messageItemBorderRadius),
                topEnd: widget.isMyMessage
                    ? Radius.zero
                    : Radius.circular(_messageItemBorderRadius),
                bottomStart: widget.isMyMessage
                    ? Radius.circular(_messageItemBorderRadius)
                    : Radius.zero,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                //This is preview builder for image
                ValueListenableBuilder(
                  valueListenable: _linkAddNotifier,
                  builder: (context, dynamic value, c) {
                    if (value == null) {
                      return const SizedBox.shrink();
                    }
                    return FutureBuilder(
                      future: AnyLinkPreview.getMetadata(link: value),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.data == null) {
                            return const SizedBox.shrink();
                          }
                          return LinkPreview(snapshot: snapshot, link: value);
                        }
                        return const SizedBox.shrink();
                      },
                    );
                  },
                ),
                SelectableText.rich(
                  TextSpan(
                    style: TextStyle(
                      color: widget.isMyMessage
                          ? AppColors.whiteColors
                          : Theme.of(context).colorScheme.blackColor,
                    ),
                    children: replaceLink(text: textMessage.message).map((
                      data,
                    ) {
                      //This will add link to msg
                      if (isLink(data)) {
                        //This will notify preview object that it has link
                        _linkAddNotifier.value = data;

                        return TextSpan(
                          text: data,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              if (await canLaunchUrl(Uri.parse(data))) {
                                await launchUrl(Uri.parse(data));
                              }
                            },
                          style: const TextStyle(color: Color(0xff0000FF)),
                        );
                      }
                      return TextSpan(
                        text: data,
                        style: TextStyle(
                          color: widget.isMyMessage
                              ? AppColors.whiteColors
                              : Theme.of(context).colorScheme.blackColor,
                        ),
                      );
                    }).toList(),
                  ),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: widget.isMyMessage
                        ? AppColors.whiteColors
                        : Theme.of(context).colorScheme.blackColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageMessageWidget({
    required BuildContext context,
    required BoxConstraints constraints,
    required ChatMessage imageMessage,
  }) {
    Widget singleImageItem({
      required ChatMessage imageMessage,
      required int index,
    }) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            Routes.imagesFullScreenView,
            arguments: {
              "isFile": imageMessage.isLocallyStored,
              "images": imageMessage.files.map((e) => e.fileUrl).toList(),
              "initialPage": index == 0 ? null : index,
              "userName": widget.isMyMessage
                  ? "you".translate(context: context)
                  : imageMessage.senderDetails.name,
              "messageDateTime": imageMessage.sendOrReceiveDateTime,
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.whiteColors,
          ),
          clipBehavior: Clip.antiAlias,
          child: imageMessage.isLocallyStored
              ? imageMessage.files[index].fileUrl.endsWith(".svg")
                    ? SvgPicture.file(
                        File(imageMessage.files[index].fileUrl),
                        fit: BoxFit.contain,
                      )
                    : Image.file(
                        File(imageMessage.files[index].fileUrl),
                        fit: BoxFit.contain,
                      )
              : CustomCachedNetworkImage(
                  imageUrl: imageMessage.files[index].fileUrl,
                  fit: BoxFit.contain,
                ),
        ),
      );
    }

    return imageMessage.files.isEmpty
        ? const SizedBox.shrink()
        : Container(
            width: imageMessage.files.length > 2
                ? constraints.maxWidth * 0.8
                : imageMessage.files.length == 1
                ? constraints.maxWidth * 0.6
                : constraints.maxWidth * 0.8,
            height: imageMessage.files.length > 2
                ? constraints.maxWidth * 0.8
                : imageMessage.files.length == 1
                ? constraints.maxWidth * 0.6
                : constraints.maxWidth * 0.4,
            decoration: BoxDecoration(
              color: widget.isMyMessage
                  ? Theme.of(context).colorScheme.accentColor
                  : Theme.of(context).colorScheme.secondaryColor,
              borderRadius: BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(_messageItemBorderRadius),
                topStart: Radius.circular(_messageItemBorderRadius),
                topEnd: widget.isMyMessage
                    ? Radius.zero
                    : Radius.circular(_messageItemBorderRadius),
                bottomStart: widget.isMyMessage
                    ? Radius.circular(_messageItemBorderRadius)
                    : Radius.zero,
              ),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: (widget.isMyMessage)
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: singleImageItem(
                          imageMessage: imageMessage,
                          index: 0,
                        ),
                      ),
                      if (imageMessage.files.length > 1 &&
                          imageMessage.files.length != 3) ...[
                        const SizedBox(width: 5),
                        Expanded(
                          child: singleImageItem(
                            imageMessage: imageMessage,
                            index: 1,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (imageMessage.files.length >= 3) ...[
                  const SizedBox(height: 5),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: singleImageItem(
                            imageMessage: imageMessage,
                            index: imageMessage.files.length == 3 ? 1 : 2,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: singleImageItem(
                            imageMessage: imageMessage,
                            index: imageMessage.files.length == 3 ? 2 : 3,
                          ),
                        ),
                        if (imageMessage.files.length > 4) ...[
                          const SizedBox(width: 5),
                          Expanded(
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                singleImageItem(
                                  imageMessage: imageMessage,
                                  index: 4,
                                ),
                                if (imageMessage.files.length > 5)
                                  GestureDetector(
                                    //this is because above ontap won't work as this on is on top in stack
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                        Routes.imagesFullScreenView,
                                        arguments: {
                                          "isFile":
                                              imageMessage.isLocallyStored,
                                          "initialPage": 4,
                                          "userName": widget.isMyMessage
                                              ? "you".translate(
                                                  context: context,
                                                )
                                              : widget
                                                    .chatMessage
                                                    .senderDetails
                                                    .name,
                                          "images": imageMessage.files
                                              .map((e) => e.fileUrl)
                                              .toList(),
                                          "messageDateTime": imageMessage
                                              .sendOrReceiveDateTime,
                                        },
                                      );
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color:
                                            context.colorScheme.lightGreyColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: CustomText(
                                        "+${imageMessage.files.length - 5}",
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.whiteColors,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
  }

  Widget _buildFileMessageWidget({
    required BuildContext context,
    required BoxConstraints constraints,
    required ChatMessage fileMessage,
  }) {
    final List<bool> isDownloading = [];
    for (int i = 0; i < fileMessage.files.length; i++) {
      isDownloading.add(false);
    }
    return SizedBox(
      width: constraints.maxWidth * 0.6,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children:
            List<Widget>.generate(fileMessage.files.length, (index) {
              final file = fileMessage.files[index];
              return StatefulBuilder(
                builder: (context, reBuilder) {
                  return GestureDetector(
                    onTap: () async {
                      if (isDownloading[index]) {
                        return;
                      }
                      reBuilder(() {
                        isDownloading[index] = true;
                      });
                      try {
                        if (fileMessage.isLocallyStored) {
                          OpenFile.open(file.fileUrl);
                        } else {
                          await UiUtils.downloadOrShareFile(
                            url: file.fileUrl,
                            isDownload: true,
                            customFileName: file.fileName,
                          );
                        }
                      } catch (_) {
                        UiUtils.showMessage(
                          context,
                          "somethingWentWrongTitle",
                          ToastificationType.error,
                        );
                      }
                      reBuilder(() {
                        isDownloading[index] = false;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.isMyMessage
                            ? Theme.of(context).colorScheme.accentColor
                            : Theme.of(context).colorScheme.secondaryColor,
                        borderRadius: BorderRadiusDirectional.only(
                          bottomEnd: Radius.circular(_messageItemBorderRadius),
                          topStart: Radius.circular(_messageItemBorderRadius),
                          topEnd: widget.isMyMessage
                              ? Radius.zero
                              : Radius.circular(_messageItemBorderRadius),
                          bottomStart: widget.isMyMessage
                              ? Radius.circular(_messageItemBorderRadius)
                              : Radius.zero,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 3,
                        vertical: 10,
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: (widget.isMyMessage)
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 5),
                              if (!fileMessage.isLocallyStored)
                                CustomContainer(
                                  height: 50,
                                  width: 50,
                                  shape: BoxShape.circle,
                                  color: AppColors.whiteColors,
                                  padding: EdgeInsets.all(
                                    isDownloading[index] ? 15 : 12,
                                  ),
                                  child: isDownloading[index]
                                      ? const CustomCircularProgressIndicator()
                                      : CustomSvgPicture(
                                          svgImage: AppAssets.downloadIcon,
                                          boxFit: BoxFit.contain,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.accentColor,
                                        ),
                                ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      file.fileName,
                                      maxLines: 2,
                                      textAlign: TextAlign.start,
                                      color: widget.isMyMessage
                                          ? AppColors.whiteColors
                                          : Theme.of(
                                              context,
                                            ).colorScheme.blackColor,
                                    ),
                                    const SizedBox(height: 2),
                                    CustomText(
                                      "${file.getFileSizeString} | ${file.fileType.capitalize()}",
                                      maxLines: 2,
                                      textAlign: TextAlign.start,
                                      fontSize: 12,
                                      color: widget.isMyMessage
                                          ? AppColors.whiteColors
                                          : Theme.of(
                                              context,
                                            ).colorScheme.blackColor,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }) +
            <Widget>[
              if (fileMessage.message.trim().isNotEmpty)
                CustomText(
                  "${fileMessage.message} ",
                  textAlign: TextAlign.start,
                  fontSize: 12,
                  color: widget.isMyMessage
                      ? AppColors.whiteColors
                      : Theme.of(context).colorScheme.blackColor,
                ),
            ],
      ),
    );
  }

  Widget _topNameTimeWidget() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 2,
        right: widget.chatMessage.messageType == ChatMessageType.textMessage
            ? 0
            : 5,
        left: widget.chatMessage.messageType == ChatMessageType.textMessage
            ? 0
            : 5,
      ),
      child: Text(
        UiUtils.formatTimeWithDateTime(
          widget.chatMessage.sendOrReceiveDateTime,
        ),
        style: TextStyle(
          fontSize: 10,
          color: Theme.of(context).colorScheme.lightGreyColor,
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    final String? url = widget.avatarUrl;
    final bool hasUrl =
        url != null && url.trim().isNotEmpty && url.toLowerCase() != 'null';
    return CustomContainer(
      height: 24,
      width: 24,
      shape: BoxShape.circle,
      clipBehavior: Clip.antiAlias,
      child: hasUrl
          ? CustomCachedNetworkImage(imageUrl: url, fit: BoxFit.cover)
          : const CustomSvgPicture(svgImage: AppAssets.dProfile),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final Widget bubble =
                  widget.chatMessage.messageType == ChatMessageType.textMessage
                  ? _buildTextMessageWidget(
                      context: context,
                      constraints: constraints,
                      textMessage: widget.chatMessage,
                    )
                  : widget.chatMessage.messageType ==
                        ChatMessageType.imageMessage
                  ? _buildImageMessageWidget(
                      context: context,
                      constraints: constraints,
                      imageMessage: widget.chatMessage,
                    )
                  : widget.chatMessage.messageType ==
                        ChatMessageType.fileMessage
                  ? _buildFileMessageWidget(
                      context: context,
                      constraints: constraints,
                      fileMessage: widget.chatMessage,
                    )
                  : const SizedBox.shrink();

              final Widget avatar = widget.avatarUrl != null
                  ? _buildAvatar()
                  : const SizedBox(width: 28);

              return Align(
                alignment: widget.isMyMessage
                    ? AlignmentDirectional.centerEnd
                    : AlignmentDirectional.centerStart,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: widget.isMyMessage
                      ? [bubble, const SizedBox(width: 6), avatar]
                      : [avatar, const SizedBox(width: 6), bubble],
                ),
              );
            },
          ),
          Align(
            alignment: widget.isMyMessage
                ? AlignmentDirectional.centerEnd
                : AlignmentDirectional.centerStart,
            child: widget.isLoading
                ? CustomText(
                    "sending".translate(context: context),
                    maxLines: 1,
                    fontSize: 10,
                    color: Theme.of(context).colorScheme.lightGreyColor,
                  )
                : widget.isError
                ? GestureDetector(
                    onTap: () {
                      widget.onRetry(widget.chatMessage);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.refresh,
                          size: 10,
                          color: AppColors.redColor,
                        ),
                        const SizedBox(width: 2),
                        Flexible(
                          child: CustomText(
                            "errorSendingMessageTryAgain".translate(
                              context: context,
                            ),
                            maxLines: 1,
                            fontSize: 10,
                            color: AppColors.redColor,
                          ),
                        ),
                      ],
                    ),
                  )
                : widget.showTime
                ? _topNameTimeWidget()
                : null,
          ),
        ],
      ),
    );
  }
}

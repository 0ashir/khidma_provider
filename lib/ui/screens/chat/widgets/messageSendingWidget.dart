import 'package:edemand_partner/app/generalImports.dart';
import 'package:flutter/material.dart';

class ChatMessageSendingWidget extends StatelessWidget {
  final Function() onMessageSend;
  final Function() onAttachmentTap;
  final TextEditingController textController;
  final bool showAttachmentButton;

  const ChatMessageSendingWidget({
    super.key,
    required this.onMessageSend,
    required this.textController,
    required this.onAttachmentTap,
    this.showAttachmentButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondaryColor,
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showAttachmentButton) ...[
            GestureDetector(
              onTap: onAttachmentTap,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomSvgPicture(
                  svgImage: AppAssets.addAttachment,
                  boxFit: BoxFit.contain,
                  width: 20,
                  height: 20,
                  color: context.colorScheme.accentColor,
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(UiUtils.borderRadiusOf8),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: textController,
                maxLines: 5,
                minLines: 1,
                maxLength: max(
                  context
                      .read<FetchSystemSettingsCubit>()
                      .chatSettings
                      .maxCharactersInATextMessage,
                  1,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "chatSendHint".translate(context: context),
                  counterText: '',
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 14,
                  ),
                ),
                onSubmitted: (value) {
                  onMessageSend();
                },
                cursorColor: Theme.of(context).colorScheme.secondary,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          CustomInkWellContainer(
            onTap: onMessageSend,
            child: CustomContainer(
              borderRadius: UiUtils.borderRadiusOf8,
              height: 48,
              width: 48,
              padding: const EdgeInsets.all(8),
              color: context.colorScheme.accentColor.withAlpha(30),
              child: Center(
                child: CustomSvgPicture(
                  svgImage: AppAssets.sendMessage,
                  boxFit: BoxFit.contain,
                  width: 24,
                  height: 24,
                  color: Theme.of(context).colorScheme.accentColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

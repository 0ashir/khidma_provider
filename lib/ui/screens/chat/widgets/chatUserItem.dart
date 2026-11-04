import 'package:edemand_partner/app/generalImports.dart';
import 'package:edemand_partner/ui/widgets/unreadChatCounterBadgeContainer.dart';
import 'package:flutter/material.dart';

class ChatUserItemWidget extends StatelessWidget {
  final ChatUser chatUser;
  final bool showCount;
  final ChatUsersCubit chatUsersCubit;

  const ChatUserItemWidget({
    super.key,
    required this.chatUser,
    this.showCount = true,
    required this.chatUsersCubit,
  });

  final double _chatUserContainerHeight = 80;

  Widget _profileImageBuilder({
    required String imageUrl,
    required BuildContext context,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(UiUtils.borderRadiusOf8),
      child: CustomContainer(
        clipBehavior: Clip.antiAlias,
        borderRadius: UiUtils.borderRadiusOf8,
        height: 60,
        width: 60,
        child: imageUrl.trim().isEmpty || imageUrl.toLowerCase() == "null"
            ? const CustomSvgPicture(
                svgImage: AppAssets.drProfile,
                width: 60,
                height: 60,
              )
            : CustomCachedNetworkImage(fit: BoxFit.contain, imageUrl: imageUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            Routes.chatMessages,
            arguments: {"chatUser": chatUser, "chatUsersCubit": chatUsersCubit},
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: CustomContainer(
          border: Border.all(
            color: context.colorScheme.lightGreyColor,
            width: 0.2,
          ),
          height: _chatUserContainerHeight,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          borderRadius: UiUtils.borderRadiusOf10,
          color: Theme.of(context).colorScheme.secondaryColor,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _profileImageBuilder(imageUrl: chatUser.avatar, context: context),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      chatUser.customerName,
                      maxLines: 1,
                      color: Theme.of(context).secondaryHeaderColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                    const SizedBox(height: 5),
                    if (chatUser.bookingTranslatedStatus != '') ...[
                      CustomText(
                        chatUser.bookingTranslatedStatus ??
                            chatUser.bookingStatus ??
                            '',
                        color: context.colorScheme.blackColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0,
                      ),
                      const SizedBox(height: 5),
                    ],
                    if (chatUser.chatUserType ==
                        ChatUserType.providerEnquiry) ...[
                      CustomText(
                        "preBookingEnquiry".translate(context: context),
                        color: context.colorScheme.lightGreyColor,
                        fontSize: 12.0,
                      ),
                    ] else ...[
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 12.0,
                            height: 1,
                            color: context.colorScheme.blackColor,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  "${"bookingId".translate(context: context)} - ",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: context.colorScheme.blackColor,
                              ),
                            ),
                            TextSpan(
                              text: '#${chatUser.bookingId ?? ''}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: context.colorScheme.accentColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ],
                ),
              ),
              if (chatUser.unreadNotificationsCount > 0) ...[
                UnreadChatCounterBadgeContainer(
                  count: chatUser.unreadNotificationsCount,
                  padding: 8,
                  fontSize: 14,
                ),
              ] else ...[
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      Routes.chatMessages,
                      arguments: {
                        "chatUser": chatUser,
                        "chatUsersCubit": chatUsersCubit,
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    weight: 10,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

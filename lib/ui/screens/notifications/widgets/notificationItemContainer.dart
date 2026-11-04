import 'package:edemand_partner/app/generalImports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

enum NotificationItemLocation { first, last, onlyOne, middle }

class NotificationItemContainer extends StatelessWidget {
  const NotificationItemContainer({
    required this.notification,
    required this.location,
    super.key,
    this.onTap,
    this.slidableChild,
    this.showArrow = false,
    this.isLoading = false,
  });

  final NotificationItemLocation location;
  final NotificationDataModel notification;
  final VoidCallback? onTap;
  final Widget? slidableChild;
  final bool showArrow;
  final bool isLoading;

  Widget _buildNotificationContainer({
    required BuildContext context,
  }) => CustomContainer(
    width: double.infinity,
    padding: const EdgeInsets.all(10),
    child: Row(
      children: [
        notification.image?.trim().isNotEmpty ?? false
            ? CustomContainer(
                height: 50,
                width: 50,
                shape: BoxShape.circle,
                clipBehavior: Clip.antiAlias,
                child: CustomCachedNetworkImage(
                  imageUrl: notification.image!,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              )
            : CustomContainer(
                height: 50,
                width: 50,
                color: context.colorScheme.accentColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                child: Icon(
                  Icons.notifications_outlined,
                  color: context.colorScheme.accentColor,
                  size: 24,
                ),
              ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomText(
                      notification.title?.trim() ?? '',
                      color: context.colorScheme.blackColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  CustomText(
                    UiUtils.getTimeAgo(context, date: notification.dateSent),
                    maxLines: 1,
                    color: context.colorScheme.lightGreyColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: CustomReadMoreTextContainer(
                      text: notification.message ?? '',
                      textStyle: TextStyle(
                        color: context.colorScheme.lightGreyColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                      trimLines: 2,
                    ),
                  ),
                  if (isLoading) ...[
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 16,
                      width: 16,
                      child: CustomCircularProgressIndicator(
                        color: context.colorScheme.accentColor,
                        strokeWidth: 2,
                      ),
                    ),
                  ] else if (showArrow) ...[
                    const SizedBox(width: 8),
                    Icon(
                      Icons.chevron_right,
                      color: context.colorScheme.lightGreyColor,
                      size: 20,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );

  BorderRadiusGeometry get _borderRadius {
    switch (location) {
      case NotificationItemLocation.onlyOne:
        return BorderRadius.circular(UiUtils.borderRadiusOf10);
      case NotificationItemLocation.first:
        return const BorderRadius.only(
          topLeft: Radius.circular(UiUtils.borderRadiusOf10),
          topRight: Radius.circular(UiUtils.borderRadiusOf10),
        );
      case NotificationItemLocation.last:
        return const BorderRadius.only(
          bottomLeft: Radius.circular(UiUtils.borderRadiusOf10),
          bottomRight: Radius.circular(UiUtils.borderRadiusOf10),
        );
      case NotificationItemLocation.middle:
        return BorderRadius.zero;
    }
  }

  @override
  Widget build(BuildContext context) => CustomInkWellContainer(
    onTap: onTap,
    borderRadius: BorderRadius.circular(UiUtils.borderRadiusOf10),
    child: CustomContainer(
      clipBehavior: Clip.antiAlias,
      borderRadiusStyle: _borderRadius,
      border:
          location == NotificationItemLocation.middle ||
              location == NotificationItemLocation.first
          ? Border(
              bottom: BorderSide(
                color: context.colorScheme.lightGreyColor.withValues(
                  alpha: 0.3,
                ),
                width: 0.5,
              ),
            )
          : null,
      color: notification.isRead == "1"
          ? context.colorScheme.secondaryColor.withValues(alpha: 0.5)
          : context.colorScheme.secondaryColor,
      child: slidableChild != null
          ? Stack(
              clipBehavior: Clip.antiAlias,
              children: [
                Positioned.fill(
                  child: CustomContainer(
                    color: AppColors.redColor,
                    borderRadiusStyle: _borderRadius,
                  ),
                ),
                Slidable(
                  key: UniqueKey(),
                  endActionPane: ActionPane(
                    motion: const BehindMotion(),
                    extentRatio: 0.24,
                    children: [slidableChild!],
                  ),
                  child: _buildNotificationContainer(context: context),
                ),
              ],
            )
          : _buildNotificationContainer(context: context),
    ),
  );
}

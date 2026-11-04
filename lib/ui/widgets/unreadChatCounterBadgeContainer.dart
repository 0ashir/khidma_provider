import 'package:edemand_partner/ui/widgets/customText.dart';
import 'package:edemand_partner/utils/colors.dart';
import 'package:flutter/cupertino.dart';

class UnreadChatCounterBadgeContainer extends StatelessWidget {
  final int count;
  final double fontSize;
  final double padding;
  final EdgeInsetsGeometry? margin;
  const UnreadChatCounterBadgeContainer({
    super.key,
    required this.count,
    this.fontSize = 12,
    this.padding = 6,
    this.margin = const EdgeInsets.symmetric(horizontal: 8),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.redColor,
      ),
      margin: margin,
      padding: EdgeInsets.all(
        padding,
      ).add(const EdgeInsetsGeometry.only(bottom: 1)),
      child: CustomText(
        count > 99 ? "99+" : count.toString(),
        color: AppColors.whiteColors,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        height: 1,
      ),
    );
  }
}

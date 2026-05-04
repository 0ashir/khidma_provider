import '../../../../config.dart';

class StatusRow extends StatelessWidget {
  final String? title, title2, statusText;
  final bool? isDateLocation;
  final int? statusId;
  final TextStyle? style;
  final GestureTapCallback? onTap;

  const StatusRow(
      {super.key,
      this.title,
      this.style,
      this.title2,
      this.statusText,
      this.isDateLocation,
      this.statusId,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [
        textCommon.dmSensMediumLight12(context, text: title),
        if (isDateLocation == true)
          SvgPicture.asset(eSvgAssets.edit,
                  fit: BoxFit.scaleDown,
                  colorFilter: ColorFilter.mode(
                      appColor(context).appTheme.primary, BlendMode.srcIn))
              .inkWell(onTap: onTap)
              .paddingSymmetric(horizontal: Insets.i6)
      ]),
      title == translations!.bookingStatus
          ? BookingStatusLayout(
              title: capitalizeFirstLetter(statusText.toString()),
              color: colorCondition(statusText.toString(), context))
          : Text(
              textAlign: TextAlign.end,
              title2!,
              style: style,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ).expanded()
    ]).paddingOnly(bottom: Insets.i12);
  }
}

import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fixit_provider/providers/app_pages_provider/boost_provider.dart';
import '../../../../config.dart';
import '../../../../widgets/multi_dropdown_common.dart';

class BoostZoneDropDown extends StatelessWidget {
  const BoostZoneDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BoostProvider>(builder: (context2, value, child) {
      log("ZONES :${value.zoneSelect.length}");
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: Sizes.s20),
        padding: const EdgeInsets.symmetric(
            horizontal: Sizes.s15, vertical: Sizes.s10),
        decoration: ShapeDecoration(
          color: appColor(context).appTheme.whiteBg,
          shape: SmoothRectangleBorder(
            borderRadius:
                SmoothBorderRadius(cornerRadius: 8, cornerSmoothing: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  SvgPicture.asset(
                    eSvgAssets.locationOut,
                    colorFilter: ColorFilter.mode(
                      value.zoneSelect.isNotEmpty
                          ? appColor(context).appTheme.darkText
                          : appColor(context).appTheme.lightText,
                      BlendMode.srcIn,
                    ),
                  ).padding(
                    left: Insets.i5,
                    right: rtl(context) ? Insets.i5 : 0,
                    top: Sizes.s5,
                    vertical: Sizes.s5,
                  ),
                  const HSpace(Sizes.s12),
                  if (value.zoneSelect.isNotEmpty)
                    Expanded(
                      child: Text(
                        value.zoneSelect.first.name ??
                            'No zone name', // Safely handle null name
                        style: appCss.dmDenseLight14.textColor(
                          appColor(context).appTheme.darkText,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  if (value.zoneSelect.isEmpty)
                    Text(
                      language(context, translations!.selectZone),
                      style: appCss.dmDenseMedium14.textColor(
                        appColor(context).appTheme.lightText,
                      ),
                    ),
                ],
              ),
            ),
            SvgPicture.asset(
              eSvgAssets.dropDown,
              colorFilter: ColorFilter.mode(
                value.zoneSelect.isNotEmpty
                    ? appColor(context).appTheme.darkText
                    : appColor(context).appTheme.lightText,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ).inkWell(onTap: () => value.onBottomSheet(context));
    });
  }
}

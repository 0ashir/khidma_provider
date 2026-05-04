
import 'package:flutter/material.dart';

import '../../../../config.dart';

class PlanRowCommon extends StatelessWidget {
  final String? title;
  final int? selectIndex, index;

  const PlanRowCommon({super.key, this.title, this.selectIndex, this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset( selectIndex == index ? eSvgAssets.shield : eSvgAssets.shieldFill ),
          const HSpace(Sizes.s8),
          Expanded(
            child: Text(language(context, title!),
                    style: selectIndex == index ? appCss.dmDenseMedium14
                        .textColor( appColor(context).appTheme.whiteBg) : appCss.dmDenseMedium11
                        .textColor( appColor(context).appTheme.darkText) )
                .width(Sizes.s200),
          )
        ]).paddingOnly(bottom: Insets.i15);
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../config.dart';

class LocationListTile extends StatelessWidget {
  final String? loc;
  final GestureTapCallback? onTap;
  const LocationListTile({super.key, this.loc, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SvgPicture.asset(eSvgAssets.location),
            const HSpace(Sizes.s10),
            Expanded(child: Text(loc??"")),
          ],
        ).inkWell(onTap:onTap),
        Divider(color: appColor(context).appTheme.stroke,height: 0,).paddingSymmetric(vertical: Sizes.s15)
      ],
    ).paddingSymmetric(horizontal: Sizes.s20);
  }
}

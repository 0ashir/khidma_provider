import 'package:fixit_provider/config.dart';
import 'package:flutter/material.dart';

class ZoneListTileLayout extends StatelessWidget {
  final ZoneModel? data;
  final int? index;
  final GestureTapCallback? onTap;
  final bool isContain;

  const ZoneListTileLayout(
      {super.key, this.data, this.onTap, this.isContain = false, this.index});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Expanded(
        child: Text(language(context, data!.name),
            style: appCss.dmDenseMedium14
                .textColor(appColor(context).appTheme.darkText)),
      ),
      CheckBoxCommon(isCheck: isContain, onTap: onTap)
    ])
        .paddingSymmetric(vertical: Insets.i10, horizontal: Insets.i15)
        .boxBorderExtension(context, isShadow: true)
        .padding(horizontal: Insets.i20, bottom: Insets.i15);
  }
}

import 'package:flutter/material.dart';

import '../../../../config.dart';

class ChartDataLayout extends StatelessWidget {
  final CategoryEarnings? data;
  final int? index;
  const ChartDataLayout({super.key, this.data, this.index});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const SizedBox(height: 3, width: 9).decorated(
          color: index == 0
              ? appColor(context).appTheme.primary
              : index == 1
                  ? appColor(context).appTheme.primary.withValues(alpha: 0.8)
                  : index == 2
                      ? appColor(context).appTheme.primary.withValues(alpha: 0.5)
                      : index == 3
                          ? appColor(context).appTheme.primary.withValues(alpha: 0.2)
                          : appColor(context).appTheme.primary.withValues(alpha: 0.9),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      const HSpace(Sizes.s7),
      Expanded(
          child: Text(
              "${data?.categoryName ?? ''} (${data?.percentage ?? ''}%)",
              style: appCss.dmDenseRegular12
                  .textColor(appColor(context).appTheme.darkText)))
    ]);
  }
}

import 'package:flutter/cupertino.dart';

import '../config.dart';

class BottomSheetTopLayout extends StatelessWidget {
  final String? title;
  const BottomSheetTopLayout({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(language(context, title),
                overflow: TextOverflow.ellipsis,
                style: appCss.dmDenseSemiBold18.textColor(
                    appColor(context).appTheme.darkText)),
          ),
          const Icon(CupertinoIcons.multiply)
              .inkWell(onTap: () => route.pop(context))
        ]).paddingSymmetric(horizontal: Insets.i20);
  }
}

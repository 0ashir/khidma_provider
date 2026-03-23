import 'package:flutter/cupertino.dart';

import '../config.dart';

class ContainerWithTextLayout extends StatelessWidget {
  final String? title, title2;
  final GestureTapCallback? onTap;

  const ContainerWithTextLayout(
      {super.key, this.title, this.title2, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(children: [
            const SmallContainer(),
            const HSpace(Sizes.s20),
            Text(language(context, title!),
                overflow: TextOverflow.ellipsis,
                style: appCss.dmDenseSemiBold14
                    .textColor(appColor(context).appTheme.darkText))
          ]),
        ),
        if (title2 != null)
          Expanded(
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              SvgPicture.asset(
                eSvgAssets.add,
                height: Sizes.s18,
                colorFilter: ColorFilter.mode(
                    appColor(context).appTheme.primary, BlendMode.srcIn),
              ),
              Text(
                language(context, title2),
                style: appCss.dmDenseMedium13
                    .textColor(appColor(context).appTheme.primary),
              ),
            ]).inkWell(onTap: onTap).paddingSymmetric(horizontal: Sizes.s20),
          ),
      ],
    );
  }
}

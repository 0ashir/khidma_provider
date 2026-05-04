// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import '../../../../config.dart';

class HomeAppBar extends StatelessWidget {
  final String? location;
  final GestureTapCallback? onTap;

  const HomeAppBar({super.key, this.location, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [
        const HSpace(Sizes.s20),
        userModel!.media != null && userModel!.media!.isNotEmpty
            ? CommonImageLayout(
                isCircle: true,
                height: Sizes.s40,
                width: Sizes.s40,
                assetImage: eImageAssets.noImageFound3,
                image: userModel!.media![0].originalUrl!)
            : CommonCachedImage(
                height: Sizes.s40,
                width: Sizes.s40,
                image: eImageAssets.noImageFound3,
                isCircle: true),
        const HSpace(Sizes.s10),
        Text(
            userModel != null
                ? userModel!.name!
                : language(context, translations!.helloThere),
            style: appCss.dmDenseBold14
                .textColor(appColor(context).appTheme.darkText)),
        if (userModel?.isVerified == 1)
          SvgPicture.asset(
            eSvgAssets.verify,
            fit: BoxFit.scaleDown,
            height: 15,
          ).padding(left: 5)
      ]).inkWell(onTap: () {
        final value = Provider.of<DashboardProvider>(context, listen: false);
        value.selectIndex = 3;
        value.notifyListeners();
/*         route.pushNamed(context, routeName.profileDetails); */
      }),
      Row(children: [
        CommonArrow(arrow: eSvgAssets.chat).inkWell(
            onTap: () => route.pushNamed(context, routeName.chatHistory)),
        const HSpace(Sizes.s10),
        Consumer<NotificationProvider>(
            builder: (context1, notification, child) {
          return Container(
                  alignment: Alignment.center,
                  height: Sizes.s40,
                  width: Sizes.s40,
                  child: Stack(alignment: Alignment.topRight, children: [
                    SvgPicture.asset(eSvgAssets.notification,
                        alignment: Alignment.center,
                        fit: BoxFit.scaleDown,
                        colorFilter: ColorFilter.mode(
                            appColor(context).appTheme.darkText,
                            BlendMode.srcIn)),
                    if (notification.totalCount() != 0)
                      Positioned(
                          top: 2,
                          right: 2,
                          child: Icon(Icons.circle,
                              size: Sizes.s7,
                              color: appColor(context).appTheme.red))
                  ]))
              .decorated(
                  shape: BoxShape.circle,
                  color: appColor(context).appTheme.fieldCardBg)
              .inkWell(
                  onTap: () => route.pushNamed(context, routeName.notification))
              .paddingOnly(
                  right: rtl(context) ? 0 : Insets.i20,
                  left: rtl(context) ? Insets.i20 : 0);
        })
      ])
    ]);
  }
}

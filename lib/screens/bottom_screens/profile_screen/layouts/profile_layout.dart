import '../../../../config.dart';
import '../../../../widgets/profile_pic_common.dart';

class ProfileLayout extends StatelessWidget {
  final GestureTapCallback? onTap;

  const ProfileLayout({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeService, CommonApiProvider>(
        builder: (contextTheme, theme, api, child) {
      return Stack(alignment: Alignment.topRight, children: [
        userModel == null
            ? Container()
            : SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(children: [
                      ProfilePicCommon(
                          imageUrl: userModel!.media != null &&
                                  userModel!.media!.isNotEmpty
                              ? userModel!.media![0].originalUrl!
                              : null,
                          isProfile: true),
                      const VSpace(Sizes.s5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(language(context, userModel!.name),
                              style: appCss.dmDenseSemiBold14.textColor(
                                  appColor(context).appTheme.darkText)),
                          if (userModel?.isVerified == 1)
                            SvgPicture.asset(
                              eSvgAssets.verify,
                              fit: BoxFit.scaleDown,
                              height: 15,
                            ).padding(left: 5)
                        ],
                      ),
                      const VSpace(Sizes.s3),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(eSvgAssets.email),
                            const HSpace(Sizes.s5),
                            Text(language(context, userModel!.email),
                                style: appCss.dmDenseMedium12.textColor(
                                    appColor(context).appTheme.lightText))
                          ]),
                    ]).paddingSymmetric(
                        vertical: Insets.i15, horizontal: Insets.i13))
                .boxShapeExtension(
                    color: appColor(contextTheme).appTheme.fieldCardBg,
                    radius: AppRadius.r12),
        SvgPicture.asset(eSvgAssets.edit)
            .paddingAll(Insets.i15)
            .inkWell(onTap: onTap)
      ]);
    });
  }
}

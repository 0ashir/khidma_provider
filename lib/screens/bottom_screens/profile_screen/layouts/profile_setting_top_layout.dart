import '../../../../config.dart';

class ProfileSettingTopLayout extends StatelessWidget {
  const ProfileSettingTopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeService, ProfileProvider>(
        builder: (context, value, profile, child) {
      return Stack(alignment: Alignment.bottomCenter, children: [
        Column(children: [
          isServiceman
              ? userModel == null
                  ? Container()
                  : Column(children: [
                      ServicemanDetailProfileLayout(
                        imageUrl: userModel!.media != null &&
                                userModel!.media!.isNotEmpty
                            ? userModel!.media![0].originalUrl!
                            : null,
                        onEdit: () =>
                            route.pushNamed(context, routeName.profileDetails),
                      ),
                      const VSpace(Sizes.s6),
                      IntrinsicHeight(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            Text(userModel!.name!,
                                style: appCss.dmDenseMedium14.textColor(
                                    appColor(context).appTheme.darkText)),
                            VerticalDivider(
                                    color: appColor(context).appTheme.stroke,
                                    width: 1,
                                    thickness: 1,
                                    indent: 5,
                                    endIndent: 5)
                                .paddingSymmetric(horizontal: Insets.i6),
                            SvgPicture.asset(eSvgAssets.star),
                            const HSpace(Sizes.s3),
                          ])),
                      Text(
                          appFonts.experienceVal(
                              context,
                              userModel!.experienceDuration ?? 0,
                              userModel!.experienceInterval ?? "years"),
                          style: appCss.dmDenseMedium12
                              .textColor(appColor(context).appTheme.lightText)),
                      const VSpace(Sizes.s10),
                      if (userModel!.primaryAddress != null)
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(eSvgAssets.locationOut,
                                  colorFilter: ColorFilter.mode(
                                      appColor(context).appTheme.darkText,
                                      BlendMode.srcIn)),
                              const HSpace(Sizes.s5),
                              Text(
                                  userModel!.primaryAddress != null
                                      ? "${userModel!.primaryAddress!.country!.name} , ${userModel!.primaryAddress!.state!.name}"
                                      : "",
                                  style: appCss.dmDenseMedium12.textColor(
                                      appColor(context).appTheme.darkText))
                            ]),
                      const VSpace(Sizes.s15),
                      Image.asset(eImageAssets.bulletDotted),
                      const VSpace(Sizes.s15),
                      ServicesDeliveredLayout(
                          services: userModel!.served ?? "0",
                          color: appColor(context)
                              .appTheme
                              .primary
                              .withOpacity(0.1))
                    ])
                      .paddingAll(Insets.i15)
                      .boxBorderExtension(context, isShadow: true)
              : ProfileLayout(
                  onTap: () =>
                      route.pushNamed(context, routeName.profileDetails)),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            SvgPicture.asset(eSvgAssets.pLine),
            SvgPicture.asset(eSvgAssets.pLine)
          ]).paddingSymmetric(horizontal: Insets.i40)
        ]).paddingOnly(bottom: isServiceman ? Sizes.s48 : Insets.i63),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: Insets.i17),
            height: isServiceman ? Sizes.s48 : Sizes.s66,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(eImageAssets.balanceContainer))),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(language(context, translations!.typeOfProvider),
                    style: appCss.dmDenseRegular12
                        .textColor(appColor(context).appTheme.whiteColor)),
                Text(
                    language(
                        context,
                        isFreelancer
                            ? translations!.freelancer
                            : isServiceman
                                ? translations!.serviceman
                                : translations!.company),
                    style: appCss.dmDenseMedium12
                        .textColor(appColor(context).appTheme.whiteColor))
              ]),
              if (!isServiceman) const VSpace(Sizes.s4),
              if (!isServiceman)
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          language(
                              context,
                              isFreelancer
                                  ? translations!.noOfCompletedService
                                  : isServiceman
                                      ? translations!.noOfCompletedService
                                      : translations!.noOfServicemen),
                          style: appCss.dmDenseRegular12.textColor(
                              appColor(context).appTheme.whiteColor)),
                      Text(
                          userModel != null
                              ? isFreelancer
                                  ? userModel!.served != null
                                      ? userModel!.served!
                                      : "0"
                                  : dashBoardModel?.totalServicemen
                                          .toString() ??
                                      "0" /* servicemanList.length.toString() */
                              : "0",
                          style: appCss.dmDenseMedium12
                              .textColor(appColor(context).appTheme.whiteColor))
                    ])
            ]).paddingSymmetric(vertical: Insets.i12, horizontal: Insets.i15))
      ]);
    });
  }
}

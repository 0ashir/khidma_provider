import 'dart:developer';

import 'package:fixit_provider/screens/app_pages_screens/provider_details_screen/layouts/personal_detail_layout.dart';

import '../../../../config.dart';

class ProviderTopLayout extends StatelessWidget {
  const ProviderTopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderDetailsProvider>(
        builder: (context, providerCtrl, child) {
      return Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(appColor(context).isDarkMode
                      ? eImageAssets.providerBgDark
                      : eImageAssets.providerBg),
                  fit: BoxFit.fill)),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProfilePicCommon(
                        isProfile: false,
                        imageUrl: provider!.media != null &&
                                provider!.media!.isNotEmpty
                            ? provider!.media![0].originalUrl
                            : null)
                    .alignment(Alignment.center),
                const VSpace(Sizes.s8),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(provider!.name ?? '',
                      style: appCss.dmDenseSemiBold14
                          .textColor(appColor(context).appTheme.darkText)),
                  const HSpace(Sizes.s6),
                  SvgPicture.asset(eSvgAssets.verify,
                      height: Sizes.s20, width: Sizes.s20)
                ]),
                const VSpace(Sizes.s6),
                IntrinsicHeight(
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      if (provider!.reviewRatings != null)
                        Column(children: [
                          RatingLayout(
                              initialRating: provider!.reviewRatings ?? 0.0,
                              color: const Color(0xffFFC412)),
                          Text("${provider!.reviewRatings ?? 0} reviews",
                              style: appCss.dmDenseMedium13.textColor(
                                  appColor(context).appTheme.darkText))
                        ]),
                      if (provider!.reviewRatings != null)
                        VerticalDivider(
                                width: 1,
                                color: appColor(context).appTheme.stroke,
                                indent: 3,
                                endIndent: 3)
                            .paddingSymmetric(horizontal: Insets.i10),
                      Text(
                          "${provider!.experienceDuration ?? 0} ${provider!.experienceInterval != null ? capitalizeFirstLetter(provider!.experienceInterval) : "Years"} ${translations!.of} ${language(context, translations!.experience)}",
                          style: appCss.dmDenseMedium13
                              .textColor(appColor(context).appTheme.darkText))
                    ])),
                const VSpace(Sizes.s20),
                const DottedLines(),
                const VSpace(Sizes.s10),
                ServicesDeliveredLayout(services: provider!.served ?? "0"),
                Text(language(context, translations!.detailsOfProvider),
                        style: appCss.dmDenseMedium12
                            .textColor(appColor(context).appTheme.lightText))
                    .paddingOnly(top: Insets.i15, bottom: Insets.i8),
                if (provider!.description != null)
                  Text(provider!.description!,
                      style: appCss.dmDenseMedium14
                          .textColor(appColor(context).appTheme.darkText)),
                Text(language(context, translations!.personalInfo),
                        style: appCss.dmDenseMedium12
                            .textColor(appColor(context).appTheme.lightText))
                    .paddingOnly(top: Insets.i15, bottom: Insets.i8),
                PersonalDetailLayout(
                    email: provider!.email!,
                    phone:
                        "+${provider!.code} ${provider!.phone/*!.replaceRange(5, provider!.phone!.length, "*")*/}",
                    knownLanguage: provider!.knownLanguages)
              ]).paddingAll(Insets.i20));
    });
  }
}

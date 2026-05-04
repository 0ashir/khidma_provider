import '../../../../../common/languages/app_language.dart';
import '../../../../../config.dart';
import 'description_layout.dart';

class JobRequestServiceDescription extends StatelessWidget {
  final dynamic services;

  const JobRequestServiceDescription({super.key, this.services});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
            child: JobDescriptionLayout(
                icon: eSvgAssets.clock,
                title: translations!.time,
                subtitle:
                    "${services?.duration ?? ""} ${services!.durationUnit ?? ""}")),
        Container(
          color: appColor(context).appTheme.stroke,
          width: 2,
          height: Sizes.s78,
        ),
        if (services!.bids != [])
          Expanded(
            child: JobDescriptionLayout(
                    icon: eSvgAssets.category,
                    title: translations!.category,
                    subtitle: services!.category[0] is Map
                        ? services!.category[0]['title']
                        : services!.category[0].title)
                .paddingOnly(
                    left: AppLocalizations.of(context)?.locale.languageCode ==
                            "ar"
                        ? 0
                        : Insets.i20,
                    right: AppLocalizations.of(context)?.locale.languageCode ==
                            "ar"
                        ? 0
                        : Insets.i20),
          )
      ]).paddingSymmetric(horizontal: Insets.i25),
      const DottedLines(),
      const VSpace(Sizes.s17),
      JobDescriptionLayout(
              icon: eSvgAssets.account,
              title: translations!.requiredServiceman,
              subtitle:
                  "${services!.requiredServicemen ?? '1'} ${capitalizeFirstLetter(language(context, translations!.serviceman))}")
          .paddingSymmetric(horizontal: Insets.i25),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (services!.description != null)
          Text(language(context, translations!.description),
              style: appCss.dmDenseMedium12
                  .textColor(appColor(context).appTheme.lightText)),
        const VSpace(Sizes.s6),
        if (services!.description != null)
          ReadMoreLayout(text: services!.description!),
        const VSpace(Sizes.s20),
      ]).paddingSymmetric(horizontal: Insets.i20, vertical: Insets.i20)
    ]).boxBorderExtension(context, isShadow: true);
  }
}

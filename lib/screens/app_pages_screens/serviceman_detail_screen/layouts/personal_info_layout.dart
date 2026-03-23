import 'dart:developer';

import '../../../../config.dart';

class PersonalInfoLayout extends StatelessWidget {
  final ServicemanModel? servicemanModel;
  const PersonalInfoLayout({super.key, this.servicemanModel});

  @override
  Widget build(BuildContext context) {
    log("servicemanModel!.knownLanguages::${servicemanModel!.description}");
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(language(context, translations!.personalInfo),
          style: appCss.dmDenseMedium14
              .textColor(appColor(context).appTheme.darkText)),
      const VSpace(Sizes.s10),
      Column(children: [
        PersonalInfoRowLayout(
            icon: eSvgAssets.email,
            title: translations!.mail,
            content: servicemanModel!.email),
        const VSpace(Sizes.s20),
        PersonalInfoRowLayout(
            icon: eSvgAssets.phone,
            title: translations!.call,
            content:
                "+${servicemanModel!.code ?? "1"} ${servicemanModel!.phone}")
      ])
          .paddingSymmetric(vertical: Insets.i12, horizontal: Insets.i15)
          .boxShapeExtension(color: appColor(context).appTheme.fieldCardBg),
      if (servicemanModel!.knownLanguages != null &&
          servicemanModel!.knownLanguages!.isNotEmpty)
        Text(language(context, translations!.knowLanguage),
                style: appCss.dmDenseMedium14
                    .textColor(appColor(context).appTheme.darkText))
            .alignment(Alignment.centerLeft)
            .paddingOnly(top: Insets.i20, bottom: Insets.i10),
      if (servicemanModel!.knownLanguages != null &&
          servicemanModel!.knownLanguages!.isNotEmpty)
        Wrap(
            direction: Axis.horizontal,
            children: servicemanModel!.knownLanguages!
                .asMap()
                .entries
                .map((e) => LanguageLayout(title: e.value.key)
                    .marginOnly(bottom: Insets.i10))
                .toList()),
      if (servicemanModel!.knownLanguages != null &&
          servicemanModel!.knownLanguages!.isNotEmpty)
        const VSpace(Sizes.s20),
      if (servicemanModel!.expertise != null &&
          servicemanModel!.expertise!.isNotEmpty)
        Text(language(context, translations!.expertiseIn),
                style: appCss.dmDenseMedium14
                    .textColor(appColor(context).appTheme.darkText))
            .alignment(Alignment.centerLeft),
      if (servicemanModel!.expertise != null &&
          servicemanModel!.expertise!.isNotEmpty)
        const VSpace(Sizes.s10),
      if (servicemanModel!.expertise != null &&
          servicemanModel!.expertise!.isNotEmpty)
        Wrap(
            direction: Axis.horizontal,
            children: servicemanModel!.expertise!
                .asMap()
                .entries
                .map((e) => Text(
                        language(context,
                            "\u2022  ${language(context, e.value.title)}"),
                        style: appCss.dmDenseMedium12
                            .textColor(appColor(context).appTheme.darkText))
                    .paddingOnly(right: Insets.i25))
                .toList()),
      const VSpace(Sizes.s20),
      if (servicemanModel!.description != null &&
          servicemanModel!.description!.isNotEmpty)
        Text(language(context, translations!.description),
                style: appCss.dmDenseMedium14
                    .textColor(appColor(context).appTheme.darkText))
            .alignment(Alignment.centerLeft),
      if (servicemanModel!.description != null &&
          servicemanModel!.description!.isNotEmpty)
        const VSpace(Sizes.s10),
      Text(servicemanModel!.description ?? "",
              style: appCss.dmDenseMedium12
                  .textColor(appColor(context).appTheme.lightText))
          .alignment(Alignment.centerLeft)
    ]);
  }
}

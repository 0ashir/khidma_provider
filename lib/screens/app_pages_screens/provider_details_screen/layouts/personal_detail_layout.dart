import '../../../../config.dart';

class PersonalDetailLayout extends StatelessWidget {
  final String? email, phone;
  final List<KnownLanguageModel>? knownLanguage;

  const PersonalDetailLayout(
      {super.key, this.email, this.phone, this.knownLanguage});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      PersonalInfoRowLayout(
              icon: eSvgAssets.email, title: translations!.mail, content: email)
          .inkWell(onTap: () => commonUrlTap(context, email!)),
      PersonalInfoRowLayout(
        icon: eSvgAssets.phone,
        title: translations!.call,
        content: phone,
      ).paddingSymmetric(vertical: Insets.i20),
      Row(children: [
        SvgPicture.asset(eSvgAssets.country,
            colorFilter: ColorFilter.mode(
                appColor(context).appTheme.lightText, BlendMode.srcIn)),
        const HSpace(Sizes.s6),
        Text(language(context, translations!.knowLanguage),
            style: appCss.dmDenseMedium12
                .textColor(appColor(context).appTheme.lightText))
      ]),
      const VSpace(Sizes.s7),
      if (knownLanguage!.isNotEmpty)
        Wrap(
            direction: Axis.horizontal,
            children: knownLanguage!
                .asMap()
                .entries
                .map((e) =>
                    LanguageLayout(title: e.value.key).paddingOnly(bottom: 10))
                .toList())
    ])
        .paddingAll(Insets.i12)
        .boxShapeExtension(color: appColor(context).appTheme.whiteBg);
  }
}

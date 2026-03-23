import '../../../config.dart';

class ProviderChatLayout {
  commonSvgRowText(context,
      {String? mainTitle,
      String? valueText,
      String? svg,
      bool isExpired = false,
      bool? rejected = false}) {
    return Row(children: [
      SvgPicture.asset(
        svg!,
        colorFilter: ColorFilter.mode(
            isExpired || rejected!
                ? appColor(context).appTheme.lightText
                : appColor(context).appTheme.whiteColor,
            BlendMode.srcIn),
      ),
      const HSpace(Sizes.s10),
      Text("${language(context, mainTitle)} :",
          style: appCss.dmDenseMedium12.textColor(isExpired || rejected!
              ? appColor(context).appTheme.lightText.withOpacity(0.5)
              : appColor(context).appTheme.whiteColor)),
      const HSpace(Sizes.s2),
      Expanded(
          child: Text(language(context, valueText),
              style: appCss.dmDenseMedium12.textColor(isExpired || rejected!
                  ? appColor(context).appTheme.lightText.withOpacity(0.5)
                  : appColor(context).appTheme.whiteColor)))
    ]);
  }

  txtWithTextField(context,
      {String? title,
      String? hintText,
      String? svg,
      TextEditingController? controller,
      TextInputType? keyboardType}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        children: [
          const SmallContainer(),
          const HSpace(Sizes.s20),
          Text(language(context, title),
              style: appCss.dmDenseMedium14
                  .textColor(appColor(context).appTheme.darkText)),
        ],
      ),
      const VSpace(Sizes.s8),
      TextFormField(
        controller: controller,
        validator: (value) => validation.dynamicTextValidation(
            context, value, appFonts.enterDetails),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          filled: true,
            fillColor: appColor(context).appTheme.whiteBg,
            prefixIcon: SvgPicture.asset(
              fit: BoxFit.scaleDown,
              svg!,
              colorFilter: ColorFilter.mode(
                  appColor(context).appTheme.lightText, BlendMode.srcIn),
            ).padding(vertical: Sizes.s10, left: Sizes.s10),
            hintText: language(context, hintText),
            hintStyle: appCss.dmDenseMedium14
                .textColor(appColor(context).appTheme.lightText),
            enabled: true,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Sizes.s8),
                borderSide:
                    BorderSide(color: appColor(context).appTheme.stroke)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Sizes.s8),
                borderSide:
                    BorderSide(color: appColor(context).appTheme.stroke))),
      ).paddingDirectional(horizontal: Sizes.s20 ),
    ]);
  }

  txtWithTextFieldWithoutValidation(context,
      {String? title,
      String? hintText,
      String? svg,
      TextEditingController? controller}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        children: [
          const SmallContainer(),
          const HSpace(Sizes.s20),
          Text(language(context, title),
              style: appCss.dmDenseMedium14
                  .textColor(appColor(context).appTheme.darkText)),
        ],
      ),
      const VSpace(Sizes.s8),
      TextFormField(

        decoration: InputDecoration(
          fillColor: appColor(context).appTheme.whiteBg,filled: true,
            prefixIcon: SvgPicture.asset(
              fit: BoxFit.scaleDown,
              svg!,
              colorFilter: ColorFilter.mode(
                  appColor(context).appTheme.lightText, BlendMode.srcIn),
            ).padding(vertical: Sizes.s10, left: Sizes.s10),
            hintText: language(context, hintText),
            hintStyle: appCss.dmDenseMedium14
                .textColor(appColor(context).appTheme.lightText),
            enabled: true,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Sizes.s8),
                borderSide:
                    BorderSide(color: appColor(context).appTheme.stroke)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Sizes.s8),
                borderSide:
                    BorderSide(color: appColor(context).appTheme.stroke))),
      ).paddingDirectional(horizontal: Sizes.s20),
    ]);
  }
}

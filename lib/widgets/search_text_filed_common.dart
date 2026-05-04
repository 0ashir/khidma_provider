import '../config.dart';

class SearchTextFieldCommon extends StatelessWidget {
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged, onFieldSubmitted;
  final String? hinText;
  final GestureTapCallback? onTap;
  const SearchTextFieldCommon(
      {super.key,
      this.controller,
      this.suffixIcon,
      this.onChanged,
      this.focusNode,
      this.onFieldSubmitted,
      this.hinText,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextFieldCommon(
        focusNode: focusNode,
        hintStyle: appCss.dmDenseRegular12
            .textColor(appColor(context).appTheme.lightText),
        radius: AppRadius.r23,
        onTap: onTap,
        hintText: hinText ?? translations!.searchHere!,
        controller: controller,
        onFieldSubmitted: onFieldSubmitted,
        fillColor: appColor(context).appTheme.fieldCardBg,
        suffixIcon: suffixIcon,
        onChanged: onChanged,
        prefixIcon: eSvgAssets.search);
  }
}

/*
import 'package:flutter/cupertino.dart';
import '../../../../config.dart';

class CountryListLayout extends StatelessWidget {
  final Function(CountryCode?)? onChanged;
  const CountryListLayout({Key? key,this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
            height: Sizes.s50,
            child: CountryListPick(
                appBar: AppBar(
                    centerTitle: true,
                    title: Text(translations!.selectCountry,
                        style: appCss.dmDenseBold20.textColor(
                            appColor(context).appTheme.whiteBg)),
                    elevation: 0,
                    backgroundColor: appColor(context).appTheme.primary),
                pickerBuilder: (context, CountryCode? countryCode) {
                  return Row(children: [
                    Image.asset("${countryCode!.flagUri}",
                        package: 'country_list_pick',
                        width: Sizes.s22,
                        height: Sizes.s16),
                    Text(countryCode.dialCode.toString(),
                            style: appCss.dmDenseMedium14.textColor(
                                appColor(context).appTheme.darkText))
                        .paddingSymmetric(horizontal: Insets.i5),
                    Icon(CupertinoIcons.chevron_down,
                        size: Sizes.s16,
                        color: appColor(context).appTheme.darkText)
                  ]);
                },
                theme: CountryTheme(
                    isShowFlag: true,
                    alphabetSelectedBackgroundColor:
                        appColor(context).appTheme.primary),
                initialSelection: '+1',

                onChanged:onChanged))
        .decorated(
            color: appColor(context).appTheme.whiteBg,
            borderRadius:
                const BorderRadius.all(Radius.circular(AppRadius.r8)));
  }
}
*/

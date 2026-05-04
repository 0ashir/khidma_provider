import 'dart:developer';
import '../../../../config.dart';
import '../../../../model/system_language_model.dart';

class LanguageDropDownLayout extends StatelessWidget {
  const LanguageDropDownLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(builder: (context, langProvider, child) {
      log("languageCtrl.currentLanguage::${langProvider.currentLanguage}");
      log("Language List: ${langProvider.sharedPreferences.getString("selectedLocale")}");
      String? val = langProvider.sharedPreferences.getString("selectedLocale");
      // Ensure currentLanguage is valid or set a default
      final currentLanguage =
          langProvider.languageList.any((element) => element.locale == val)
              ? langProvider.languageList
                  .firstWhere((element) => element.locale == val)
                  .name
              : null;

      return SizedBox(
        width: Sizes.s100,
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            child: DropdownButton(
              value: currentLanguage,
              borderRadius:
                  const BorderRadius.all(Radius.circular(AppRadius.r8)),
              style: appCss.dmDenseMedium16
                  .textColor(appColor(context).appTheme.lightText),
              icon: SvgPicture.asset(eSvgAssets.dropDown,
                  colorFilter: ColorFilter.mode(
                      appColor(context).appTheme.darkText, BlendMode.srcIn)),
              isDense: true,
              isExpanded: true,
              hint: Text(
                langProvider.sharedPreferences.getString("selectedLocale") ??
                    "Select Language",
              ),
              items: langProvider.languageList.map((e) {
                return DropdownMenuItem(
                  value: e.name, // Use the 'title' as value
                  child: Text(e.name.toString()),
                );
              }).toList(),
              onChanged: (val) async {
                int index = langProvider.languageList
                    .indexWhere((element) => element.name == val);
                if (index != -1) {
                  // Only proceed if a matching language is found
                  SystemLanguage systemLanguage =
                      langProvider.languageList[index];
                  langProvider.currentLanguage = val.toString();
                  langProvider.changeLocale(systemLanguage, context);
                  log("langProvider.currentLanguage: ${langProvider.currentLanguage}");
                } else {
                  log("Error: Selected value '$val' not found in languageList.");
                  // Optionally, handle this case (e.g., reset the dropdown)
                }
              },
            ),
          ),
        ).paddingAll(Insets.i7).decorated(
              color: appColor(context).appTheme.whiteBg,
              borderRadius: BorderRadius.circular(AppRadius.r6),
              boxShadow: isDark(context)
                  ? []
                  : [
                      BoxShadow(
                        color: appColor(context).appTheme.fieldCardBg,
                        blurRadius: AppRadius.r10,
                        spreadRadius: AppRadius.r5,
                      )
                    ],
              border: Border.all(color: appColor(context).appTheme.fieldCardBg),
            ),
      );
    });
  }
}

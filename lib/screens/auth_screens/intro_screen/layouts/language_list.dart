import 'package:fixit_provider/config.dart';

class LanguageList {
  List<Widget> langList(int? index, context) {
    var language = Provider.of<LanguageProvider>(context, listen: false);
    return List.generate(language.languageList.length, (i) {
      return i == index
          ? Row(children: [
              Image.asset(language.languageList[index!].flag.toString(),
                  width: Sizes.s30, height: Sizes.s30),
              const HSpace(Sizes.s5),
              Text(
                  language.languageList[index].name!
                      .toString()
                      .substring(0, 2)
                      .toUpperCase(),
                  style: appCss.dmDenseMedium14
                      .textColor(appColor(context).appTheme.darkText),
                  overflow: TextOverflow.ellipsis)
            ])
          : Container();
    });
  }

  DropdownMenuItem<String> dropDown(Map<String, dynamic> data, context,
          {GestureTapCallback? onTap}) =>
      DropdownMenuItem<String>(
          value: data["title"].toString(),
          onTap: onTap,
          child: Row(children: [
            Image.asset(data['icon'].toString(),
                width: Sizes.s30, height: Sizes.s30),
            const HSpace(Sizes.s5),
            SizedBox(
                width: Sizes.s50,
                child: Text(language(context, data["title"]!.toString()),
                    style: appCss.dmDenseMedium14
                        .textColor(appColor(context).appTheme.lightText),
                    overflow: TextOverflow.ellipsis))
          ]));
}

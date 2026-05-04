import 'package:fixit_provider/config.dart';
import 'package:fixit_provider/screens/app_pages_screens/advertising_screens/ads_service_list_layout.dart';
import 'package:flutter/material.dart';

class AdsServiceList extends StatelessWidget {
  const AdsServiceList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        title: Text(language(context, translations!.advertisement),
            style: appCss.dmDenseBold18
                .textColor(appColor(context).appTheme.darkText)),
        centerTitle: true,
        leading: CommonArrow(
            arrow: rtl(context) ? eSvgAssets.arrowRight : eSvgAssets.arrowLeft,
            onTap: () => route.pop(context)).paddingAll(Insets.i8),
      ),
      body: AdsServiceListLayout(),
    );
  }
}

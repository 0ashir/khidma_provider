import 'dart:developer';

import 'package:flutter_html/flutter_html.dart';
import 'package:fixit_provider/model/page_model.dart';

import '../../../../config.dart';

class PageDetail extends StatelessWidget {
  final PagesModel? page;

  const PageDetail({super.key, this.page});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leadingWidth: 80,
            title: Text(page!.title!,
                style: appCss.dmDenseBold18
                    .textColor(appColor(context).appTheme.darkText)),
            centerTitle: true,
            leading: CommonArrow(
                    arrow: eSvgAssets.arrowLeft,
                    onTap: () => route.pop(context))
                .paddingDirectional(vertical: Insets.i8)),
        body: ListView(children: [
          Html(
            data: page!.content,
            onAnchorTap: (url, attributes, element) {
              if (url!.contains("mailto")) {
                mailTap(context, url.replaceAll("mailto:", ""));
              } else {
                commonUrlTap(context, url);
              }
            },
            onLinkTap: (url, attributes, element) {
              log("KKKK :$url");
            },
          )
        ]).paddingAll(Insets.i20));
  }
}

import 'package:fixit_provider/config.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text(language(context, "Maintenance Mode"),
                textAlign: TextAlign.center,
                style: appCss.dmDenseBold18
                    .textColor(appColor(context).appTheme.darkText))),
        body: EmptyLayout(
            title: appSettingModel?.maintenance?.title ?? "Maintenance Mode",
            subtitle: appSettingModel?.maintenance?.description ??
                "Our app is undergoing scheduled maintenance to enhance your experience. please check back soon!",
            isButton: false,
            widget: Stack(children: [
              CachedNetworkImage(
                height: Sizes.s346,
                imageUrl: "${appSettingModel?.maintenance?.image}",
                imageBuilder: (context, imageProvider) => Image(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
                placeholder: (context, url) => Image.asset(
                  eImageAssets.noImageFound1,
                  fit: BoxFit.fill,
                  height: Sizes.s346, /* width: Sizes.s22 */
                ).paddingAll(Insets.i18),
                errorWidget: (context, url, error) => Image.asset(
                  eImageAssets.maintenanceImage,
                  fit: BoxFit.fill,
                  height: Sizes.s346, /*  width: Sizes.s22 */
                ).paddingAll(Insets.i18),
              ),
            ])));
  }
}

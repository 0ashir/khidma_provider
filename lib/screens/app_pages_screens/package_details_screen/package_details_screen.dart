import 'dart:developer';

import 'package:fixit_provider/screens/app_pages_screens/package_details_screen/service_package_shimmer/service_package_shimmer.dart';

import '../../../config.dart';

class PackageDetailsScreen extends StatefulWidget {
  const PackageDetailsScreen({super.key});

  @override
  State<PackageDetailsScreen> createState() => _PackageDetailsScreenState();
}

class _PackageDetailsScreenState extends State<PackageDetailsScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PackageDetailProvider, DeleteDialogProvider>(
        builder: (context1, value, deleteVal, child) {
      return PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          value.onBack(context, false);
          if (didPop) return;
        },
        child: StatefulWrapper(
            onInit: () => Future.delayed(const Duration(milliseconds: 150),
                () => value.onReady(context)),
            child: RefreshIndicator(
              onRefresh: () {
                log("value.packageModel?.disclaimer:::${value.packageModel!.disclaimer}");
                return value.onRefresh(context);
              },
              child: Scaffold(
                  appBar: ActionAppBar(
                      title: translations!.packageDetails,
                      onTap: () => value.onBack(context, true),
                      actions: [
                        CommonArrow(
                                arrow: eSvgAssets.delete,
                                color: const Color(0xffFFEDED),
                                svgColor: appColor(context).appTheme.red,
                                onTap: () =>
                                    value.onPackageDelete(context, this))
                            .paddingSymmetric(horizontal: Insets.i20)
                      ]),
                  body: value.isLoading == true
                      ? const ServicePackageShimmer()
                      : SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              PackageDetailsLayout(),
                              const DottedLines()
                                  .paddingSymmetric(vertical: Insets.i15),
                              if (value.packageModel?.disclaimer != null)
                                Text(
                                    language(context, translations!.disclaimer),
                                    style: appCss.dmDenseMedium12.textColor(
                                        appColor(context).appTheme.darkText)),
                              // if (value.packageModel!.disclaimer != null)
                              //   Text(value.packageModel!.disclaimer.toString()),
                              Text(
                                  language(
                                      context, translations!.youWillOnlyGet),
                                  style: appCss.dmDenseRegular12.textColor(
                                      appColor(context).appTheme.red)),
                              ButtonCommon(
                                  title: translations!.editPackage,
                                  onTap: () => route.pushNamed(
                                          context, routeName.appPackage, arg: {
                                        'isEdit': true,
                                        "data": value.packageModel
                                      })).paddingOnly(
                                  top: Insets.i40, bottom: Insets.i30)
                            ]).paddingSymmetric(horizontal: Insets.i20))),
            )),
      );
    });
  }
}

import 'dart:developer';

import 'package:fixit_provider/config.dart';

class SubscriptionPlanProvider with ChangeNotifier {
  SubscriptionPlanModel? subscriptionPlanModel;

  //plan list
  onReady(context) {
    subscriptionPlanModel =
        SubscriptionPlanModel.fromJson(appArray.subscriptionPlanList);
    List<String> benefits = [];

    for (var d in appArray.benefits) {
      if (d == "service") {
        benefits.add(appFonts.addUpToServicePlan(
            context,
            appSettingModel!.defaultCreationLimits!.allowedMaxServices
                .toString()));
      } else if (d == "servicemen") {
        benefits.add(appFonts.addUpToServicemanPlan(
            context,
            appSettingModel!.defaultCreationLimits!.allowedMaxServicemen
                .toString()));
      } else if (d == "serviceLocation") {
        benefits.add(appFonts.addUpToLocationPlan(
            context,
            appSettingModel!.defaultCreationLimits!.allowedMaxAddresses
                .toString()));
      } else if (d == "packages") {
        benefits.add(appFonts.addUpToServicePackagePlan(
            context,
            appSettingModel!.defaultCreationLimits!.allowedMaxServicePackages
                .toString()));
      }
      notifyListeners();
    }
    subscriptionPlanModel!.benefits = benefits;
    log("value.subscriptionPlanModel:::${subscriptionPlanModel!.benefits}");
    notifyListeners();
  }
}

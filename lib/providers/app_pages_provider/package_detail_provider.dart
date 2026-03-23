// ignore_for_file: unused_local_variable

import 'dart:developer';

import 'package:fixit_provider/config.dart';

class PackageDetailProvider with ChangeNotifier {
  ServicePackageModel? packageModel;
  double widget1Opacity = 0.0;

  onReady(context) async {
    dynamic data = ModalRoute.of(context)!.settings.arguments;
    // packageModel = data;
    // await getServicePackageById(context, data.id);
    notifyListeners();
    // Future.delayed(const Duration(milliseconds: 500), () {
    //   widget1Opacity = 1;
    //   notifyListeners();
    // });
  }

  onRefresh(context) async {
    showLoading(context);
    notifyListeners();
    // await getServicePackageById(context, packageModel!.id);
    hideLoading(context);
    notifyListeners();
  }

  bool isLoading = false;
  Future<void> getServicePackageById(context, serviceId) async {
    isLoading = true;
    log("serviceId::${api.servicePackage}/$serviceId");
    try {
      await apiServices
          .getApi("${api.servicePackage}/$serviceId", []).then((value) {
        if (value.isSuccess!) {
          isLoading = false;
          notifyListeners();

          packageModel = ServicePackageModel.fromJson(value.data);
          log("packageModel:::${packageModel}");
          notifyListeners();
        } else {
          /*  snackBarMessengers(context, message: value.message); */
          isLoading = false;
        }
      });
    } catch (e) {
      isLoading = false;
      log("ERRROEEE getServicePackageById : $e");
      notifyListeners();
    }
  }

  onBack(context, isBack) async {
    if (isBack) {
      route.pop(context);
    }
    // packageModel = null;
    // widget1Opacity = 0.0;
    notifyListeners();
  }

  //package delete confirmation
  onPackageDelete(context, sync) {
    final value = Provider.of<DeleteDialogProvider>(context, listen: false);
    final package = Provider.of<PackageListProvider>(context, listen: false);

    value.onDeleteDialog(
        sync,
        context,
        eImageAssets.packageDelete,
        translations!.deletePackages,
        translations!.areYouSureDeletePackage, () {
      package.deletePackage(context, packageModel!.id);
      route.pop(context);
      route.pop(context);
      // notifyListeners();
    });
    value.notifyListeners();
  }
}

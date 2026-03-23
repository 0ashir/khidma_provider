import 'dart:developer';

import 'package:fixit_provider/config.dart';

class ServicemenDetailProvider with ChangeNotifier {
  XFile? imageFile;
  int? id;
  bool isIcons = true;
  ServicemanModel? servicemanModel;
  double widget1Opacity = 1;

/*
  onReady(context) async {
    dynamic data = ModalRoute.of(context)!.settings.arguments ?? "";
    log("data :$data");
    notifyListeners();
    if (data != null) {
      isIcons = data['isShow'] ?? true;
      id = data["detail"];
      await getServicemenById(context);
      Future.delayed(const Duration(milliseconds: 500), () {
        widget1Opacity = 1;
        notifyListeners();
      });
    } else {
      widget1Opacity = 1;
      notifyListeners();
    }

    notifyListeners();
  }
*/

  //page init data fetch
  onReady(context) async {
    dynamic data = ModalRoute.of(context)!.settings.arguments ?? "";
    log("data :$data");
    notifyListeners();

    if (data != null) {
      if (data is Map && data.containsKey("detail")) {
        isIcons = data['isShow'] ?? true;
        id = data["detail"];
        log("dasdsadsadasdsadsad:");
        Future.delayed(const Duration(milliseconds: 150), () async {
          await getServicemenById(context, id: id);
          // widget1Opacity = 1;
          notifyListeners();
        });
      } else {
        /* servicemanModel = data; */
        id = servicemanModel!.id;
        log("AAAAA: $id");
        log("AAAAA: ${servicemanModel!.knownLanguages}");
      }
    } else {
      hideLoading(context);
      notifyListeners();
    }
    Future.delayed(const Duration(milliseconds: 150), () {
      widget1Opacity = 1;
      notifyListeners();
    });
    // notifyListeners();
  }

  onBack(context, isBack) async {
    servicemanModel = null;
    widget1Opacity = 1;
    notifyListeners();
    if (isBack) {
      route.pop(context);
    }
  }

  // GET IMAGE FROM GALLERY
  Future getImage(context, source) async {
    final ImagePicker picker = ImagePicker();
    route.pop(context);
    imageFile = (await picker.pickImage(source: source, imageQuality: 70))!;
    notifyListeners();
  }

  //edit servicemane detail
  editServicemanDetail(context) {
    getServicemenById(context, id: servicemanModel?.id);
    route.pushNamed(context, routeName.addServicemen,
        arg: servicemanModel) /*  .then((e) => getServicemenById(context)) */;
  }

  onRefresh(context) async {
    showLoading(context);
    notifyListeners();
    await getServicemenById(
      context,
    );
    hideLoading(context);
    notifyListeners();
  }

  //get serviceman id
  getServicemenById(context, {id}) async {
    try {
      await apiServices
          .getApi("${api.serviceman}/$id", [], isData: true)
          .then((value) {
        if (value.isSuccess!) {
          log("data 123: ${value.data}");
          servicemanModel = ServicemanModel.fromJson(value.data['data']);
          log("data 12345: $servicemanModel");
        }
        notifyListeners();
      });
    } catch (e) {
      log("ERRROEEE getServicemenById : $e");
      notifyListeners();
    }
  }

  onServicemenDelete(context, sync) {
    final value = Provider.of<DeleteDialogProvider>(context, listen: false);

    value.onDeleteDialog(
        sync,
        context,
        eImageAssets.servicemen,
        translations!.deleteServicemen,
        translations!.areYouSureDeleteServicemen, () {
      route.pop(context);
      deleteServiceman(context);
    });
    value.notifyListeners();
  }

  //delete Serviceman
  deleteServiceman(context, {isBack = false}) async {
    showLoading(context);

    try {
      await apiServices
          .deleteApi("${api.serviceman}/$id", {}, isToken: true)
          .then((value) {
        hideLoading(context);

        notifyListeners();
        if (value.isSuccess!) {
          final common =
              Provider.of<UserDataApiProvider>(context, listen: false);
          common.getServicemenByProviderId();

          final delete =
              Provider.of<DeleteDialogProvider>(context, listen: false);
          delete.onResetPass(
              context,
              language(context, translations!.hurrayServicemenDelete),
              language(context, translations!.okay), () {
            route.pop(context);
            route.pop(context);
          }, title: translations!.deleteSuccessfully);
          notifyListeners();
        } else {
          snackBarMessengers(context,
              color: appColor(context).appTheme.red, message: value.message);
        }
      });
    } catch (e) {
      hideLoading(context);
      notifyListeners();
      log("EEEE deleteServiceman : $e");
    }
  }
}

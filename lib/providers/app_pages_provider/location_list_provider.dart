import 'dart:developer';
import 'package:fixit_provider/config.dart';
import 'package:dio/dio.dart' as dio;

class LocationListProvider with ChangeNotifier {
  List selectedLocation = [];

  List locationList = [];
  String? subtext;
  int? id;

  TextEditingController areaCtrl = TextEditingController();
  TextEditingController latitudeCtrl = TextEditingController();
  TextEditingController longitudeCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();
  TextEditingController zipcodeCtrl = TextEditingController();

  FocusNode areaFocus = FocusNode();
  FocusNode latitudeFocus = FocusNode();
  FocusNode longitudeFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  FocusNode zipcodeFocus = FocusNode();

  //multiple address select or unselect
  onTapLocation(id, val) {
    if (!selectedLocation.contains(id)) {
      selectedLocation.add(id);
    } else {
      selectedLocation.remove(id);
    }
    notifyListeners();
  }

  //page init data fetch
  onReady(context) {
    dynamic data = ModalRoute.of(context)!.settings.arguments;

    if (data != null) {
      id = data;
    }
    notifyListeners();
  }

  //delete location confirmation
  onLocationDelete(index, context, sync, id) {
    final value = Provider.of<DeleteDialogProvider>(context, listen: false);

    value.onDeleteDialog(sync, context, eImageAssets.location,
        translations!.delete, translations!.areYiuSureDeleteLocation, () {
      addressList.removeAt(index);
      route.pop(context);
      final userApi = Provider.of<UserDataApiProvider>(context, listen: false);
      userApi.deleteAddress(context, id);
      notifyListeners();
    });
    value.notifyListeners();
    notifyListeners();
  }

  //add service availability api
  onAddSelectLocation(context) {
    if (selectedLocation.isNotEmpty) {
      showLoading(context);
      notifyListeners();
      addServiceAvailabilityApi(context);
    } else {
      scaffoldMessage(context, appFonts.selectLocationFirst);
    }
  }

//add Address Api in Service
  addServiceAvailabilityApi(context) async {
    showLoading(context);
    notifyListeners();

    var body = {
      for (var i = 0; i < selectedLocation.length; i++)
        "address_ids[$i]": selectedLocation[i],
    };
    dio.FormData formData = dio.FormData.fromMap(body);

    log("BODU :$body");

    try {
      await apiServices
          .postApi("${api.addServiceAddress}/$id", formData, isToken: true)
          .then((value) async {
        hideLoading(context);
        notifyListeners();

        if (value.isSuccess!) {
          final serviceDetail =
              Provider.of<ServiceDetailsProvider>(context, listen: false);
          serviceDetail.getServiceId(context);
          final userApi =
              Provider.of<UserDataApiProvider>(context, listen: false);
          await userApi.getAddressList(context);
          snackBarMessengers(context,
              message: value.message, color: appColor(context).appTheme.green);

          selectedLocation = [];

          notifyListeners();

          route.pop(context);
        } else {
          final userApi =
              Provider.of<UserDataApiProvider>(context, listen: false);
          await userApi.getAddressList(context);
        }
      });
    } catch (e) {
      hideLoading(context);
      notifyListeners();
      log("EEEE addServiceman : $e");
    }
  }

  // on edit location tap
  onEditLocation(index, PrimaryAddress val, context) {
    notifyListeners();

    route.pushNamed(context, routeName.location,
        arg: {"index": index, "isEdit": true, "data": val}).then((e) async {
      final userApi = Provider.of<UserDataApiProvider>(context, listen: false);
      await userApi.getAddressList(context);
    });
  }
}

// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fixit_provider/model/service_add_ons_get_model.dart';
import 'package:fixit_provider/services/environment.dart';
import 'package:fixit_provider/utils/toast_utils.dart';
import 'package:fixit_provider/widgets/on_delete_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../config.dart';

class ServiceAddOnsProvider with ChangeNotifier {
  GlobalKey<FormState> addPackageFormKey = GlobalKey<FormState>();
  bool isEdit = false;
  bool isSwitch = true;
  var selectedLocaleService = "en";
  ServiceAddOnsGetModel? serviceAddOnsGet;
  final dioo = Dio();

  // List<Services> serviceList = [];
  // String? selectedTitle;

  onTapSwitch(val) {
    isSwitch = val;
    notifyListeners();
  }

  TextEditingController title = TextEditingController();
  TextEditingController price = TextEditingController();

  onAddOnsDelete(context, id) {
    final value = Provider.of<DeleteDialogProvider>(context, listen: false);

    /* value.onDeleteDialog(
        context,
        eImageAssets.packageDelete,
        translations!.deletePackages,
        translations!.areYouSureDeletePackage, () {
      route.pop(context);
      deleteAddOns(context, id);
    }); */
    onDeleteDialog(
        context,
        eImageAssets.packageDelete,
        translations!.deleteAddOnService,
        translations!.areYouSureDeleteAddOnService, () {
      route.pop(context);
      deleteAddOns(context, id);
    });
    value.notifyListeners();
  }

  onDeleteDialog(context, image, title, subtitle, onDelete) {
    showDialog(
        context: context,
        builder: (context1) {
          return StatefulBuilder(builder: (context2, setState) {
            return Consumer<DeleteDialogProvider>(
                builder: (context3, value, child) {
              return OnDeleteDialog(
                  image: image,
                  onDelete: onDelete,
                  subtitle: subtitle,
                  title: title);
            });
          });
        }).then((value) {
      /* isPositionedRight = false;
      isAnimateOver = false; */
      notifyListeners();
    });
  }

  deleteAddOns(context, id) async {
    showLoading(context);
    notifyListeners();
    try {
      log("id:::$id");
      await apiServices
          .deleteApi("${api.additionalService}/$id", {}, isToken: true)
          .then((value) {
        notifyListeners();
        if (value.isSuccess!) {
          hideLoading(context);
          final common =
              Provider.of<UserDataApiProvider>(context, listen: false);
          common.getServiceAddOnsList();

          notifyListeners();
          final delete =
              Provider.of<DeleteDialogProvider>(context, listen: false);
          delete.onResetPass(
              context,
              language(context, translations!.hurrayPackageDelete),
              language(context, translations!.okay), () {
            route.pop(context);
            notifyListeners();
          });

          notifyListeners();
        } else {
          hideLoading(context);
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

  bool isLoading = false;

  Future<void> getServiceAddOnsId(context, Id) async {
    isLoading = true;
    log("serviceId::${api.additionalService}/$Id");
    try {
      //
      // final response = await dioo.get(
      //   "${api.additionalService}/${serviceAddOnsGet?.id}",
      //   options: Options(
      //     headers: headersToken(
      //       token,
      //       localLang: selectedLocale,
      //       isLang: true,
      //     ),
      //   ),
      // );
      //
      await apiServices
          .getApi("${api.additionalService}/$Id", [], isToken: true)
          .then((value) {
        log("dfhsuvndfisudfhsuniosh ${value.isSuccess}");
        if (value.isSuccess!) {
          isLoading = false;
          notifyListeners();
          Provider.of<UserDataApiProvider>(context, listen: false)
              .getAllServiceList();
          serviceAddOnsGet = ServiceAddOnsGetModel.fromJson(value.data);
          // allServiceList  = serviceAddOnsGet?.parentId;
          final parentId = serviceAddOnsGet?.parentId;
          if (parentId != null) {
            final matchedService = allServiceList.firstWhere(
              (service) => service.id == parentId,
              orElse: () => Services(), // Return empty if not found
            );

            // Only set if found
            if (matchedService.id != null) {
              selectedService = matchedService;
            }
          }

          log("sdadasdasd $allServiceList===== asdas");
          title.text = serviceAddOnsGet!.title.toString();
          price.text = serviceAddOnsGet!.price.toString();
          isSwitch = serviceAddOnsGet!.status == 0 ? false : true;

          log("packageModel:::$serviceAddOnsGet");
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

  String selectedServiceTitle = '';

  Future<File> _urlToFile(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    final documentDirectory = await getTemporaryDirectory();
    final filePath = '${documentDirectory.path}/${imageUrl.split('/').last}';
    final file = File(filePath);
    return file.writeAsBytes(response.bodyBytes);
  }

  Future<void> updateServiceAddOn(context) async {
    isLoading = true;
    notifyListeners();

    try {
      // Prepare multipart form data
      final Map<String, dynamic> formDataMap = {
        '_method': 'PUT',
        'parent_id': selectedService?.id,
        'title': title.text,
        'price': price.text,
        'status': isSwitch ? "1" : "0",
      };

      // Add thumbnail only if image is provided
      if (thumbFile != null) {
        formDataMap['thumbnail'] = await MultipartFile.fromFile(thumbFile!.path,
            filename: basename(thumbFile!.path));
      }
// If editing and using existing image
      else {
        // If no new image, convert URL to file and send that
        if (serviceAddOnsGet?.media?.first.originalUrl != null) {
          File existingImageFile =
              await _urlToFile(serviceAddOnsGet!.media!.first.originalUrl!);
          formDataMap['thumbnail'] = await MultipartFile.fromFile(
              existingImageFile.path,
              filename: basename(existingImageFile.path));
        }
      }

      final formData = FormData.fromMap(formDataMap);

      var lang = Provider.of<LanguageProvider>(context, listen: false);
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString(session.accessToken);

      var headerdata = headersToken(
        token,
        localLang: lang.selectedLocaleService,
        isLang: true,
      );

      log("message-=-=-=-=-=$headerdata");

      await dioo
          .post("${api.additionalService}/${serviceAddOnsGet?.id}",
              data: formData, options: Options(headers: headerdata))
          .then((value) async {
        if (value.statusCode == 200 || value.statusCode == 201) {
          isLoading = false;
          isEdit = false;
          thumbFile = null;
          // Fetch updated service add-ons
          // await getServiceAddOnsId(context, serviceId);
          Fluttertoast.showToast(msg: value.data);
          final pro = Provider.of<UserDataApiProvider>(context, listen: false);
          await pro.getServiceAddOnsList();
          route.pop(context);
          log("✅ Service add-on updated");
        } else {
          isLoading = false;
          log("❌ Failed to update service add-on: ${value.data}");
        }
      });

      // API call
      /*  final response = await apiServices.postApi(
          "${api.additionalService}/${serviceAddOnsGet?.id}", formData,
          isToken: true);

      if (response.isSuccess!) {
        isLoading = false;
        isEdit = false;
        thumbFile = null;
        // Fetch updated service add-ons
        // await getServiceAddOnsId(context, serviceId);
        Fluttertoast.showToast(msg: response.message);
        final pro = Provider.of<UserDataApiProvider>(context, listen: false);
        await pro.getServiceAddOnsList();
        route.pop(context);
        log("✅ Service add-on updated");
      } else {
        isLoading = false;
        log("❌ Failed to update service add-on: ${response.message}");
      } */
      notifyListeners();
    } catch (e) {
      isLoading = false;
      log("🚨 Error in updateServiceAddOn: $e");
      notifyListeners();
    }
  }

  onInit(context) {
    dynamic data = ModalRoute.of(context)!.settings.arguments ?? "";
    final value = Provider.of<SelectServiceProvider>(context, listen: false);

    final userData = Provider.of<UserDataApiProvider>(context, listen: false);
    userData.getAllServiceList();

    if (data != "") {
      if (data["isEdit"] != "") {
        isEdit = data["isEdit"] ?? false;
        Provider.of<PackageDetailProvider>(context, listen: false)
            .getServicePackageById(context, data["data"]);
      }
      if (data["data"] != null) {
        log("ARGSFDCGD :${data["data"]}");
      }
    }
  }

  Services? selectedService;

  void onSelectService(int? id, {Services? item}) {
    log("item $item");
    selectedService = item;
    notifyListeners();
  }

  clearData() {
    title.clear();
    price.clear();
    serviceAddOnsGet = null;
    isSwitch = true;
    selectedService = null;
    thumbFile = null;
    isEdit = false;
    notifyListeners();
  }

  //on image pick
  onImagePick(context, isThumbnail) {
    showLayout(context, onTap: (index) {
      if (index == 0) {
        getImage(context, ImageSource.gallery, isThumbnail);

        notifyListeners();
      } else {
        getImage(context, ImageSource.camera, isThumbnail);

        notifyListeners();
      }
    });
  }

  XFile? thumbFile;

  Future getImage(context, source, isThumbnail) async {
    final ImagePicker picker = ImagePicker();
    route.pop(context);
    thumbFile = (await picker.pickImage(source: source, imageQuality: 70))!;

    notifyListeners();
  }

  Future<void> createServiceAddOn(context) async {
    Provider.of<UserDataApiProvider>(context, listen: false)
        .getAllServiceList();
    isLoading = true;
    notifyListeners();

    try {
      // Prepare multipart form data
      final Map<String, dynamic> formDataMap = {
        'parent_id': selectedService?.id,
        'title': title.text,
        'price': price.text,
        'status': /* isSwitch ? */ "1" /* : "0" */
      };

      // Add thumbnail only if image is provided
      if (thumbFile != null) {
        formDataMap['thumbnail'] = await MultipartFile.fromFile(thumbFile!.path,
            filename: basename(thumbFile!.path));
      }

      final formData = FormData.fromMap(formDataMap);

      /* log("FormData JSON = ${jsonEncode(formDataMap.map((key, value) {
        if (value is MultipartFile) {
          return MapEntry(key, "MultipartFile: ${value.filename}");
        } else {
          return MapEntry(key, value);
        }
      }))}"); */
      // log("message-=-==-=-=--=${ formData}");

      // API call
      final response = await apiServices.postApi(
        api.additionalService,
        formData,
        isToken: true,
      );

      if (response.isSuccess!) {
        isLoading = false;
        // Fetch updated service add-ons
        // await getServiceAddOnsId(context, serviceId);
        // Fluttertoast.showToast(msg: response.message);
        showToast(context, response.message, type: "success");
        final pro = Provider.of<UserDataApiProvider>(context, listen: false);
        await pro.getServiceAddOnsList();
        route.pop(context);
        log("✅ Service add-on updated");
      } else {
        isLoading = false;
        log("❌ Failed to update service add-on: ${response.message}");
      }
      notifyListeners();
    } catch (e, s) {
      isLoading = false;
      log("🚨 Error in updateServiceAddOn: $e === $s");
      notifyListeners();
    }
  }
}

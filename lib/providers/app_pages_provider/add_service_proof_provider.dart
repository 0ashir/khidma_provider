import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;
import 'package:fixit_provider/config.dart';
import 'package:fixit_provider/utils/toast_utils.dart';

class AddServiceProofProvider with ChangeNotifier {
  TextEditingController titleCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  FocusNode titleFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();
  BookingModel? bookingModel;
  List proofList = [];
  ServiceProofs? serviceProofs;
  XFile? imageFile;

  //on page init data fetch
  onReady(context) {
    descriptionFocus.addListener(() {
      notifyListeners();
    });
    dynamic data = ModalRoute.of(context)!.settings.arguments;
    bookingModel = data['bookingModel'];
    if (data['data'] != null) {
      serviceProofs = data['data'];
      titleCtrl.text = serviceProofs!.title!;
      descriptionCtrl.text = serviceProofs!.description!;

      log("SER :${serviceProofs!.id}");
    } else {
      titleCtrl.text = "";
      descriptionCtrl.text = "";
      proofList = [];
      serviceProofs = null;
    }
    notifyListeners();
  }

  //on submit api call for add proof
  onSubmit(context) {
    debugPrint("sdjhasjkd ");
    if (formKey.currentState!.validate()) {
      if (descriptionCtrl.text.isNotEmpty &&
          titleCtrl.text.isNotEmpty &&
          (proofList.isNotEmpty ||
              (serviceProofs?.media != null &&
                  serviceProofs!.media!.isNotEmpty))) {
        debugPrint("ADDD PROOF");
        addServiceProof(context);
      } else {
        debugPrint("ajsdhajksd ");
        // showErrorToast(context, translations!.pleaseUploadServiceImages!);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(milliseconds: 500),
            content: Text("Add all fields and image",
                style: appCss.dmDenseMedium14
                    .textColor(appColor(context).appTheme.whiteColor)),
            backgroundColor: appColor(context).appTheme.red,
            behavior: SnackBarBehavior.floating));
      }
    }
  }

  //on image file path remove tap
  onImageRemove(index) {
    proofList.removeAt(index);
    notifyListeners();
  }

  //on image network remove tap
  removeNetworkImage(index) {
    serviceProofs!.media!.removeAt(index);
    notifyListeners();
  }

  //get image from source
  Future getImage(context, source) async {
    final ImagePicker picker = ImagePicker();
    route.pop(context);
    imageFile = (await picker.pickImage(source: source, imageQuality: 70))!;
    notifyListeners();
  }

  //after pick image set in value
  onImagePick(context) async {
    PermissionStatus cameraStatus = await Permission.camera.status;
    PermissionStatus galleryStatus = await Permission.photos.status;
    log("Camera Permission Status: ${cameraStatus.isGranted}");
    log("Gallery Permission Status: ${galleryStatus.isGranted}");

    /* if (cameraStatus.isPermanentlyDenied || galleryStatus.isPermanentlyDenied) {
      log("Permission Permanently Denied - Opening App Settings...");
      await openAppSettings(); // ✅ Open App Settings
      return;
    } */

    /* if (cameraStatus.isDenied || galleryStatus.isDenied) {
      log("Permission Denied - Requesting Again...");
      await openAppSettings();
      return;
    } */
    showLayout(context, onTap: (index) {
      if (index == 0) {
        getImage(context, ImageSource.gallery)
            .then((value) => proofList.add(imageFile));

        notifyListeners();
      } else {
        getImage(context, ImageSource.camera)
            .then((value) => proofList.add(imageFile));

        notifyListeners();
      }
    });
  }

//add service proof
  bool isAddServiceProof = false;

  addServiceProof(context) async {
    log("akshdajks");
    isAddServiceProof = true;
    showLoading(context);
    notifyListeners();

    log("bookingModel!.id ${bookingModel?.id}");
    log("serviceProofs!.id asd${serviceProofs?.id}");
    try {
      var body = {
        if (serviceProofs == null) "booking_id": bookingModel?.id,
        if (serviceProofs != null) "proof_id": serviceProofs?.id,
        "title": titleCtrl.text,
        "description": descriptionCtrl.text
      };
      dio.FormData formData = dio.FormData.fromMap(body);

      for (var file in proofList) {
        formData.files.addAll([
          MapEntry(
              "images_proofs[]",
              await MultipartFile.fromFile(file.path,
                  filename: file.path.split('/').last)),
        ]);
      }
      debugPrint("BODUasdadasd :$body");
      debugPrint("BODUfsdfsfgs :$proofList");
      debugPrint("BODU :${formData.fields}");
      await apiServices
          .postApi(
              serviceProofs != null
                  ? api.updateserviceProofs
                  : api.addserviceProofs,
              formData,
              isToken: true)
          .then((value) async {
        hideLoading(context);
        notifyListeners();
        log("SHHHH ");
        if (value.isSuccess!) {
          serviceProofs != null
              ? createBookingNotification(
                  NotificationType.updateServiceProofEvent)
              : createBookingNotification(
                  NotificationType.addServiceProofEvent);

          debugPrint("asdfasdfasf ${serviceProofs}");
          isAddServiceProof = false;
          route.pop(context);

          final userApi =
              Provider.of<CompletedBookingProvider>(context, listen: false);
          await userApi.getBookingDetailById(context, bookingModel!.id);

          notifyListeners();

          imageFile = null;

          appArray.serviceImageList = [];
          proofList = [];
          descriptionCtrl.text = "";
          titleCtrl.text = "";
        } else {
          log("akhsdjkasd");
          isAddServiceProof = false;
          final userApi =
              Provider.of<CompletedBookingProvider>(context, listen: false);
          await userApi.getBookingDetailById(context, bookingModel!.id);
          route.pop(context);
        }
      });
    } catch (e, s) {
      isAddServiceProof = false;
      hideLoading(context);
      notifyListeners();
      log("EEEE addServiceProof : $e----$s");
    }
  }

//on back clear and set value
  onBack(context, isBack) {
    proofList = [];
    notifyListeners();
    route.pop(context);
    // if (isBack) {
    //   route.pop(context);
    // }
  }
}

import 'dart:developer';

import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:fixit_provider/config.dart';
import 'package:flutter/cupertino.dart';

class IdVerificationProvider extends ChangeNotifier {
  XFile? imageFile;
  GlobalKey<FormState> idKey = GlobalKey<FormState>();
  dynamic providerDocumentModel;
  TextEditingController numberText = TextEditingController();
  TextEditingController noteText = TextEditingController();

  final FocusNode noteFocus = FocusNode();
  final FocusNode numberFocus = FocusNode();

  // GET IMAGE FROM GALLERY
  Future getImage(context, source, doc) async {
    final ImagePicker picker = ImagePicker();
    route.pop(context);
    imageFile = (await picker.pickImage(source: source, imageQuality: 70))!;

    providerDocumentModel = ProviderDocumentModel(
        document: doc.title.toString(),
        documentId: doc.id.toString(),
        isVerified: false,
        status: "pending",
        media: [Media(originalUrl: imageFile!.path.toString())]);

    providerDocumentList.add(providerDocumentModel!);

    notUpdateDocumentList.removeWhere((element) => element.id == doc.id);
    notifyListeners();

    getIdentityNumber(context, doc);
    //uploadDocumentApi(context);
  }

  //image fetch as par image source
  onImagePick(context, doc) async {
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
        getImage(context, ImageSource.gallery, doc);
      } else {
        getImage(context, ImageSource.camera, doc);
      }
      notifyListeners();
    });
  }

  //add identity number with popup
  getIdentityNumber(context, DocumentModel doc) {
    showDialog(
        context: context,
        builder: (context1) => AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: Insets.i20),
            contentPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: const SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius.all(SmoothRadius(
                    cornerRadius: AppRadius.r10, cornerSmoothing: 1))),
            backgroundColor: appColor(context).appTheme.whiteBg,
            content: Stack(alignment: Alignment.topRight, children: [
              Column(mainAxisSize: MainAxisSize.min, children: [
                Form(
                  key: idKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(language(context, translations!.reason),
                            style: appCss.dmDenseMedium15.textColor(
                                appColor(context).appTheme.darkText)),
                        const VSpace(Sizes.s8),
                        TextFieldCommon(
                            focusNode: numberFocus,
                            validator: (value) => Validation().commonValidation(
                                context, translations!.enterIdentityNo),
                            fillColor: appColor(context).appTheme.fieldCardBg,
                            controller: numberText,
                            hintText: translations!.identityNo!,
                            prefixIcon: eSvgAssets.identity),
                        const VSpace(Sizes.s20),
                        Text(language(context, translations!.description),
                            style: appCss.dmDenseMedium15.textColor(
                                appColor(context).appTheme.darkText)),
                        const VSpace(Sizes.s8),
                        TextFieldCommon(
                            focusNode: noteFocus,
                            validator: (value) => Validation().commonValidation(
                                context, translations!.enterMessage),
                            fillColor: appColor(context).appTheme.fieldCardBg,
                            controller: noteText,
                            hintText: translations!.writeANote!,
                            maxLines: 3,
                            minLines: 3,
                            isNumber: true)
                      ]),
                ),
                // Sub text

                const VSpace(Sizes.s20),
                ButtonCommon(
                    onTap: () {
                      if (idKey.currentState!.validate()) {
                        providerDocumentModel!.identityNo = numberText.text;
                        providerDocumentModel!.notes = noteText.text;
                        notifyListeners();
                        route.pop(context);
                        uploadDocumentApi(context);
                        Provider.of<UserDataApiProvider>(context,
                            listen: false);
                        numberText.text = '';
                        noteText.text = '';
                        // userApi.getDocumentDetails();
                      }
                    },
                    title: language(context, translations!.uploadImageProof))
              ]).padding(
                  horizontal: Insets.i20, top: Insets.i60, bottom: Insets.i20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                // Title
                Expanded(
                  child: Text(language(context, translations!.idVerification),
                      overflow: TextOverflow.ellipsis,
                      style: appCss.dmDenseMedium18
                          .textColor(appColor(context).appTheme.darkText)),
                ),
                Icon(CupertinoIcons.multiply,
                        size: Sizes.s20,
                        color: appColor(context).appTheme.darkText)
                    .inkWell(onTap: () {
                  log(" notifyListeners();");
                  numberText.text = '';
                  noteText.text = '';
                  notifyListeners();
                  route.pop(context);
                })
              ]).paddingAll(Insets.i20)
            ]))).then((e) {
      if (numberText.text.isEmpty) {
        providerDocumentList.removeWhere(
          (element) => element.documentId.toString() == doc.id.toString(),
        );

        notifyListeners();
      }
    });
  }

//upload document api
  uploadDocumentApi(context) async {
    log("message function call");
    try {
      // showLoading(context);
      notifyListeners();
      var body = {
        'document_id': providerDocumentModel!.documentId,
        'identity_no': numberText.text,
        'notes': noteText.text,
      };
      log("message $body");
      dio.FormData formData = dio.FormData.fromMap(body);

      if (imageFile != null) {
        log("message image file ${imageFile!.path}");
        formData.files.addAll([
          MapEntry(
              "images[]",
              await MultipartFile.fromFile(imageFile!.path,
                  filename: imageFile!.path.split('/').last)),
        ]);
      }

      await apiServices
          .postApi(api.uploadProviderDocument, formData, isToken: true)
          .then((value) async {
        // route.pop(context);
        hideLoading(context);
        notifyListeners();
        log("message upload document ${value.message}");
        if (value.isSuccess!) {
          log("message upload document $value");
          final userApi =
              Provider.of<UserDataApiProvider>(context, listen: false);
          final commonApi =
              Provider.of<CommonApiProvider>(context, listen: false);
          await commonApi.selfApi(context);
          await userApi.getDocumentDetails();
          // snackBarMessengers(context,
          //     message: value.message,
          //     color: appColor(context).appTheme.primary);

          notifyListeners();

          imageFile = null;
          appArray.serviceImageList = [];
        } else {
          hideLoading(context);
          notifyListeners();
          final userApi =
              Provider.of<UserDataApiProvider>(context, listen: false);
          await userApi.getDocumentDetails();
        }
      });
    } catch (e) {
      hideLoading(context);
      notifyListeners();
      log("EEEE addServiceman : $e");
    }
  }

  oninit(context) {
    final commonApi = Provider.of<CommonApiProvider>(context, listen: false);
    commonApi.getDocument();
    final userApi = Provider.of<UserDataApiProvider>(context, listen: false);
    userApi.getDocumentDetails();
    notifyListeners();
  }
}

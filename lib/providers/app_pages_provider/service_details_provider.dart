import 'dart:developer';

import 'package:fixit_provider/config.dart';
import 'package:fixit_provider/model/service_details_model.dart';

import '../../model/dash_board_model.dart' show PopularService;

class ServiceDetailsProvider with ChangeNotifier {
  int selectedIndex = 0, selected = -1;
  String? selectedImage;
  String? id;
  dynamic services;
  dynamic services1;
  List<ServiceFaqModel> serviceFaq = [];
  bool isImage = false;
  bool isHomeImage = false;
  List<ZoneModel> zoneList = [];
  List locationList = [];
  double widget1Opacity = 1;
  bool isLoading = false;

  //image index select and set in key
  onImageChange(index, value) {
    isImage = true;
    selectedIndex = index;
    selectedImage = value;
    log("selectedImage:$selectedImage");
    isVideo = false;
    notifyListeners();
  }

  onHomeImageChange(index, value) {
    isHomeImage = true;
    selectedIndex = index;
    selectedImage = value;
    log("selectedImage:$selectedImage");

    notifyListeners();
  }

  onExpansionChange(newState, index) {
    log("dghfdkg:$newState");
    if (newState) {
      const Duration(seconds: 20000);
      selected = index;
      notifyListeners();
    } else {
      selected = -1;
      notifyListeners();
    }
  }

  // on page init data fetch
  onReady(context) async {
    dynamic data = ModalRoute.of(context)!.settings.arguments ?? "";
    log("SERVICE::: 123${data}");
    notifyListeners();
    if (data != null) {
      if (data is Map && data.containsKey("detail")) {
        id = data["detail"].toString();
        log("SERVICE::: 123${id}");
        getServiceId(context, ids: id);
      } else {
        services = data;
        log("SERVICE:::${services.id}");
        id = services!.id.toString();
      }

      getServiceId(context);
      getServiceFaqId(context, id);
    } else {
      hideLoading(context);
    }

    widget1Opacity = 1;
    notifyListeners();
  }

  onHomeReady(context) async {
    dynamic data = ModalRoute.of(context)!.settings.arguments ?? "";
    log("DATA::${data.id}");
    if (data != null) {
      services1 = data;
      id = services1!.id.toString();
      await Future.wait([
        Future(() {
          getHomeServiceId(context);
        }),
      ]);
    } else {
      hideLoading(context);
    }
    widget1Opacity = 1;
    notifyListeners();
  }

  onRefresh(context) async {
    showLoading(context);
    notifyListeners();
    await getServiceId(context);
    await getServiceFaqId(context, id);
    hideLoading(context);
    notifyListeners();
  }

  onBack(context, isBack) {
    services = null;
    serviceLoader = false;
    // services1 = null;
    isImage = false;
    isHomeImage = false;
    serviceFaq = [];
    selectedIndex = 0;
    selectedImage = null;
    id = "";
    widget1Opacity = 0.0;
    notifyListeners();
    // isImage = true;
    isVideo = false;
    if (isBack) {
      route.pop(context);
    }
  }

  /* getServiceFaqId(context, serviceId) async {
    try {
      await apiServices
          .getApi("${api.serviceFaq}?service_id=$serviceId", [],
              isData: true, isMessage: false)
          .then((value) {
        if (value.isSuccess!) {
          // Clear existing data to avoid duplication
          serviceFaq.clear();

          // Check if value.data is a List
          if (value.data is List) {
            serviceFaq.addAll(
                value.data.map((e) => ServiceFaqModel.fromJson(e)).toList());
          } else {
            log("Unexpected data format: ${value.data}");
          }

          log("serviceFaq Length: ${serviceFaq.length}");
        } else {
          notifyListeners();
        }
        /*   if (value.isSuccess!) {
          serviceFaq.addAll(ServiceFaqModel.fromJson(value.data));
          /* for (var d in value.data) {
            if (!serviceFaq.contains(ServiceFaqModel.fromJson(d))) {
              serviceFaq.add(ServiceFaqModel.fromJson(d));
            }
          } */
          log("serviceFaq :${serviceFaq.length}");
          notifyListeners();
        } else {
          notifyListeners();
        } */
      });
    } catch (e) {
      log("ERRROEEE getServiceFaqId : $e");
      notifyListeners();
    }
  } */

  getServiceFaqId(context, serviceId) async {
    try {
      await apiServices
          .getApi(
        "${api.serviceFaq}?service_id=$serviceId",
        [],
        isData: true,
        isMessage: false,
      )
          .then((value) {
        if (value.isSuccess!) {
          // Clear existing data to prevent duplicates
          serviceFaq.clear();
          // Ensure value.data is a List before mapping
          if (value.data is List) {
            serviceFaq.addAll(
              (value.data as List)
                  .map((e) => ServiceFaqModel.fromJson(e))
                  .toList(),
            );
          } else {
            log("Unexpected data format: ${value.data}");
          }

          //  log("serviceFaq Length: ${serviceFaq.length}");
        }
        notifyListeners();
      });
    } catch (e) {
      log("ERROR getServiceFaqId: $e");
      notifyListeners();
    }
  }

  //get service by id
  bool serviceLoader = false;
  getServiceId(context, {String? ids}) async {
    log("IDD::${"${api.providerServices}?service_id=$id"}");
    serviceLoader = true;
    try {
      await apiServices
          .getApi("${api.providerServices}?service_id=$id", [], isToken: true)
          .then((value) {
        if (value.isSuccess!) {
          widget1Opacity = 1;
          serviceLoader = false;
          services = ServiceDetailsModel.fromJson(value.data);
          log("widget1Opacity::${services}");
          log("services!.media::${services!.media}");
        }

        if (services!.media != null && services!.media!.isNotEmpty) {
          selectedImage = services!.media![0].originalUrl!;
          log("services!.media::${services!.media}");
        }
        serviceLoader = false;
        notifyListeners();
      });
    } catch (e, s) {
      serviceLoader = false;
      log("ERRROEEE getServiceId : $e----$s");
      hideLoading(context);
      notifyListeners();
    }
  }

  // home service id
  getHomeServiceId(context) async {
    log("DDDD :${services1!.id}");
    try {
      await apiServices
          .getApi("${api.providerServices}?service_id=${services1!.id}", [],
              isToken: true)
          .then((value) {
        // if (value.isSuccess!) {
        services1 = PopularService.fromJson(value.data);
        // log("services:::$services1");
        // }
        if (services1!.media != null && services1!.media!.isNotEmpty) {
          selectedImage = services1!.media![0].originalUrl!;
          log("services!.media::${services1!.media![0].originalUrl}");
        }
        notifyListeners();
      });
    } catch (e) {
      log("ERRROEEE getServiceId : $e");
      hideLoading(context);
      notifyListeners();
    }
  }

  // delete service confirmation
  onServiceDelete(context, sync) {
    final value = Provider.of<DeleteDialogProvider>(context, listen: false);
    value.onDeleteDialog(
      sync,
      context,
      eImageAssets.service,
      translations!.deleteService,
      translations!.areYouSureDeleteService,
      () {
        route.pop(context);
        deleteService(context);

        notifyListeners();
      },
    );
    value.notifyListeners();
  }

  //delete Service
  deleteService(context, {isBack = false}) async {
    showLoading(context);

    try {
      await apiServices.deleteApi("${api.service}/$id", {}, isToken: true).then(
        (value) {
          hideLoading(context);

          notifyListeners();
          if (value.isSuccess!) {
            final common = Provider.of<UserDataApiProvider>(
              context,
              listen: false,
            );
            common.getPopularServiceList();
            common.getAllServiceList();

            Provider.of<ServiceListProvider>(context, listen: false)
                .getService(context, isList: true);

            final delete = Provider.of<DeleteDialogProvider>(
              context,
              listen: false,
            );

            delete.onResetPass(
              context,
              language(context, translations!.hurrayServiceDelete),
              language(context, translations!.okay),
              () {
                route.pop(context);
                route.pop(context);
              },
            );
            notifyListeners();
          } else {
            snackBarMessengers(
              context,
              color: appColor(context).appTheme.red,
              message: value.message,
            );
          }
        },
      );
    } catch (e) {
      hideLoading(context);
      notifyListeners();
      log("EEEE deleteService : $e");
    }
  }

  // add address in service availability
  addAddressInService(context) {
    route.pushNamed(context, routeName.locationList, arg: services!.id).then((
      e,
    ) async {
      getServiceId(context);
      final userApi = Provider.of<UserDataApiProvider>(context, listen: false);
      userApi.getAddressList(context);
    });
  }

  // delete location confirmation
  onTapDetailLocationDelete(id, context, sync, index) {
    final value = Provider.of<DeleteDialogProvider>(context, listen: false);

    value.onDeleteDialog(
      sync,
      context,
      eImageAssets.location,
      translations!.delete,
      translations!.areYiuSureDeleteLocation,
      () {
        route.pop(context);
        services!.serviceAvailabilities!.removeAt(index);
        deleteAvailabilityService(context, id);
        notifyListeners();
      },
    );
    value.notifyListeners();

    notifyListeners();
  }

  //delete availability service
  deleteAvailabilityService(context, serviceAvailabilityId) async {
    showLoading(context);

    try {
      await apiServices
          .deleteApi(
        "${api.deleteServiceAddress}/$serviceAvailabilityId",
        {},
        isToken: true,
      )
          .then((value) {
        hideLoading(context);

        notifyListeners();
        if (value.isSuccess!) {
          getServiceId(context);
          notifyListeners();
        } else {
          snackBarMessengers(
            context,
            color: appColor(context).appTheme.red,
            message: value.message,
          );
        }
      });
    } catch (e) {
      hideLoading(context);
      notifyListeners();
      log("EEEE deleteServiceman : $e");
    }
  }

  bool isVideo = false;
  onVideo() {
    isImage = false;

    log("selectedImage:$selectedImage");
    isVideo = true;
    notifyListeners();
  }

  /*  YoutubePlayerController? videoControllers = YoutubePlayerController(
    initialVideoId: YoutubePlayer.convertUrlToId(
            /* services!.video.toString() ?? */ "https://www.youtube.com/watch?v=2g8v0j1q4aE") ??
        '',
    flags: const YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
    ),
  ); */

  /*  void initializeVideoControllers(String videoUrls) {
    /* videoControllers = videoUrls.map((url) {
      return */
    YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(videoUrls) ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    /* }).toList(); */
    notifyListeners();
  } */
  /* YoutubePlayerController? videoControllers;

  void initializeVideoControllers(String videoUrls) {
    /* videoControllers = videoUrls.map((url) {
      return */
    YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(videoUrls) ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    /* }).toList(); */
    notifyListeners();
  }

  void disposeControllers() {
    videoControllers?.dispose();
    /*  for (var controller in videoControllers) {
      controller.dispose();
    } */
  } */
}

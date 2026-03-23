import 'dart:developer';

import 'package:fixit_provider/utils/toast_utils.dart';
import 'package:fixit_provider/model/dash_board_model.dart';
import 'package:fixit_provider/screens/app_pages_screens/custom_job_request/job_request_details/layouts/bid_amount.dart';

import '../../../config.dart';

class JobRequestDetailsProvider with ChangeNotifier {
  int selectedIndex = 0, selected = -1;
  bool isBottom = true;
  int? serviceId;
  ScrollController scrollController = ScrollController();
  double widget1Opacity = 0.0;
  GlobalKey<FormState> withdrawKey = GlobalKey<FormState>();
  FocusNode amountFocus = FocusNode();
  JobRequestModel? service;
  LatestServiceRequest? service1;
  int? id;
  List<ServiceFaqModel> serviceFaq = [];
  TextEditingController amountCtrl = TextEditingController();

  onImageChange(index) {
    selectedIndex = index;
    notifyListeners();
  }

  onReady(context) async {
    scrollController.addListener(listen);

    notifyListeners();
    /*  dynamic data = ModalRoute.of(context)!.settings.arguments;

    service = JobRequestModel.fromJson(data["service"]);
    log("service :${data}");
    if (data['serviceId'] != null) {
      getServiceById(context, data['serviceId']);
    } else {
      service = data['services'];
      notifyListeners();
      getServiceById(context, service!.id);
    } */

    Future.delayed(const Duration(milliseconds: 500), () {
      widget1Opacity = 1;
      notifyListeners();
    });
    notifyListeners();
  }

  onHomeReady(context) {
    final data = ModalRoute.of(context)?.settings.arguments;

    log("Route data::: $data");

    if (data != null && data is Map && data.containsKey('serviceId')) {
      id = data['serviceId'];
      log("Received serviceId: $id");

      getServiceByHomeId(context, id);
      Future.delayed(const Duration(milliseconds: 500), () {
        widget1Opacity = 1;
        notifyListeners();
      });
    } else {
      log("serviceId not found in arguments!");
    }
  }

  onRefresh(context) async {
    showLoading(context);
    notifyListeners();
    await getServiceById(context, service!.id);

    hideLoading(context);
    notifyListeners();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
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

  void listen() {
    if (scrollController.position.pixels >= 200) {
      hide();
      notifyListeners();
    } else {
      show();
      notifyListeners();
    }
  }

  void show() {
    if (!isBottom) {
      isBottom = true;
      notifyListeners();
    }
    notifyListeners();
  }

  void hide() {
    if (isBottom) {
      isBottom = false;
      notifyListeners();
    }
    notifyListeners();
  }

  onBack(context, isBack) {
    service = null;
    serviceFaq = [];
    selectedIndex = 0;
    serviceId = 0;
    widget1Opacity = 0.0;
    notifyListeners();
    log("djhfkf :$service");
    if (isBack) {
      route.pop(context);
    }
  }

  getServiceByHomeId(context, serviceId) async {
    log("Calling API with ID: $serviceId");
    try {
      await apiServices
          .getApi("${api.serviceRequest}/$serviceId", [],
              isToken: true, isData: true)
          .then((value) {
        log("API response: ${value.data}");

        if (value.isSuccess) {
          log("API response: ${value.isSuccess}");
          service1 = LatestServiceRequest.fromJson(value.data["data"]);
          log("Parsed service1: ${service1!.title}");
          notifyListeners();
        } else {
          log("API failed or no data: ${value.message}");
        }
      });
    } catch (e) {
      log("API error: $e");
    }
  }

  bool isRequestLoading = false;

  getServiceById(context, serviceId) async {
    log("api.serviceRequest::$serviceId");
    isRequestLoading = true;
    notifyListeners();
    try {
      await apiServices
          .getApi("${api.serviceRequest}/$serviceId", [],
              isToken: true, isData: true)
          .then((value) {
        if (value.isSuccess!) {
          isRequestLoading = false;
          service = null;
          log("value ;${value.data}");
          service = JobRequestModel.fromJson(value.data['data']);
          log("value ;${service?.title}");
          notifyListeners();
        } else {
          isRequestLoading = false;
          notifyListeners();
        }
      });
    } catch (e, s) {
      isRequestLoading = false;
      log("ERRROEEE getServiceById : $e=-=-=-=-=-=-$s");
      notifyListeners();
    }
  }

  //on with bottom sheet open
  bidClick(context, {int? serviceId}) {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      context: context,
      builder: (context1) {
        return BidAmountSheet(serviceId: serviceId);
      },
    ).then((value) {
      log("SSSS");
    });
  }

  bool isBidLoading = false;

  bidSend(context, id) async {
    try {
      isBidLoading = true;
      showLoading(context);

      notifyListeners();
      log("message====${amountCtrl.text}===${service1?.id}");
      var body = {"amount": amountCtrl.text, "service_request_id": id};
      log("bidSend BODY : $body");
      await apiServices
          .postApi(api.bid, body, isToken: true)
          .then((value) async {
        createBookingNotification(NotificationType.createBid);
        log("VALUE :${value.message} || ${value.isSuccess}");
        hideLoading(context);

        notifyListeners();
        if (value.isSuccess!) {
          route.pop(context);
          isBidLoading = false;
          await getServiceById(context, id);
          await getServiceByHomeId(context, id);
          showSuccessToast(context, value.message);
          final commonApi =
              Provider.of<CommonApiProvider>(context, listen: false);
          await commonApi.getDashBoardApi(context);
          amountCtrl.text = '';
        } else {
          isBidLoading = false;
          route.pop(context);
          route.pop(context);
          amountCtrl.text = '';
          await getServiceById(context, id);
          await getServiceByHomeId(context, id);
          showErrorToast(context, value.message);
        }
      });
    } catch (e, s) {
      isBidLoading = false;

      notifyListeners();
      log("EEEE assignServiceman Job Request: $e====> $s");
    }
  }

  acceptProvider(context, ProviderModel provider) {
    /* showDialog(
      context: context,
      builder: (BuildContext context1) {
        return AcceptProviderConfirmation(provider: provider);
      });*/
  }
}

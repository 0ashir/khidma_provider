import 'dart:developer';
import 'package:webview_flutter/webview_flutter.dart';
import '../../config.dart';
import '../../services/environment.dart';

class CheckoutWebViewProvider with ChangeNotifier {
  bool isPayment = false, isLoading = true;
  dynamic data;
  WebViewController? controller;

  //on page initialise data fetch
  onReady(context) async {
    dynamic url = ModalRoute.of(context)!.settings.arguments ?? "";
    data = url;
    log("URL : $data");
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(data["url"]))
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (NavigationRequest request) {
          return NavigationDecision.navigate;
        },
        onPageFinished: (url) {
          log("URL 1: ${url.contains(paymentUrl)}");
          if (url.contains(paymentUrl)) {
            handleUrlChanged(context, url);
          }
        },
        onUrlChange: (change) {
          isLoading = false;
          log("change.url! : ${change}");
          if (change.url!.contains("/success")) {
            isPayment = true;
          }
          notifyListeners();
        },
      ));
    notifyListeners();
  }

  // on order success navigate to order success page
  successNavigation(context, {number, data}) async {
    route.pop(context,
        arg: {"isVerify": data == null ? false : true, "data": data});
  }

  void handleUrlChanged(context, String url) {
    getPaymentTransactionData(context, url);
    if (url.contains('/member-login/')) {
      log("order-login/");
      route.pop(context);
    }
  }

  //get payment transaction data
  getPaymentTransactionData(context, api) async {
    try {
      await apiServices.getApi(api, [], isData: true).then((value) {
        if (value.isSuccess!) {
          if (value.data['payment_status'] == "COMPLETED") {
            successNavigation(context, data: value.data);
          } else {
            successNavigation(context);
          }
        }
      });
    } catch (e) {
      log("ERRROEEE getPaymentTransactionData : $e");
      notifyListeners();
    }
  }
}

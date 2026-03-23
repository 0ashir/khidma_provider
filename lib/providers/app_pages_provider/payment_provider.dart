// ignore_for_file: unused_local_variable

import 'dart:developer';
import 'package:collection/collection.dart';

import '../../config.dart';

class PaymentProvider with ChangeNotifier {
  int? selectIndex;
  ScrollController scrollController = ScrollController();
  List<PaymentMethods> paymentList = [];
  SharedPreferences? preferences;
  dynamic method;
  double wallet = 0.0;
  bool isBottom = true, isTrial = false;

//select payment method option
  onSelectPaymentMethod(index, title) {
    selectIndex = index;
    method = title;
    notifyListeners();
  }

  onReady(context) {
    dynamic arg = ModalRoute.of(context)!.settings.arguments ?? false;
    isTrial = arg;
    paymentList =
        paymentMethods.where((element) => element.slug != "cash").toList();
    scrollController.addListener(listen);
    notifyListeners();
  }

  void listen() {
    if (scrollController.position.pixels >= 100) {
      hide();

      notifyListeners();
    } else {
      show();

      notifyListeners();
    }

    notifyListeners();
  }

  void show() {
    if (!isBottom) {
      isBottom = true;
      notifyListeners();
    }
  }

  void hide() {
    if (isBottom) {
      isBottom = false;
      notifyListeners();
    }
  }

  //subscription plan
  subscriptionPlan(context) async {
    var plan = Provider.of<PlanDetailsProvider>(context, listen: false);
    final product = plan.products.firstWhereOrNull((p) => p.id == p.id);

    final selectedProduct = plan.products.firstWhereOrNull((product) =>
        plan.isMonthly
            ? product.id.contains('month') &&
                product.id.toLowerCase().contains(
                    "regular_month_sub" /*userSubscribe!.id.toLowerCase()*/)
            : product.id.contains('year') &&
                product.id.toLowerCase().contains(
                    "regular_year_sub" /*userSubscribe!.id.toLowerCase()*/));
    log("selectedProduct::$selectedProduct");
    // final PurchaseParam purchaseParam = PurchaseParam(productDetails: product!);
    // await plan.iap.buyNonConsumable(purchaseParam: purchaseParam);
    // if (purchaseDetails.status == PurchaseStatus.purchased) { // your code goes here .. }
    // }
    try {
      showLoading(context);
      notifyListeners();
      var body = {
        "plan_id": "regular_month_sub" /*userSubscribe!.id*/,
        "payment_method": method,
        "type": "subscription",
        "included_free_trial": isTrial,
        "currency_code": currency(context).currency?.code,
        "product_id": "regular_month_sub", // 🔑 Add this
      };
      log("BODY :$body");

      await apiServices
          .postApi(api.subscriptionPlanCreate, body,
              isToken: true, isData: true)
          .then((value) {
        hideLoading(context);

        notifyListeners();

        if (value.isSuccess!) {
          route
              .pushNamed(context, routeName.checkoutWebView, arg: value.data)
              .then((e) async {
            if (e != null) {
              if (e['isVerify'] == true) {
                getVerifyPayment(value.data['item_id'], context);
                route.pop(context);
                route.pop(context);
                final commonApi =
                    Provider.of<CommonApiProvider>(context, listen: false);
                await commonApi.selfApi(context);
              }
            }
          });
        } else {
          route.pop(context);
          route.pop(context);
          snackBarMessengers(context,
              color: appColor(context).appTheme.red, message: value.message);
        }
      });
    } catch (e, s) {
      hideLoading(context);
      notifyListeners();
      log("EEEE subscriptionPlan : $e=====>$s");
    }
  }

  //verify payment
  getVerifyPayment(data, context) async {
    try {
      await apiServices
          .getApi("${api.verifyPayment}?item_id=$data&type=subscription", {},
              isToken: true, isData: true)
          .then((value) {
        if (value.isSuccess!) {
          if (value.data["payment_status"].toString().toLowerCase() ==
              "pending") {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: Duration(milliseconds: 500),
              content:
                  Text(language(context, translations!.yourPaymentIsDeclined)),
              backgroundColor: appColor(context).appTheme.red,
            ));
          } else {
            showDialog(
                context: context,
                builder: (context) => AlertDialogCommon(
                    title: translations!.updateSuccessfully,
                    height: Sizes.s140,
                    image: eGifAssets.successGif,
                    subtext:
                        language(context, translations!.successfullyComplete),
                    bText1: language(context, translations!.okay),
                    b1OnTap: () => route.pop(context)));
            /* ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(language(context, translations!.successfullyComplete)),
              backgroundColor: appColor(context).appTheme.green,
            ));*/
          }
        }
      });
    } catch (e) {
      notifyListeners();
    }
  }
}

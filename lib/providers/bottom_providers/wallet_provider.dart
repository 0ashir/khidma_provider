import 'dart:developer';

import 'package:fixit_provider/config.dart';

class WalletProvider with ChangeNotifier {
  List<PaymentMethods> paymentList = [];
  String? wallet;
  double balance = 0.0;
  double servicemanBalance = 0.0;
  TextEditingController withDrawAmountCtrl = TextEditingController();
  TextEditingController messageCtrl = TextEditingController();
  ProviderWalletModel? providerWalletModel;
  ServicemanWalletModel? servicemanWalletModel;
  GlobalKey<FormState> withdrawKey = GlobalKey<FormState>();
  TextEditingController amountCtrl = TextEditingController();
  FocusNode amountFocus = FocusNode();
  FocusNode descFocus = FocusNode();
  bool isLoadingForWallet = false;
  bool showValidationError = false;

  //payment method select
  onTapGateway(val) {
    wallet = val;
    notifyListeners();
  }

  // on page init data fetch
  onReady(context) async {
    notifyListeners();
    final common = Provider.of<CommonApiProvider>(context, listen: false);
    await common.getPaymentMethodList();
    log("paymentMethods :$paymentMethods");
    if (paymentMethods.isNotEmpty) {
      paymentList = paymentMethods;
    } else {
      // final common = Provider.of<CommonApiProvider>(context, listen: false);
      // await common.getPaymentMethodList();
    }
    paymentList.removeWhere((element) => element.slug == "cash");

    wallet = paymentList[0].slug;
    log("PAYE :$paymentList");
    notifyListeners();
  }

  //on add money wallet bottom sheet open
  void onTapAdd(BuildContext context) {
    final rootContext = context;

    showModalBottomSheet(
      context: rootContext,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (modalContext) => AddMoneyLayout(originalContext: rootContext),
    ).then((value) async {
      amountCtrl.text = "";
      wallet = paymentList[0].slug;
      notifyListeners();
      final commonApi =
          Provider.of<CommonApiProvider>(rootContext, listen: false);
      await commonApi.selfApi(rootContext);
    });
  }

  //get wallet list
  getWalletList(context) async {
    final userApi = Provider.of<UserDataApiProvider>(context, listen: false);
    userApi.getWalletList(context);
    userApi.getServicemanWalletList(context);
  }

  //wallet withdraw request
  bool isWithDrow = false;
  withdrawRequest(context) async {
    isWithDrow = true;
    showValidationError = messageCtrl.text.isEmpty ? true : false;
    notifyListeners();
    FocusScope.of(context).requestFocus(FocusNode());
    final commonApi = Provider.of<CommonApiProvider>(context, listen: false);
    commonApi.getPaymentMethodList();
    if (withdrawKey.currentState!.validate() && !showValidationError) {
      notifyListeners();
      try {
        var body = {
          "amount": withDrawAmountCtrl.text,
          "message": messageCtrl.text,
          "payment_type": "bank"
        };

        notifyListeners();
        log("checkoutBody: $body");
        await apiServices
            .postApi(
                isServiceman
                    ? api.servicemanWalletWithdrawRequest
                    : api.walletWithdrawRequest,
                body,
                isData: true,
                isToken: true)
            .then((value) async {
          hideLoading(context);
          notifyListeners();
          route.pop(context);
          if (value.isSuccess!) {
            createBookingNotification(NotificationType.createWithdrawRequest);
            notifyListeners();
            log("MESs :${value.data}");
            await getWalletList(context);
            final commonApi =
                Provider.of<CommonApiProvider>(context, listen: false);
            await commonApi.selfApi(context);
            isWithDrow = false;
            snackBarMessengers(context,
                message: value.message,
                color: appColor(context).appTheme.primary);

            notifyListeners();
          } else {
            isWithDrow = false;
            notifyListeners();
            log("MES :${value.message}");
            snackBarMessengers(context,
                message: value.message, color: appColor(context).appTheme.red);
          }
        });
      } catch (e) {
        isWithDrow = false;
        // showValidationError = false;
        notifyListeners();
        hideLoading(context);
        snackBarMessengers(context,
            message: e.toString(), color: appColor(context).appTheme.red);
        notifyListeners();
      }
    } else {
      isWithDrow = false;
      notifyListeners();
    }
  }

  cancelTap(context) {
    amountCtrl.text = "";
    wallet = paymentList[0].slug;
    route.pop(context);
  }

  //add to wallet
  addToWallet(context) async {
    /*  log("ADD MONEY ERROR : "); */
    FocusScope.of(context).requestFocus(FocusNode());

    if (int.parse(amountCtrl.text) >
        int.parse(appSettingModel!.providerCommissions!.minWithdrawAmount!)) {
      try {
        var body = {
          "amount": amountCtrl.text,
          "payment_method": wallet,
          "type": "wallet",
          "currency_code": "USD"
        };

        log("message-=-=-=-=-=-=$isServiceman -=-==- isFreelancer $isFreelancer");
        log("body----------> $body");
        log("ADD MONEY ERROR :${isFreelancer == true ? api.addMoneyToWalletProvider : isServiceman == true ? api.addMoneyToWallet : api.addMoneyToWalletProvider}");
        await apiServices
            .postApi(
                isFreelancer == true
                    ? api.addMoneyToWalletProvider
                    : isServiceman == true
                        ? api.addMoneyToWallet
                        : api.addMoneyToWalletProvider,
                body,
                isData: true,
                isToken: true)
            .then((value) async {
          hideLoading(context);
          notifyListeners();
          log("ADD MONEY ERROR : ${value.isSuccess}");
          if (value.isSuccess!) {
            route
                .pushNamed(context, routeName.checkoutWebView, arg: value.data)
                .then((e) async {
              if (e != null && e['isVerify'] == true) {
                await getWalletList(context);
                await getVerifyPayment(value.data['item_id'], context);
                route.pop(context);
              } else {
                route.pop(context);
              }
            });
          } else {
            log("ADD MONEY ERROR : ${value.message}");
            hideLoading(context);
            // snackBarMessengers(context, message: value.message);
          }
        });
      } catch (e, s) {
        log("ADD MONEY ERROR : 12");
        log("Exception: $e\n$s");
        hideLoading(context);
        // snackBarMessengers(context, message: "An error occurred.");
      }
    } else {
      snackBarMessengers(
        context,
        message: appSettingModel?.general?.defaultCurrency?.symbolPosition ==
                "left"
            ? "More than${appSettingModel!.providerCommissions!.minWithdrawAmount} amount can be withdrawn"
            : "More than ${appSettingModel!.providerCommissions!.minWithdrawAmount}${getSymbol(context)} amount can be withdrawn",
      );
    }
  }

  /*addToWallet() async {
    final body = {
      "amount": amountCtrl.text,
      "payment_method": wallet,
      "type": "wallet",
      "currency_code": "USD",
    };
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      final response = await Dio().post(
        api.addMoneyToWallet,
        data: body,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${pref.getString(session.accessToken)}',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );
      log("ADD MONEY RESPONSE: ${response.data}");
      if (response.statusCode == 200 && response.data['isSuccess']) {
        log("ADD MONEY SUCCESS: ${response.data}");
        return response.data;
      } else {
        log("ADD MONEY ERROR: ${response.data['message']}");
        throw Exception(response.data['message']);
      }
    } catch (e) {
      print('ADD MONEY ERROR: $e');
      rethrow;
    }
  }*/

  //verify payment
  getVerifyPayment(data, context) async {
    try {
      await apiServices
          .getApi("${api.verifyPayment}?item_id=$data&type=wallet", {},
              isToken: true, isData: true)
          .then((value) {
        log("SSS :${value.data} // ${value.isSuccess} // ${value.message}");
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
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: Duration(milliseconds: 500),
              content:
                  Text(language(context, translations!.successfullyComplete)),
              backgroundColor: appColor(context).appTheme.primary,
            ));
          }
        }
      });
    } catch (e) {
      notifyListeners();
    }
  }
}

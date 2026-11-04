import 'package:edemand_partner/app/generalImports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:lottie/lottie.dart';
import 'package:edemand_partner/ui/widgets/subscriptionAccessGuard.dart';

class SubscriptionsScreen extends StatefulWidget {
  final String from;

  const SubscriptionsScreen({super.key, required this.from});

  static Route route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) {
        final Map<String, dynamic> arguments =
            routeSettings.arguments as Map<String, dynamic>;

        return MultiBlocProvider(
          providers: [
            BlocProvider<FetchSubscriptionsCubit>(
              create: (context) => FetchSubscriptionsCubit(),
            ),
            BlocProvider<AddSubscriptionTransactionCubit>(
              create: (context) => AddSubscriptionTransactionCubit(),
            ),
          ],
          child: SubscriptionsScreen(from: arguments["from"]),
        );
      },
    );
  }

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  List<Map<String, dynamic>> enabledPaymentMethods = [];
  String? selectedPaymentMethod;

  PaymentGatewaysSettings? paymentGatewaySetting;

  //----------------------------------- Cashfree Payment Gateway Start ----------------------------
  final CFPaymentGatewayService _cfPaymentGatewayService =
      CFPaymentGatewayService();

  void _initializeCashfree() {
    _cfPaymentGatewayService.setCallback(
      _handleCashfreePaymentSuccess,
      _handleCashfreePaymentError,
    );
  }

  Future<void> _handleCashfreePaymentSuccess(String orderId) async {
    // The SDK fires this callback whenever the checkout session ends —
    // including when the user abandons the flow. We must verify the actual
    // payment status with our backend before treating it as a success.
    final isPaid = await SettingsRepository().getCashfreeOrderStatus(
      orderId: orderId,
    );
    _addSubscriptionTransaction(isSuccess: isPaid);
  }

  void _handleCashfreePaymentError(
    CFErrorResponse errorResponse,
    String orderId,
  ) {
    _addSubscriptionTransaction(isSuccess: false);
  }

  Future<void> openCashfreeGateway({
    required final String cashfreeOrderId,
    required final String cashfreePaymentSessionId,
    required final String environment,
  }) async {
    try {
      final CFEnvironment cfEnvironment =
          environment.toLowerCase() == 'production'
          ? CFEnvironment.PRODUCTION
          : CFEnvironment.SANDBOX;

      final CFSession session = CFSessionBuilder()
          .setEnvironment(cfEnvironment)
          .setOrderId(cashfreeOrderId)
          .setPaymentSessionId(cashfreePaymentSessionId)
          .build();

      final cfWebCheckout = CFWebCheckoutPaymentBuilder()
          .setSession(session)
          .build();

      _cfPaymentGatewayService.doPayment(cfWebCheckout);
    } on CFException catch (e) {
      UiUtils.showMessage(context, e.message, ToastificationType.error);
      _addSubscriptionTransaction(isSuccess: false);
    } catch (e) {
      UiUtils.showMessage(
        context,
        'onlinePaymentMethodNotAvailable',
        ToastificationType.error,
      );
      _addSubscriptionTransaction(isSuccess: false);
    }
  }

  //----------------------------------- Cashfree Payment Gateway End ----------------------------

  //----------------------------------- Razorpay Payment Gateway Start ----------------------------
  final Razorpay _razorpay = Razorpay();

  Future<void> initializeRazorpay() async {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleRazorPayPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleRazorPayPaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleRazorPayExternalWallet);
  }

  void _handleRazorPayPaymentSuccess(final PaymentSuccessResponse response) {
    _razorpay.clear();
    _addSubscriptionTransaction(isSuccess: true);
  }

  void _handleRazorPayPaymentError(final PaymentFailureResponse response) {
    _razorpay.clear();

    _addSubscriptionTransaction(isSuccess: false);
  }

  void _handleRazorPayExternalWallet(final ExternalWalletResponse response) {
    _razorpay.clear();
  }

  Future<void> openRazorPayGateway({
    required final double subscriptionAmount,
    required final String razorpayOrderId,
    required final String subscriptionId,
    required final String transactionId,
  }) async {
    // The country's own key / currency win over the system ones.
    final CountryPaymentGateway? countryGateway = context
        .read<FetchCountrySettingsCubit>()
        .gatewayOf('razorpay');
    final options = <String, Object?>{
      'key': (countryGateway?.clientKey ?? '').isNotEmpty
          ? countryGateway!.clientKey
          : paymentGatewaySetting!.razorpayKey,
      'amount': (subscriptionAmount * 100).toInt(),
      'name': appName,
      'description': 'razorpaySubscriptionPlanDescription'.translate(
        context: context,
      ),
      'currency': (countryGateway?.currency ?? '').isNotEmpty
          ? countryGateway!.currency
          : paymentGatewaySetting!.razorpayCurrency,
      'notes': {'transaction_id': transactionId},
      'order_id': razorpayOrderId,
      'prefill': {
        'contact':
            context.read<ProviderDetailsCubit>().providerDetails.user?.phone ??
            '',
        'email':
            context.read<ProviderDetailsCubit>().providerDetails.user?.email ??
            '',
      },
    };

    _razorpay.open(options);
  }

  //----------------------------------- Razorpay Payment Gateway End ----------------------------

  //----------------------------------- Stripe Payment Gateway Start ----------------------------
  Future<void> openStripePaymentGateway({
    required final String transactionId,
  }) async {
    try {
      final CountryPaymentGateway? countryGateway = context
          .read<FetchCountrySettingsCubit>()
          .gatewayOf('stripe');
      StripeService.init(
        (countryGateway?.clientKey ?? '').isNotEmpty
            ? countryGateway!.clientKey
            : paymentGatewaySetting!.stripePublishableKey,
        (countryGateway?.mode ?? '').isNotEmpty
            ? countryGateway!.mode
            : paymentGatewaySetting!.stripeMode,
      );

      final response = await StripeService.payWithPaymentSheet(
        transactionID: transactionId,
      );

      if (response.status == 'succeeded') {
        _addSubscriptionTransaction(isSuccess: true);
      } else if (response.status == 'cancelled') {
        // Closing the sheet is not a failure: no "payment failed" dialog.
        _addSubscriptionTransaction(isSuccess: false, showResultDialog: false);
        if (!mounted) return;
        const String key = 'paymentNotCompleted';
        final String translated = key.translate(context: context);
        UiUtils.showMessage(
          context,
          translated == key
              ? "Payment wasn't completed. You can try again or choose another payment method."
              : translated,
          ToastificationType.info,
        );
      } else {
        _addSubscriptionTransaction(isSuccess: false);
      }
    } catch (error) {
      debugPrint('[Stripe] subscription payment error: $error');
    }
  }

  //----------------------------------- Stripe Payment Gateway End ----------------------------

  @override
  void initState() {
    super.initState();
    fetchSubscriptionDetails();
    fetchProviderSubscriptionDetailsFromSettingsAPI();
    Future.delayed(Duration.zero, () {
      if (mounted) context.read<FetchCountrySettingsCubit>().fetch();
    });
    getPaymentGatewaySetting();
    _initializeCashfree();
    _refreshPaymentMethods();
  }

  /// The provider's country decides the methods (`get_country_settings`); the
  /// system settings are only used until those load.
  void _refreshPaymentMethods() {
    final FetchSystemSettingsCubit system = context
        .read<FetchSystemSettingsCubit>();
    enabledPaymentMethods =
        context.read<FetchCountrySettingsCubit>().paymentMethodsFrom(
          system.getAllPaymentMethods(),
        ) ??
        system.getEnabledPaymentMethods();
    final bool selectionStillOffered = enabledPaymentMethods.any(
      (method) => method['paymentType'] == selectedPaymentMethod,
    );
    if (!selectionStillOffered) {
      selectedPaymentMethod = enabledPaymentMethods.isNotEmpty
          ? enabledPaymentMethods[0]['paymentType']
          : null;
    }
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void fetchSubscriptionDetails() {
    Future.delayed(Duration.zero, () {
      context.read<FetchSubscriptionsCubit>().fetchSubscriptions();
      context
          .read<FetchPreviousSubscriptionsCubit>()
          .fetchPreviousSubscriptions();
    });
  }

  void fetchProviderSubscriptionDetailsFromSettingsAPI() {
    Future.delayed(Duration.zero, () {
      context.read<FetchSystemSettingsCubit>().getSettings(isAnonymous: false);
    });
  }

  void getPaymentGatewaySetting() {
    final cubit = context.read<FetchSystemSettingsCubit>();
    if (cubit.state is FetchSystemSettingsSuccess) {
      paymentGatewaySetting = cubit.paymentGatewaysSettings;
    }
  }

  Future<dynamic> _showSubscriptionPaymentMessageDialog({
    required final isSuccess,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: context.colorScheme.secondaryColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(UiUtils.borderRadiusOf10),
            ),
          ),
          title: Text(
            (isSuccess ? "paymentSuccess" : "paymentFailed").translate(
              context: context,
            ),
            style: TextStyle(
              color: isSuccess ? AppColors.greenColor : AppColors.redColor,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                isSuccess
                    ? "assets/animation/success.json"
                    : "assets/animation/fail.json",
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 25),
              Text(
                isSuccess
                    ? "subscriptionSuccess".translate(context: context)
                    : "subscriptionFailure".translate(context: context),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.blackColor,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              CustomRoundedButton(
                widthPercentage: 0.9,
                backgroundColor: Theme.of(context).colorScheme.accentColor,
                buttonTitle: isSuccess
                    ? "goToHome".translate(context: context)
                    : 'okay'.translate(context: context),
                showBorder: false,
                onTap: () {
                  if (isSuccess) {
                    if (widget.from == "drawer") {
                      Navigator.of(context)
                        ..pop()
                        ..pop('subscription');
                      // Navigator.of(
                      //   context,
                      // ).popUntil((Route route) => route.isFirst);
                    } else if (widget.from == "login" ||
                        widget.from == "splash") {
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, Routes.main);
                    }
                    return;
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _addSubscriptionTransaction({
    required final bool isSuccess,
    final bool showResultDialog = true,
  }) {
    final Map<String, dynamic> transactionData = context
        .read<AddSubscriptionTransactionCubit>()
        .getTransactionDetails();

    if (!isSuccess) {
      context
          .read<AddSubscriptionTransactionCubit>()
          .addSubscriptionTransaction(
            needToCreateRazorpayOrderID: false,
            paymentMethodType: transactionData["paymentMethodType"],
            status: "failed",
            subscriptionId: transactionData["subscriptionId"],
            message: "Payment Failed",
            transactionId: transactionData["transactionId"],
          );
    } else {
      context
          .read<AddSubscriptionTransactionCubit>()
          .addSubscriptionTransaction(
            needToCreateRazorpayOrderID: false,
            message: "Payment successful",
            status: "success",
            paymentMethodType: transactionData["paymentMethodType"],
            subscriptionId: transactionData["subscriptionId"],
            transactionId: transactionData["transactionId"],
          );
    }
    if (showResultDialog) {
      _showSubscriptionPaymentMessageDialog(isSuccess: isSuccess);
    }
  }

  Widget setSubscriptionPlanDetailsPoint({required final String title}) {
    return Row(
      children: [
        const Icon(Icons.check_circle_rounded, color: AppColors.greenColor),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            title,
            style: TextStyle(color: Theme.of(context).colorScheme.blackColor),
          ),
        ),
      ],
    );
  }

  void onBuyButtonPressed({
    required final bool isLoading,
    required final String subscriptionId,
    required final String price,
  }) {
    UiUtils.showAnimatedDialog(
      context: context,
      child: SubscriptionAccessGuard(
        child: ConfirmationDialog(
          title: "areYouSure",
          description: "buySubscriptionDescription",
          confirmButtonBackgroundColor: Theme.of(
            context,
          ).colorScheme.accentColor,
          confirmButtonName: "buy",
          widgetUnderDescription:
              enabledPaymentMethods.length <= 1 || price == "0"
              ? null
              : StatefulBuilder(
                  builder: (context, dialogState) {
                    return RadioGroup<String>(
                      groupValue:
                          selectedPaymentMethod, // current selected value
                      onChanged: (val) {
                        selectedPaymentMethod = val;
                        dialogState(() {});
                        setState(() {});
                      },
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: enabledPaymentMethods.length,
                        itemBuilder: (context, index) {
                          final Map<String, dynamic> paymentMethod =
                              enabledPaymentMethods[index];
                          return CustomRadioOptionsWidget(
                            isFirst: index == 0,
                            isLast: index == enabledPaymentMethods.length - 1,
                            image: paymentMethod["image"]!,
                            title: paymentMethod["title"]!,
                            subTitle: paymentMethod["description"]!,
                            value: paymentMethod["paymentType"]!,
                            applyAccentColor: false,
                          );
                        },
                      ),
                    );
                  },
                ),
          confirmButtonPressed: () {
            Navigator.pop(context, {"isConfirm": true});
          },
        ),
      ),
    ).then((value) {
      if (!mounted ||
          !context.read<FetchSystemSettingsCubit>().subscriptionsEnabled ||
          value == null) {
        return;
      }

      if ((value as Map)["isConfirm"]) {
        if (price == "0") {
          context
              .read<AddSubscriptionTransactionCubit>()
              .addSubscriptionTransaction(
                needToCreateRazorpayOrderID: false,
                subscriptionId: subscriptionId,
                message: "subscription successful",
                status: "active",
                paymentMethodType: "free",
              );
          return;
        }
        if (enabledPaymentMethods.isNotEmpty && selectedPaymentMethod != null) {
          context
              .read<AddSubscriptionTransactionCubit>()
              .addSubscriptionTransaction(
                needToCreateRazorpayOrderID:
                    selectedPaymentMethod == "razorpay" ||
                    selectedPaymentMethod == "cashfree",
                subscriptionId: subscriptionId,
                message: "subscription successful",
                status: "Pending",
                paymentMethodType: selectedPaymentMethod!,
              );
        } else {
          UiUtils.showMessage(
            context,
            "onlinePaymentNotAvailableNow",
            ToastificationType.warning,
          );
        }
      }
      return;
    });
  }

  Widget getCurrentlyActivePlanDetails({
    required SubscriptionInformation activeSubscriptionInformation,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubscriptionDetailsContainer(
          onBuyButtonPressed: () {
            onBuyButtonPressed(
              price: activeSubscriptionInformation.discountPrice != "0"
                  ? activeSubscriptionInformation.discountPriceWithTax ?? "0"
                  : activeSubscriptionInformation.priceWithTax ?? "0",
              subscriptionId: activeSubscriptionInformation.id ?? "0",
              isLoading: false,
            );
          },
          subscriptionDetails: activeSubscriptionInformation,
          isPreviousSubscription: false,
          isAvailableForPurchase: false,
          showLoading: false,
          isActiveSubscription: true,
          needToShowPaymentStatus: true,
        ),
      ],
    );
  }

  Widget subscriptionsDetailsContainer() {
    return SizedBox(
      height: context.screenHeight,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            if (context
                    .watch<ProviderDetailsCubit>()
                    .providerDetails
                    .subscriptionInformation
                    ?.isSubscriptionActive ==
                "active")
              BlocBuilder<ProviderDetailsCubit, ProviderDetailsState>(
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: getCurrentlyActivePlanDetails(
                      activeSubscriptionInformation:
                          state.providerDetails.subscriptionInformation ??
                          SubscriptionInformation(),
                    ),
                  );
                },
              ),
            BlocConsumer<
              AddSubscriptionTransactionCubit,
              AddSubscriptionTransactionState
            >(
              listener: (context, state) async {
                if (state is AddSubscriptionTransactionFailure) {
                  UiUtils.showMessage(
                    context,
                    state.errorMessage,
                    ToastificationType.error,
                  );
                }
                if (state is AddSubscriptionTransactionSuccess) {
                  context.read<ProviderDetailsCubit>().updateProviderDetails(
                    subscriptionInformation: state.subscriptionInformation,
                  );

                  if (state.subscriptionStatus == "success" ||
                      state.subscriptionStatus == "failed") {
                    return;
                  }
                  if (state.paymentMethodType == "stripe") {
                    openStripePaymentGateway(
                      transactionId: state.transactionId.toString(),
                    );
                  } else if (state.paymentMethodType == "razorpay") {
                    await initializeRazorpay();

                    final Map<String, dynamic> transactionDetails = context
                        .read<AddSubscriptionTransactionCubit>()
                        .getTransactionDetails(); //
                    openRazorPayGateway(
                      subscriptionAmount: double.parse(
                        transactionDetails["subscriptionAmount"],
                      ),
                      razorpayOrderId: state.razorpayOrderId,
                      subscriptionId: transactionDetails["subscriptionId"],
                      transactionId: transactionDetails["transactionId"],
                    );
                  } else if (state.paymentMethodType == "paystack") {
                    _openWebviewPaymentGateway(
                      webviewLink: state.paystackPaymentURL,
                    );
                  } else if (state.paymentMethodType == "paypal") {
                    _openWebviewPaymentGateway(
                      webviewLink: state.paypalPaymentURL,
                    );
                  } else if (state.paymentMethodType == "flutterwave") {
                    _openWebviewPaymentGateway(
                      webviewLink: state.flutterwavePaymentURL,
                    );
                  } else if (state.paymentMethodType == 'xendit') {
                    _openWebviewPaymentGateway(webviewLink: state.xenditURL);
                  } else if (state.paymentMethodType == 'cashfree') {
                    openCashfreeGateway(
                      cashfreeOrderId: state.cashfreeOrderId,
                      cashfreePaymentSessionId: state.cashfreePaymentSessionId,
                      environment:
                          paymentGatewaySetting?.cashfreeEnvironment ?? '',
                    );
                  } else if (state.paymentMethodType == "free") {
                    _showSubscriptionPaymentMessageDialog(isSuccess: true);
                  } else {
                    UiUtils.showMessage(
                      context,
                      "onlinePaymentMethodNotAvailable",
                      ToastificationType.error,
                    );
                  }
                }
              },
              builder: (context, state) {
                bool showLoading = false;
                String onGoingPaymentSubscriptionId = "-1";

                if (state is AddSubscriptionTransactionInProgress) {
                  showLoading = true;
                  onGoingPaymentSubscriptionId = state.subscriptionId;
                } else if (state is AddSubscriptionTransactionSuccess ||
                    state is AddSubscriptionTransactionFailure) {
                  showLoading = false;
                }
                return context
                                .watch<ProviderDetailsCubit>()
                                .providerDetails
                                .subscriptionInformation
                                ?.isSubscriptionActive ==
                            "deactive" ||
                        context
                                .watch<ProviderDetailsCubit>()
                                .providerDetails
                                .subscriptionInformation
                                ?.isSubscriptionActive ==
                            "pending"
                    ? BlocBuilder<
                        FetchSubscriptionsCubit,
                        FetchSubscriptionsState
                      >(
                        builder: (context, state) {
                          if (state is FetchSubscriptionsFailure) {
                            return Center(
                              child: ErrorContainer(
                                errorMessage: state.errorMessage.translate(
                                  context: context,
                                ),
                                onTapRetry: () {
                                  context
                                      .read<FetchSubscriptionsCubit>()
                                      .fetchSubscriptions();
                                },
                              ),
                            );
                          } else if (state is FetchSubscriptionsSuccess) {
                            if (state.subscriptionsData.isEmpty) {
                              return NoDataContainer(
                                title: 'noSubscriptionPlanAvailable'.translate(
                                  context: context,
                                ),
                                subTitle: 'noSubscriptionPlanAvailableSubTitle'
                                    .translate(context: context),
                              );
                            }

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: Row(
                                      children: [
                                        const Expanded(
                                          child: Divider(thickness: 0.5),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          child: CustomText(
                                            'buymoregetmore'.translate(
                                              context: context,
                                            ),
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.blackColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const Expanded(
                                          child: Divider(thickness: 0.5),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: List.generate(
                                      state.subscriptionsData.length +
                                          (state.isLoadingMoreSubscriptions
                                              ? 1
                                              : 0),
                                      (index) {
                                        if (index >=
                                            state.subscriptionsData.length) {
                                          return const CustomCircularProgressIndicator();
                                        }

                                        final SubscriptionInformation
                                        subscriptionDetails =
                                            state.subscriptionsData[index];

                                        return SubscriptionDetailsContainer(
                                          onBuyButtonPressed: () {
                                            onBuyButtonPressed(
                                              price:
                                                  subscriptionDetails
                                                          .discountPrice !=
                                                      "0"
                                                  ? subscriptionDetails
                                                            .discountPriceWithTax ??
                                                        "0"
                                                  : subscriptionDetails
                                                            .priceWithTax ??
                                                        "0",
                                              isLoading:
                                                  onGoingPaymentSubscriptionId ==
                                                      subscriptionDetails.id
                                                  ? showLoading
                                                  : false,
                                              subscriptionId:
                                                  subscriptionDetails.id ?? "0",
                                            );
                                          },
                                          isPreviousSubscription: false,
                                          subscriptionDetails:
                                              subscriptionDetails,
                                          isAvailableForPurchase:
                                              context
                                                      .read<
                                                        ProviderDetailsCubit
                                                      >()
                                                      .providerDetails
                                                      .subscriptionInformation
                                                      ?.isSubscriptionActive ==
                                                  "deactive" ||
                                              context
                                                      .watch<
                                                        ProviderDetailsCubit
                                                      >()
                                                      .providerDetails
                                                      .subscriptionInformation
                                                      ?.isSubscriptionActive ==
                                                  "pending",
                                          isActiveSubscription: false,
                                          needToShowPaymentStatus: false,
                                          showLoading:
                                              onGoingPaymentSubscriptionId ==
                                                  subscriptionDetails.id
                                              ? showLoading
                                              : false,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return Center(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Column(
                                children: List.generate(
                                  7,
                                  (index) => ShimmerLoadingContainer(
                                    child: CustomShimmerContainer(
                                      height: 250,
                                      width: MediaQuery.sizeOf(context).width,
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 5,
                                      ),
                                      borderRadius: UiUtils.borderRadiusOf10,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : const CustomContainer();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!context.watch<FetchSystemSettingsCubit>().subscriptionsEnabled) {
      return const SubscriptionAccessGuard();
    }
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: UiUtils.getSystemUiOverlayStyle(context: context),
      child: PopScope(
        canPop: widget.from != "login" || widget.from != "splash",

        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primaryColor,
          appBar: UiUtils.getSimpleAppBar(
            statusBarColor: context.colorScheme.secondaryColor,
            context: context,
            elevation: 1,
            isLeadingIconEnable:
                widget.from == "login" || widget.from == "splash"
                ? false
                : true,
            title: 'subscriptions'.translate(context: context),
            actions: [
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 10),
                child: CustomSvgPicture(
                  svgImage: AppAssets.history,
                  color: context.colorScheme.accentColor,
                  onTap: () {
                    Navigator.pushNamed(context, Routes.previousSubscriptions);
                  },
                ),
              ),
              if (widget.from == "login" || widget.from == "splash") ...[
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 10),
                  child:
                      context
                              .watch<ProviderDetailsCubit>()
                              .providerDetails
                              .subscriptionInformation
                              ?.isSubscriptionActive ==
                          "active"
                      ? CustomInkWellContainer(
                          onTap: () {
                            Navigator.of(
                              context,
                            ).pushReplacementNamed(Routes.main);
                          },
                          child: Icon(
                            Icons.home_outlined,
                            color: Theme.of(context).colorScheme.blackColor,
                            size: 30,
                          ),
                        )
                      : CustomInkWellContainer(
                          onTap: () {
                            UiUtils.showAnimatedDialog(
                              context: context,
                              child: const LogoutAccountDialog(),
                            );
                          },
                          child: Icon(
                            Icons.logout,
                            color: Theme.of(context).colorScheme.blackColor,
                            size: 30,
                          ),
                        ),
                ),
              ],
            ],
          ),
          body:
              BlocListener<FetchSystemSettingsCubit, FetchSystemSettingsState>(
                listener: (context, state) {
                  if (state is FetchSystemSettingsSuccess) {
                    context.read<ProviderDetailsCubit>().updateProviderDetails(
                      subscriptionInformation: state.subscriptionInformation,
                    );
                    getPaymentGatewaySetting();
                    if (mounted) setState(_refreshPaymentMethods);
                  }
                },
                child:
                    BlocListener<
                      FetchCountrySettingsCubit,
                      FetchCountrySettingsState
                    >(
                      listener: (context, state) {
                        if (state is FetchCountrySettingsSuccess && mounted) {
                          setState(_refreshPaymentMethods);
                        }
                      },
                      child: CustomRefreshIndicator(
                        onRefresh: () async {
                          fetchSubscriptionDetails();
                          fetchProviderSubscriptionDetailsFromSettingsAPI();
                        },
                        child: subscriptionsDetailsContainer(),
                      ),
                    ),
              ),
        ),
      ),
    );
  }

  void _openWebviewPaymentGateway({required String webviewLink}) {
    Navigator.pushNamed(
      context,
      Routes.paypalPaymentScreen,
      arguments: {'paymentURL': webviewLink},
    ).then((final Object? value) {
      final parameter = value as Map;
      if (parameter['paymentStatus'] == 'Completed') {
        _addSubscriptionTransaction(isSuccess: true);
      } else if (parameter['paymentStatus'] == 'Failed') {
        _addSubscriptionTransaction(isSuccess: false);
      }
    });
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../app/generalImports.dart';

class WebviewPaymentScreen extends StatefulWidget {
  const WebviewPaymentScreen({required this.paymentUrl, final Key? key})
    : super(key: key);
  final String paymentUrl;

  static Route route(final RouteSettings settings) {
    final arguments = settings.arguments as Map;
    return CupertinoPageRoute(
      builder: (final context) =>
          WebviewPaymentScreen(paymentUrl: arguments['paymentURL']),
    );
  }

  @override
  State<WebviewPaymentScreen> createState() => _WebviewPaymentScreenState();
}

class _WebviewPaymentScreenState extends State<WebviewPaymentScreen> {
  late WebViewController webViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(Theme.of(context).colorScheme.primaryContainer)
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (final progress) {},
        onPageStarted: (final url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (final WebResourceError error) {},
        onNavigationRequest: (final request) {
          if (request.url.startsWith("${baseUrl}app_payment_status") ||
              request.url.startsWith("${baseUrl}app_paystack_payment_status") ||
              request.url.startsWith("${baseUrl}flutterwave_payment_status") ||
              request.url.startsWith("${baseUrl}xendit_payment_status") ||
              request.url.startsWith(
                '${context.read<FetchSystemSettingsCubit>().paymentGatewaysSettings.flutterwaveWebsiteUrl}/payment-status',
              ) ||
              request.url.startsWith(
                '${context.read<FetchSystemSettingsCubit>().paymentGatewaysSettings.paypalWebsiteUrl}/payment-status',
              )) {
            final url = request.url;
            if (url.contains('payment_status=Completed') ||
                url.contains('status=success')) {
              Navigator.pop(context, {'paymentStatus': 'Completed'});
            } else if (url.contains('payment_status=Failed') ||
                url.contains('status=cancelled')) {
              Navigator.pop(context, {'paymentStatus': 'Failed'});
            }
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse(widget.paymentUrl));

  DateTime? currentBackPressTime;

  Future<bool> onWillPop() {
    final now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      UiUtils.showMessage(
        context,
        "doNotPressBackWhilePaymentAndDoubleTapBackButtonToExit",
        ToastificationType.warning,
      );

      return Future.value(false);
    }
    Navigator.pop(context, {"paymentStatus": "Failed"});
    return Future.value(true);
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
    body: PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          return;
        } else {
          final now = DateTime.now();
          if (currentBackPressTime == null ||
              now.difference(currentBackPressTime!) >
                  const Duration(seconds: 2)) {
            currentBackPressTime = now;
            UiUtils.showMessage(
              context,
              "doNotPressBackWhilePaymentAndDoubleTapBackButtonToExit",
              ToastificationType.warning,
            );
            return;
          } else {
            Navigator.pop(context, {"paymentStatus": "Failed"});
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: UiUtils.getSystemUiOverlayStyle(context: context),
          leading: CustomInkWellContainer(
            onTap: () async {
              final DateTime now = DateTime.now();
              if (currentBackPressTime == null ||
                  now.difference(currentBackPressTime!) >
                      const Duration(seconds: 2)) {
                currentBackPressTime = now;
                UiUtils.showMessage(
                  context,
                  'doNotPressBackWhilePaymentAndDoubleTapBackButtonToExit',
                  ToastificationType.warning,
                );
              } else {
                Navigator.pop(context, {'paymentStatus': 'Failed'});
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Center(
                child: CustomSvgPicture(
                  svgImage:
                      Directionality.of(context).toString().contains(
                        TextDirection.RTL.value.toLowerCase(),
                      )
                      ? AppAssets.arrowNext
                      : AppAssets.backArrowLight,
                  color: context.colorScheme.accentColor,
                ),
              ),
            ),
          ),
          title: Text(
            "payment".translate(context: context),
            style: TextStyle(color: Theme.of(context).colorScheme.blackColor),
          ),
          centerTitle: true,
          elevation: 1,
          backgroundColor: Theme.of(context).colorScheme.secondaryColor,
          surfaceTintColor: Theme.of(context).colorScheme.secondaryColor,
        ),
        body: WebViewWidget(controller: webViewController),
      ),
    ),
  );
}

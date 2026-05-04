import 'package:webview_flutter/webview_flutter.dart';

import '../../config.dart';
import '../../providers/app_pages_provider/checkout_web_view_provider.dart';

class CheckoutWebView extends StatefulWidget {
  const CheckoutWebView({super.key});

  @override
  State<CheckoutWebView> createState() => CheckoutWebViewState();
}

Map<dynamic, dynamic>? getPaymentUrl(context) => null;

class CheckoutWebViewState extends State<CheckoutWebView> {
  String? url;
  String? token;
  int selectedIndex = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async {
      return true;
    }, child: Consumer<CheckoutWebViewProvider>(
        builder: (context1, paymentCtrl, child) {
      return StatefulWrapper(
        onInit: () => Future.delayed(Durations.short3)
            .then((value) => paymentCtrl.onReady(context)),
        child: Scaffold(
            backgroundColor: appColor(context).appTheme.whiteColor,
            appBar:
                AppBarCommon(title: language(context, translations!.payment)),
            body: Stack(children: [
              if (paymentCtrl.controller != null)
                WebViewWidget(controller: paymentCtrl.controller!),
              if (paymentCtrl.isLoading)
                Container(
                    color: Colors.white,
                    child: Center(
                        child: Material(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60)),
                            child: const Padding(
                                padding: EdgeInsets.all(8),
                                child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 3))))))
            ]).height(MediaQuery.of(context).size.height)),
      );
    }));
  }
}

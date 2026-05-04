import 'package:flutter/rendering.dart';

import '../../../config.dart';
import 'layouts/payment_method_layout.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentProvider>(builder: (context1, value, child) {
      return StatefulWrapper(
        onInit: () => Future.delayed(Duration(milliseconds: 50))
            .then((_) => value.onReady(context)),
        child: Scaffold(
            appBar: AppBarCommon(title: translations!.payment),
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ListView(controller: value.scrollController, children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(language(context, translations!.selectMethod),
                                style: appCss.dmDenseSemiBold14.textColor(
                                    appColor(context).appTheme.lightText))
                            .paddingSymmetric(horizontal: Insets.i20),
                        const VSpace(Sizes.s10),
                        ...value.paymentList
                            .where((element) => element.status == true)
                            .toList()
                            .asMap()
                            .entries
                            .map((e) => e.value.name == "cash"
                                ? Container()
                                : PaymentMethodLayout(
                                    index: e.key,
                                    data: e.value,
                                    selectIndex: value.selectIndex,
                                    onTap: () => value.onSelectPaymentMethod(
                                        e.key, e.value.slug))),
                        const VSpace(Sizes.s80),
                      ]),
                  /*  ButtonCommon(
                              title: translations!.continues,
                              onTap: () => value.subscriptionPlan(context))
                          .paddingOnly(bottom: Insets.i30)*/
                ]),
                AnimatedBuilder(
                    animation: value.scrollController,
                    builder: (BuildContext context, Widget? child) {
                      return AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          height: value.scrollController.position
                                      .userScrollDirection ==
                                  ScrollDirection.reverse
                              ? 0
                              : 70,
                          child: child);
                    },
                    child: ButtonCommon(
                            title: translations!.continues,
                            margin: Sizes.s20,
                            onTap: () => value.subscriptionPlan(context))
                        .paddingOnly(bottom: Insets.i20)
                        .backgroundColor(appColor(context).appTheme.whiteBg))
              ],
            )),
      );
    });
  }
}

import 'package:fixit_provider/providers/app_pages_provider/job_request_providers/job_request_details_provider.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../config.dart';

class BidAmountSheet extends StatelessWidget {
  final int? serviceId;

  const BidAmountSheet({super.key,  this.serviceId});

  @override
  Widget build(BuildContext context) {
    return Consumer2<HomeProvider, JobRequestDetailsProvider>(
        builder: (context1, value, job, child) {
      return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
              child: SizedBox(
                      height: MediaQuery.of(context).size.height / 3,
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      language(context,
                                          translations!.bidAnEstimatedPrice),
                                      style: appCss.dmDenseMedium18.textColor(
                                          appColor(context).appTheme.darkText)),
                                  const Icon(CupertinoIcons.multiply)
                                      .inkWell(onTap: () => route.pop(context))
                                ]).paddingSymmetric(horizontal: Insets.i20),
                            Expanded(
                                child: Form(
                                    key: job.withdrawKey,
                                    child: Column(children: [
                                      const VSpace(Sizes.s25),
                                      Expanded(
                                          child: SingleChildScrollView(
                                                  child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                            TextFieldCommon(
                                                keyboardType:
                                                    TextInputType.number,
                                                focusNode: job.amountFocus,
                                                controller: job.amountCtrl,
                                                validator: (value) => validation
                                                    .dynamicTextValidation(
                                                        context,
                                                        value,
                                                        translations!
                                                            .enterAmount),
                                                hintText:
                                                    translations!.enterAmount!,
                                                prefixIcon: eSvgAssets.earning),
                                          ])
                                                      .paddingAll(Insets.i15)
                                                      .boxShapeExtension(
                                                          color:
                                                              appColor(context)
                                                                  .appTheme
                                                                  .fieldCardBg,
                                                          radius:
                                                              AppRadius.r15))
                                              .paddingSymmetric(
                                                  horizontal: Insets.i20)),
                                      BottomSheetButtonCommon(
                                              textOne: translations!.cancel,
                                              textTwo: translations!.confirm,
                                              applyTap: () {
                                                job.bidSend(
                                                    context, serviceId);
                                              },
                                              clearTap: () {
                                                job.amountCtrl.text = "";

                                                route.pop(context);
                                              })
                                          .padding(
                                              horizontal: Insets.i20,
                                              bottom: Insets.i20)
                                    ])))
                          ]).paddingOnly(top: Insets.i20))
                  .bottomSheetExtension(context)));
    });
  }
}

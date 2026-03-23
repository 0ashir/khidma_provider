import 'dart:developer';

import 'package:fixit_provider/screens/app_pages_screens/custom_job_request/job_request_details/layouts/my_bid.dart';
import '../../../../config.dart';
import '../../../../providers/app_pages_provider/job_request_providers/job_request_details_provider.dart';
import 'layouts/job_request_service_description.dart';
import 'layouts/job_request_shimmer.dart';

class HomeJobRequestDetails extends StatelessWidget {
  const HomeJobRequestDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<JobRequestDetailsProvider>(
        builder: (context1, serviceCtrl, child) {
      log("serviceCtrl.service1!:::${serviceCtrl.service1?.id}");
      return Container(
        color: appColor(context).appTheme.whiteBg,
        child: SafeArea(
          child: StatefulWrapper(
              onInit: () => Future.delayed(const Duration(milliseconds: 150))
                  .then((val) => serviceCtrl.onHomeReady(context)),
              child: PopScope(
                  canPop: true,
                  onPopInvoked: (didPop) {
                    serviceCtrl.onBack(context, false);
                    if (didPop) return;
                  },
                  child: RefreshIndicator(
                    onRefresh: () {
                      return serviceCtrl.onRefresh(context);
                    },
                    child: (serviceCtrl.widget1Opacity == 0.0)
                        ? const JobRequestShimmer()
                        : serviceCtrl.service1 == null
                            ? const JobRequestShimmer()
                            : Scaffold(
                                body: AnimatedOpacity(
                                duration: const Duration(milliseconds: 1200),
                                opacity: serviceCtrl.widget1Opacity,
                                child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      SingleChildScrollView(
                                          controller:
                                              serviceCtrl.scrollController,
                                          child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                ServiceImageLayout(
                                                    isActionShow: false,
                                                    onBack: () => serviceCtrl
                                                        .onBack(context, true),
                                                    title: serviceCtrl
                                                            .service1?.title ??
                                                        '',
                                                    image: serviceCtrl.service1!
                                                                    .media !=
                                                                [] &&
                                                            serviceCtrl
                                                                .service1!
                                                                .media!
                                                                .isNotEmpty
                                                        ? serviceCtrl
                                                            .service1!
                                                            .media![serviceCtrl
                                                                .selectedIndex]
                                                            .originalUrl!
                                                        : null),
                                                if (serviceCtrl.service1!.media!
                                                        .length >
                                                    1)
                                                  const VSpace(Sizes.s12),
                                                if (serviceCtrl.service1!.media!
                                                        .length >
                                                    1)
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: serviceCtrl
                                                          .service1!.media!
                                                          .asMap()
                                                          .entries
                                                          .map((e) => ServicesImageLayout(
                                                              data: e.value
                                                                  .originalUrl,
                                                              index: e.key,
                                                              selectIndex:
                                                                  serviceCtrl
                                                                      .selectedIndex,
                                                              onTap: () =>
                                                                  serviceCtrl
                                                                      .onImageChange(
                                                                          e.key)))
                                                          .toList()),
                                                Column(children: [
                                                  Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        Image.asset(
                                                            eImageAssets
                                                                .servicesBg,
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width),
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                  language(
                                                                      context,
                                                                      translations!
                                                                          .amount),
                                                                  style: appCss
                                                                      .dmDenseMedium12
                                                                      .textColor(appColor(
                                                                              context)
                                                                          .appTheme
                                                                          .primary)),
                                                              if (serviceCtrl
                                                                      .service1!
                                                                      .status !=
                                                                  null)
                                                                Text(
                                                                    symbolPosition
                                                                        ? "${getSymbol(context)}${(currency(context).currencyVal * (serviceCtrl.service1!.status != "accepted" ? serviceCtrl.service1!.initialPrice != null ? serviceCtrl.service1?.initialPrice : '' : serviceCtrl.service1!.finalPrice!)).toStringAsFixed(2)}"
                                                                        : "${(currency(context).currencyVal * (serviceCtrl.service1!.status != "accepted" ? serviceCtrl.service1!.initialPrice != null ? serviceCtrl.service1?.initialPrice : '' : serviceCtrl.service1!.finalPrice!)).toStringAsFixed(2)}${getSymbol(context)}",
                                                                    style: appCss
                                                                        .dmDenseBold18
                                                                        .textColor(appColor(context)
                                                                            .appTheme
                                                                            .primary))
                                                            ]).paddingSymmetric(
                                                            horizontal:
                                                                Insets.i20)
                                                      ]).paddingSymmetric(
                                                      vertical: Insets.i15),
                                                  JobRequestServiceDescription(
                                                      services:
                                                          serviceCtrl.service1),
                                                  const VSpace(Sizes.s15),
                                                  /* if (serviceCtrl.service1!
                                                              .providerId !=
                                                          null &&
                                                      (serviceCtrl.service1
                                                                  ?.bids?[
                                                              'provider_id'] ==
                                                          userModel!.id))
                                                    if (serviceCtrl.service1
                                                            ?.bids?['status'] ==
                                                        "accepted") */
                                                  MyBidHome(
                                                      service:
                                                          serviceCtrl.service1),
                                                  const VSpace(Sizes.s15),
                                                  CustomerLayout(
                                                      title: translations!
                                                          .customerDetails,
                                                      data: serviceCtrl
                                                          .service1!.user,
                                                      isDetailShow: serviceCtrl
                                                                      .service1!
                                                                      .status ==
                                                                  "open" ||
                                                              serviceCtrl
                                                                      .service1!
                                                                      .status ==
                                                                  "pending"
                                                          ? false
                                                          : true),
                                                  const VSpace(Sizes.s15),
                                                  if (serviceCtrl
                                                              .service1!.bids ==
                                                          null ||
                                                      serviceCtrl
                                                              .service1!.bids ==
                                                          {})
                                                    ButtonCommon(
                                                        title:
                                                            translations!.bid,
                                                        onTap: () => serviceCtrl
                                                            .bidClick(context,
                                                                serviceId:
                                                                    serviceCtrl
                                                                        .service1!.id))
                                                ]).paddingSymmetric(
                                                    horizontal: Insets.i20),
                                                const VSpace(Sizes.s20),
                                              ])
                                              .marginOnly(bottom: Insets.i100)),
                                    ]),
                              )),
                  ))),
        ),
      );
    });
  }
}

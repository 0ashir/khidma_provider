import 'dart:developer';

import 'package:fixit_provider/screens/app_pages_screens/custom_job_request/job_request_details/layouts/my_bid.dart';
import '../../../../config.dart';
import '../../../../providers/app_pages_provider/job_request_providers/job_request_details_provider.dart';
import 'layouts/job_request_service_description.dart';
import 'layouts/job_request_shimmer.dart';

class JobRequestDetails extends StatelessWidget {
  const JobRequestDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<JobRequestDetailsProvider>(
        builder: (context1, serviceCtrl, child) {
      // log("serviceCtrl.service!:::${serviceCtrl.service!.category}");
      return Container(
        color: appColor(context).appTheme.whiteBg,
        child: SafeArea(
          child: StatefulWrapper(
              onInit: () => Future.delayed(const Duration(milliseconds: 150))
                  .then((val) => serviceCtrl.onReady(context)),
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
                    child: (serviceCtrl.isRequestLoading == true)
                        ? const JobRequestShimmer()
                        : serviceCtrl.service == null
                            ? Center(child: Text("Data not found"))
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
                                                            .service?.title ??
                                                        '',
                                                    image: serviceCtrl.service!
                                                                    .media !=
                                                                [] &&
                                                            serviceCtrl
                                                                .service!
                                                                .media!
                                                                .isNotEmpty
                                                        ? serviceCtrl
                                                            .service!
                                                            .media![serviceCtrl
                                                                .selectedIndex]
                                                            .originalUrl!
                                                        : null),
                                                if (serviceCtrl.service!.media!
                                                        .length >
                                                    1)
                                                  const VSpace(Sizes.s12),
                                                if (serviceCtrl
                                                        .service!.media!.length >
                                                    1)
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: serviceCtrl
                                                          .service!.media!
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
                                                                      .service!
                                                                      .status !=
                                                                  null)
                                                                Text(
                                                                    symbolPosition
                                                                        ? "${getSymbol(context)}${(currency(context).currencyVal * (serviceCtrl.service!.status != "accepted" ? serviceCtrl.service!.initialPrice != null ? (serviceCtrl.service?.initialPrice ?? 0.0) : 0 : serviceCtrl.service!.finalPrice ?? 0)).toStringAsFixed(2)}"
                                                                        : "${getSymbol(context)}${(currency(context).currencyVal * (serviceCtrl.service!.status != "accepted" ? serviceCtrl.service!.initialPrice != null ? (serviceCtrl.service?.initialPrice ?? 0.0) : 0 : serviceCtrl.service!.finalPrice ?? 0)).toStringAsFixed(2)}${getSymbol(context)}",
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
                                                          serviceCtrl.service),
                                                  const VSpace(Sizes.s15),
                                                  /* if (serviceCtrl.service!
                                                              .providerId !=
                                                          null &&
                                                      (serviceCtrl.service?.bids
                                                              ?.providerId ==
                                                          userModel!.id)) */
                                                  /*  if (serviceCtrl.service!
                                                            .bids!.status ==
                                                        "accepted") */
                                                  if (serviceCtrl
                                                          .service!.bids !=
                                                      null)
                                                    MyBid(
                                                        service: serviceCtrl
                                                            .service),
                                                  const VSpace(Sizes.s15),
                                                  CustomerLayout(
                                                      title: translations!
                                                          .customerDetails,
                                                      data: serviceCtrl
                                                          .service!.user,
                                                      isDetailShow: serviceCtrl
                                                                      .service!
                                                                      .status ==
                                                                  "open" ||
                                                              serviceCtrl
                                                                      .service!
                                                                      .status ==
                                                                  "pending"
                                                          ? false
                                                          : true),
                                                  const VSpace(Sizes.s15),
                                                  if (serviceCtrl
                                                              .service?.bids ==
                                                          null ||
                                                      serviceCtrl
                                                              .service?.bids ==
                                                          {})
                                                    ButtonCommon(
                                                        title:
                                                            translations!.bid,
                                                        onTap: () => serviceCtrl
                                                            .bidClick(context,
                                                                serviceId:
                                                                    serviceCtrl
                                                                        .service
                                                                        ?.id))
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

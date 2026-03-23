import 'dart:developer';

import 'package:fixit_provider/screens/bottom_screens/booking_screen/layouts/filter_dropdown.dart';

import '../../../config.dart';
import 'booking_shimmer/booking_list_shimmer.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();

    return Consumer4<HomeProvider, BookingProvider, UserDataApiProvider,
        DashboardProvider>(
      builder: (context1, home, value, userApi, dash, child) {
        log("isFreelancer::${value.bookingList}");
        return WillPopScope(
          onWillPop: () async {
            userApi.bookingPage = 1;
            return true;
          },
          child: StatefulWrapper(
            onInit: () {
              /*  value.onReady(context); */
              Future.delayed(const Duration(milliseconds: 100),
                  () => value.onReady(context));
              /* if (value.bookingList.isEmpty) {
                Future.delayed(const Duration(milliseconds: 150),
                    () => value.onReady(context));
              } */
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                  leadingWidth: 0,
                  centerTitle: false,
                  title: Text(language(context, translations!.bookings),
                      style: appCss.dmDenseBold18
                          .textColor(appColor(context).appTheme.darkText)),
                  actions: [
                    Stack(alignment: Alignment.topRight, children: [
                      CommonArrow(
                        arrow: eSvgAssets.filter,
                        onTap: () => value.onTapFilter(context),
                      ).paddingAll(Insets.i4),
                      if (value.totalCountFilter() != "0")
                        Container(
                                child: Text(value.totalCountFilter(),
                                        style: appCss.dmDenseMedium8.textColor(
                                            appColor(context)
                                                .appTheme
                                                .whiteColor))
                                    .paddingAll(Insets.i5))
                            .decorated(
                                color: appColor(context).appTheme.red,
                                shape: BoxShape.circle)
                            .paddingOnly(top: Insets.i2, left: Insets.i2)
                    ]),
                    CommonArrow(
                            arrow: eSvgAssets.chat,
                            onTap: () =>
                                route.pushNamed(context, routeName.chatHistory))
                        .paddingSymmetric(horizontal: Insets.i10),
                    CommonArrow(
                        arrow: eSvgAssets.notification,
                        onTap: () =>
                            route.pushNamed(context, routeName.notification)),
                    const HSpace(Sizes.s20)
                  ]),
              body: SafeArea(
                child: RefreshIndicator(
                  onRefresh: () async {
                    value.selectedValue = value.options.first;
                    userApi.bookingPage = 1;
                    log("    value.isLoadingForBookingHistory || value.bookingList.isEmpty::${userApi.bookingPage}");
                    value.isLoadingForBookingHistory = true;
                    await userApi.getBookingHistory(context);
                  },
                  child: /* BookingBodyLayout() */
                      NotificationListener(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent &&
                          !userApi.isLoadingForBookingHistory &&
                          value.hasMoreData) {
                        userApi.getBookingHistory(context, isLoadMore: true);
                      }
                      return false;
                    },
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SearchTextFieldCommon(
                              suffixIcon: value.searchCtrl.text.isEmpty
                                  ? const SizedBox()
                                  : const Icon(Icons.close).inkWell(onTap: () {
                                      if (value.searchCtrl.text.isNotEmpty) {
                                        value.searchFocus.unfocus();
                                        value.searchCtrl.clear();
                                        value.resetPagination();
                                        userApi.getBookingHistory(context);
                                        userApi.loadBookingsFromLocal(context);
                                      } else {
                                        value.searchFocus.unfocus();
                                      }
                                    }),
                              focusNode: value.searchFocus,
                              hinText: language(
                                  context, translations!.searchWithBookingId),
                              controller: value.searchCtrl,
                              onChanged: (v) {
                                if (v.isEmpty || v.length > 1) {
                                  userApi.getBookingHistory(context,
                                      search: value.searchCtrl.text);
                                }
                              },
                              onFieldSubmitted: (v) =>
                                  userApi.getBookingHistory(context,
                                      search: v)).padding(
                              horizontal: Insets.i20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                        language(
                                            context, translations!.allBooking),
                                        style: appCss.dmDenseMedium18.textColor(
                                            appColor(context)
                                                .appTheme
                                                .darkText)),
                                    const HSpace(Sizes.s10),
                                    SvgPicture.asset(
                                      eSvgAssets.refresh,
                                      colorFilter: ColorFilter.mode(
                                        appColor(context).appTheme.primary,
                                        BlendMode.srcIn,
                                      ),
                                      height: Sizes.s20,
                                      width: Sizes.s20,
                                    ).inkWell(onTap: () async {
                                      await userApi.getBookingHistory(context);
                                    }),
                                    Spacer(),
                                    FilterDropdown()
                                  ]).padding(vertical: Insets.i15),
                              // if (!isFreelancer && !isServiceman)
                              // if (value.bookingList.isNotEmpty)
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     SizedBox(
                              //       width: Sizes.s200,
                              //       child: Text(
                              //           language(context,
                              //               translations!.onlyViewBookings),
                              //           style:
                              //               appCss.dmDenseMedium12.textColor(
                              //             value.isAssignMe
                              //                 ? appColor(context)
                              //                     .appTheme
                              //                     .primary
                              //                 : appColor(context)
                              //                     .appTheme
                              //                     .darkText,
                              //           )),
                              //     ),
                              //     FlutterSwitchCommon(
                              //         value: value.isAssignMe,
                              //         onToggle: (val) {
                              //           value.onTapSwitch(val, context);
                              //           hideLoading(context);
                              //         }),
                              //   ],
                              // )
                              //     .paddingAll(Insets.i15)
                              //     .boxShapeExtension(
                              //         color: value.isAssignMe
                              //             ? appColor(context)
                              //                 .appTheme
                              //                 .primary
                              //                 .withOpacity(0.15)
                              //             : appColor(context)
                              //                 .appTheme
                              //                 .fieldCardBg,
                              //         radius: AppRadius.r10)
                              //     .paddingOnly(bottom: Insets.i20),
                              if (!isFreelancer)
                                value.isLoadingForBookingHistory ||
                                        userApi.isLoadingForBookingHistory &&
                                            value.bookingList.isEmpty
                                    ? const BookingListShimmer() // Show shimmer only when loading and list is empty
                                    : value.bookingList.isNotEmpty &&
                                            value.isLoadingForBookingHistory ==
                                                false
                                        ? Column(
                                            children: [
                                              ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount:
                                                      value.bookingList.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return BookingLayout(
                                                        data: value
                                                            .bookingList[index],
                                                        onTap: () =>
                                                            value.onTapBookings(
                                                                value.bookingList[
                                                                    index],
                                                                context));
                                                  }),
                                              if (userApi
                                                      .isLoadingForBookingHistory ||
                                                  value.hasMoreData)
                                                Image.asset(
                                                        eGifAssets.loaderGif,
                                                        height: Sizes.s80,
                                                        width: Sizes.s80)
                                                    .center()
                                                    .paddingOnly(
                                                        bottom: Sizes.s100),
                                              if (value.bookingList.length == 1)
                                                const SizedBox(
                                                  height: Sizes.s200,
                                                ),
                                            ],
                                          )
                                        : EmptyLayout(
                                            isButton: false,
                                            title: translations!.ohhNoListEmpty,
                                            subtitle:
                                                translations!.yourBookingList,
                                            widget: Stack(
                                              children: [
                                                Image.asset(
                                                  isFreelancer
                                                      ? eImageAssets.noListFree
                                                      : eImageAssets.noBooking,
                                                  height: Sizes.s280,
                                                ),
                                              ],
                                            ),
                                          ).padding(top: Sizes.s50),
                              if (isFreelancer)
                                value.isLoadingForBookingHistory &&
                                        userApi.isLoadingForBookingHistory &&
                                        value.bookingList.isEmpty
                                    ? const BookingListShimmer() // Show shimmer only when loading and list is empty
                                    : value.bookingList
                                            .isNotEmpty /* &&
                                            value.isLoadingForBookingHistory ==
                                                false */
                                        ? Column(
                                            children: [
                                              ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount:
                                                      value.bookingList.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return BookingLayout(
                                                        data: value
                                                            .bookingList[index],
                                                        onTap: () {
                                                          print(
                                                              "object====> ${value.bookingList[index]}");
                                                          value.onTapBookings(
                                                              value.bookingList[
                                                                  index],
                                                              context);
                                                        });
                                                  }),
                                              if (userApi
                                                      .isLoadingForBookingHistory ||
                                                  value.hasMoreData)
                                                Image.asset(
                                                        eGifAssets.loaderGif,
                                                        height: Sizes.s80,
                                                        width: Sizes.s80)
                                                    .center()
                                                    .paddingOnly(
                                                        bottom: Sizes.s120),
                                            ],
                                          )
                                        : EmptyLayout(
                                            // isButtonShow: false,
                                            title:
                                                translations!.yourBookingList,
                                            subtitle: '',
                                            widget: SizedBox(
                                              height: Sizes.s306,
                                              width: double.infinity,
                                              child: Image.asset(
                                                eImageAssets.noBooking,
                                                height: Sizes.s306,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ).padding(top: Sizes.s100)
                            ],
                          ).padding(
                              horizontal: Insets.i20,
                              top: Insets.i15,
                              bottom: Insets.i50),
                          if (isFreelancer)
                            if (value.bookingList.length == 1)
                              const VSpace(Sizes.s105),
                        ],
                      ).padding(bottom: Sizes.s20),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

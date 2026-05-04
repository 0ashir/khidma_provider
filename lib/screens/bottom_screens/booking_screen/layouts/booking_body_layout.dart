// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:fixit_provider/config.dart';
import 'package:fixit_provider/screens/bottom_screens/booking_screen/booking_shimmer/booking_list_shimmer.dart';

class BookingBodyLayout extends StatelessWidget {
  const BookingBodyLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    return Consumer4<HomeProvider, BookingProvider, UserDataApiProvider,
            DashboardProvider>(
        builder: (context, home, value, userApi, dash, child) {
      return NotificationListener(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
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
                hinText: language(context, translations!.searchWithBookingId),
                controller: value.searchCtrl,
                onChanged: (v) {
                  if (v.isEmpty || v.length > 2) {
                    userApi.getBookingHistory(context,
                        search: value.searchCtrl.text);
                  }
                },
                onFieldSubmitted: (v) =>
                    userApi.getBookingHistory(context, search: v),
              ).padding(horizontal: Insets.i20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(language(context, translations!.allBooking),
                          style: appCss.dmDenseMedium18
                              .textColor(appColor(context).appTheme.darkText))
                      .paddingOnly(/*  top: Insets.i25, */ bottom: Insets.i15),
                  if (!isFreelancer && !isServiceman)
                    // if (value.bookingList.isNotEmpty)
                    /*    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: Sizes.s200,
                          child: Text(
                              language(context, translations!.onlyViewBookings),
                              style: appCss.dmDenseMedium12.textColor(
                                value.isAssignMe
                                    ? appColor(context).appTheme.primary
                                    : appColor(context).appTheme.darkText,
                              )),
                        ),
                        FlutterSwitchCommon(
                            value: value.isAssignMe,
                            onToggle: (val) {
                              value.onTapSwitch(val, context);
                              hideLoading(context);
                            }),
                      ],
                    )
                        .paddingAll(Insets.i15)
                        .boxShapeExtension(
                            color: value.isAssignMe
                                ? appColor(context)
                                    .appTheme
                                    .primary
                                    .withOpacity(0.15)
                                : appColor(context).appTheme.fieldCardBg,
                            radius: AppRadius.r10)
                        .paddingOnly(bottom: Insets.i20),*/
                    if (!isFreelancer)
                      userApi.isLoadingForBookingHistory /* &&
                                      value.bookingList.isEmpty */
                          ? const BookingListShimmer()
                          : value.bookingList.isNotEmpty
                              ? Column(
                                  children: [
                                    ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: value.bookingList.length,
                                        itemBuilder: (context, index) {
                                          return BookingLayout(
                                              data: value.bookingList[index],
                                              onTap: () => value.onTapBookings(
                                                  value.bookingList[index],
                                                  context));
                                        }),
                                    if (userApi.isLoadingForBookingHistory &&
                                        value.hasMoreData)
                                      Image.asset(eGifAssets.loaderGif,
                                              height: Sizes.s80,
                                              width: Sizes.s80)
                                          .center()
                                          .paddingOnly(bottom: Sizes.s120),
                                  ],
                                )
                              : EmptyLayout(
                                  isButton: false,
                                  title: translations!.ohhNoListEmpty,
                                  subtitle: translations!.yourBookingList,
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
                                ),
                  if (isFreelancer)
                    value.bookingList.isNotEmpty
                        ? Column(
                            children:
                                value.bookingList.asMap().entries.map((e) {
                              return BookingLayout(
                                data: e.value,
                                onTap: () =>
                                    home.onTapBookings(e.value, context),
                              );
                            }).toList(),
                          )
                        : EmptyLayout(
                            isButton: false,
                            title: translations!.ohhNoListEmpty,
                            subtitle: translations!.yourBookingList,
                            widget: Stack(
                              children: [
                                Image.asset(
                                  isFreelancer
                                      ? eImageAssets.noListFree
                                      : eImageAssets.noBooking,
                                  height: Sizes.s306,
                                ),
                              ],
                            ),
                          ),
                ],
              ).padding(
                  horizontal: Insets.i20, top: Insets.i15, bottom: Insets.i50),
            ],
          ).padding(bottom: Sizes.s20),
        ),
      );
    });
  }
}

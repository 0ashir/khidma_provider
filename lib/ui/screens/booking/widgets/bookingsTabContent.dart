import 'package:edemand_partner/app/generalImports.dart';
import 'package:flutter/material.dart';

class BookingsTabContent extends StatefulWidget {
  const BookingsTabContent({
    super.key,
    this.status,
    this.bookingOrder,
    // required this.scrollController,
  });

  final String? status;
  // final ScrollController scrollController;
  final String? bookingOrder;

  @override
  State<BookingsTabContent> createState() => _BookingsTabContentState();
}

class _BookingsTabContentState extends State<BookingsTabContent> {
  Widget getTitleAndSubDetails({
    required String title,
    required String subDetails,
    bool? isSubtitleBold,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          title.translate(context: context),
          fontSize: 14,
          maxLines: 2,
          color: Theme.of(context).colorScheme.lightGreyColor,
        ),
        const SizedBox(height: 5),
        if (title == "statusLbl") ...[
          CustomContainer(
            borderRadius: UiUtils.borderRadiusOf5,
            padding: const EdgeInsets.all(5),
            color: UiUtils.getStatusColor(
              context: context,
              statusVal: subDetails.toLowerCase(),
            ).withValues(alpha: 0.2),
            child: CustomText(
              subDetails,
              fontSize: 14,
              maxLines: 2,
              color: UiUtils.getStatusColor(
                context: context,
                statusVal: subDetails.toLowerCase(),
              ),
              fontWeight: isSubtitleBold ?? false
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ] else ...[
          CustomText(
            subDetails,
            fontSize: 14,
            maxLines: 2,
            color: Theme.of(context).colorScheme.blackColor,
            fontWeight: isSubtitleBold ?? false
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      onRefresh: () async {
        context.read<FetchBookingsCubit>().fetchBookings(
          status: widget.status,
          customRequestOrder: widget.bookingOrder,
        );
      },
      child: BlocBuilder<FetchBookingsCubit, FetchBookingsState>(
        builder: (BuildContext context, FetchBookingsState state) {
          if (state is FetchBookingsInProgress) {
            return ListView.builder(
              padding: const EdgeInsetsDirectional.all(16),
              itemCount: 8,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.0),
                  child: ShimmerLoadingContainer(
                    child: CustomShimmerContainer(height: 220),
                  ),
                );
              },
            );
          }

          if (state is FetchBookingsFailure) {
            return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 120,
                    ),
                    child: Center(
                      child: ErrorContainer(
                        onTapRetry: () {
                          context.read<FetchBookingsCubit>().fetchBookings(
                            status: widget.status,
                            customRequestOrder: widget.bookingOrder,
                          );
                        },
                        errorMessage: state.errorMessage.translate(
                          context: context,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          if (state is FetchBookingsSuccess) {
            if (state.bookings.isEmpty) {
              return LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: constraints.maxHeight,
                    child: Center(
                      child: NoDataContainer(
                        title: 'noDataFound'.translate(context: context),
                        subTitle: 'noDataFoundSubTitle'.translate(
                          context: context,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }

            return NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification notification) {
                if (notification is ScrollEndNotification &&
                    notification.metrics.extentAfter == 0) {
                  if (context.read<FetchBookingsCubit>().hasMoreData()) {
                    context.read<FetchBookingsCubit>().fetchMoreBookings(
                      status: widget.status,
                      customRequestOrder: widget.bookingOrder,
                    );
                  }
                }
                return false;
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      itemCount: state.bookings.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        final BookingsModel bookingModel =
                            state.bookings[index];
                        return BlocProvider<UpdateBookingStatusCubit>(
                          create: (BuildContext context) =>
                              UpdateBookingStatusCubit(),
                          child: Builder(
                            builder: (context) {
                              return BookingCardContainer(
                                bookingModel: bookingModel,
                              );
                            },
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(height: 10),
                    ),
                    if (state.isLoadingMoreBookings)
                      CustomCircularProgressIndicator(
                        color: Theme.of(context).colorScheme.accentColor,
                      ),
                    const SizedBox(height: 200),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../app/generalImports.dart';

class HandymanBookingListScreen extends StatefulWidget {
  const HandymanBookingListScreen({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  State<HandymanBookingListScreen> createState() =>
      _HandymanBookingListScreenState();
}

class _HandymanBookingListScreenState extends State<HandymanBookingListScreen>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
  );
  late final Animation<double> fontAnimation =
      Tween<double>(begin: 22.0, end: 20.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
          reverseCurve: Curves.easeInOut,
        ),
      );
  late final Animation<double> fontAnimation2 =
      Tween<double>(begin: 16.0, end: 8.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
          reverseCurve: Curves.easeInOut,
        ),
      );

  void _headerScrollListener() {
    _animationController.value = UiUtils.inRange(
      currentValue: widget.scrollController.offset,
      minValue: widget.scrollController.position.minScrollExtent,
      maxValue: widget.scrollController.position.maxScrollExtent,
      newMaxValue: 1.0,
      newMinValue: 0.0,
    );
  }

  static const List<String?> _statusValues = [
    null,
    'confirmed',
    'on_the_way',
    'arrived',
    'started',
    'booking_ended',
    'completed',
    'cancelled',
  ];

  int _selectedFilterIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    widget.scrollController.addListener(_headerScrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HandymanBookingsCubit>().fetchBookings();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    widget.scrollController.removeListener(_headerScrollListener);
    _animationController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = _searchController.text.trim();
      context.read<HandymanBookingsCubit>().fetchBookings(
        status: _statusValues[_selectedFilterIndex],
        search: query.isEmpty ? null : query,
      );
    });
  }

  void _onFilterTap(int index) {
    if (_selectedFilterIndex == index) return;
    setState(() => _selectedFilterIndex = index);
    final query = _searchController.text.trim();
    context.read<HandymanBookingsCubit>().fetchBookings(
      status: _statusValues[index],
      search: query.isEmpty ? null : query,
    );
  }

  List<String> _filterLabels() => [
    'all'.translate(context: context),
    'confirmed'.translate(context: context),
    'on_the_way'.translate(context: context),
    'arrived'.translate(context: context),
    'started'.translate(context: context),
    'booking_ended'.translate(context: context),
    'completed'.translate(context: context),
    'cancelled'.translate(context: context),
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final labels = _filterLabels();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: UiUtils.getSystemUiOverlayStyle(context: context),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: context.colorScheme.primaryColor,
          body: NestedScrollView(
            controller: widget.scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: LongAppBarPersistentHeaderDelegate(
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, _) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                CustomText(
                                  'bookingsTitleLbl'.translate(
                                    context: context,
                                  ),
                                  fontSize: fontAnimation.value,
                                  fontWeight: FontWeight.bold,
                                  color: context.colorScheme.blackColor,
                                ),
                                BlocBuilder<
                                  HandymanBookingsCubit,
                                  HandymanBookingsState
                                >(
                                  builder: (context, state) {
                                    if (state is HandymanBookingsSuccess) {
                                      return HeadingAmountAnimation(
                                        key: ValueKey(state.total),
                                        text:
                                            '${state.total} ${'bookingsTitleLbl'.translate(context: context)}',
                                        textStyle: TextStyle(
                                          color: context
                                              .colorScheme
                                              .lightGreyColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: fontAnimation2.value,
                                        ),
                                      );
                                    }
                                    return SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.7,
                                      height: fontAnimation2.value + 8,
                                    );
                                  },
                                ),
                                const SizedBox(height: 10),
                                const CustomShadowLineForDevider(
                                  direction: ShadowDirection.centerToSides,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 55,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: labels.length,
                                itemBuilder: (context, index) {
                                  final selected =
                                      _selectedFilterIndex == index;
                                  return CustomInkWellContainer(
                                    onTap: () => _onFilterTap(index),
                                    child: CustomContainer(
                                      color: selected
                                          ? context.colorScheme.accentColor
                                          : Colors.transparent,
                                      borderRadius: UiUtils.borderRadiusOf10,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 10,
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 90,
                                      ),
                                      child: Center(
                                        child: Text(
                                          labels[index],
                                          style: TextStyle(
                                            color: selected
                                                ? AppColors.whiteColors
                                                : context
                                                      .colorScheme
                                                      .blackColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ];
            },
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Padding(
                //   padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                //   child: CustomTextFormField(
                //     controller: _searchController,
                //     hintText: 'searchBookings'.translate(context: context),
                //     textInputAction: TextInputAction.search,
                //     onSubmit: () {
                //       _debounce?.cancel();
                //       final query = _searchController.text.trim();
                //       context.read<HandymanBookingsCubit>().fetchBookings(
                //         status: _statusValues[_selectedFilterIndex],
                //         search: query.isEmpty ? null : query,
                //       );
                //     },
                //     suffixIcon: IconButton(
                //       icon: Icon(
                //         Icons.search,
                //         color: context.colorScheme.accentColor,
                //       ),
                //       onPressed: () {
                //         _debounce?.cancel();
                //         final query = _searchController.text.trim();
                //         context.read<HandymanBookingsCubit>().fetchBookings(
                //           status: _statusValues[_selectedFilterIndex],
                //           search: query.isEmpty ? null : query,
                //         );
                //       },
                //     ),
                //   ),
                // ),
                Expanded(child: _buildList()),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    return CustomRefreshIndicator(
      onRefresh: () {
        context.read<HandymanBookingsCubit>().refresh();
      },
      child: BlocBuilder<HandymanBookingsCubit, HandymanBookingsState>(
        builder: (context, state) {
          if (state is HandymanBookingsInProgress) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              itemCount: 8,
              itemBuilder: (_, __) => const Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: ShimmerLoadingContainer(
                  child: CustomShimmerContainer(height: 110),
                ),
              ),
            );
          }

          if (state is HandymanBookingsFailure) {
            return Center(
              child: ErrorContainer(
                errorMessage: state.errorMessage.translate(context: context),
                onTapRetry: () {
                  final query = _searchController.text.trim();
                  context.read<HandymanBookingsCubit>().fetchBookings(
                    status: _statusValues[_selectedFilterIndex],
                    search: query.isEmpty ? null : query,
                  );
                },
              ),
            );
          }

          if (state is HandymanBookingsSuccess) {
            if (state.bookings.isEmpty) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: NoDataContainer(
                    title: 'noDataFound'.translate(context: context),
                  ),
                ),
              );
            }
            final showExtra = state.isLoadingMore || state.loadingMoreError;
            return NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollEndNotification &&
                    notification.metrics.extentAfter == 0) {
                  context.read<HandymanBookingsCubit>().fetchMoreBookings();
                }
                return false;
              },
              child: ListView.separated(
                padding: const EdgeInsetsDirectional.fromSTEB(15, 10, 15, 20),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: state.bookings.length + (showExtra ? 1 : 0),
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  if (index >= state.bookings.length) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: CustomLoadingMoreContainer(
                          isError: state.loadingMoreError,
                          onErrorButtonPressed: () {
                            context
                                .read<HandymanBookingsCubit>()
                                .fetchMoreBookings();
                          },
                        ),
                      ),
                    );
                  }
                  final b = state.bookings[index];
                  return BlocProvider(
                    create: (_) => UpdateBookingStatusCubit(),
                    child: BookingCardContainer(
                      isLead: b.isLead,
                      bookingModel: BookingsModel(
                        id: b.id,
                        customer: b.customer,
                        customerId: b.customerId,
                        customerNo: b.customerNo,
                        customerEmail: b.customerEmail,
                        profileImage: b.profileImage,
                        address: b.address,
                        addressId: b.address.isNotEmpty ? '1' : '0',
                        dateOfService: b.dateOfService,
                        startingTime: b.startingTime,
                        endingTime: b.endingTime,
                        finalTotal: b.finalTotal,
                        currencySymbol: b.currency,
                        currencyDecimalPlaces: b.currencyDecimalPlaces,
                        paymentMethod: b.paymentMethod,
                        status: b.orderStatus,
                        translatedStatus: b.transalatedOrderStatus,
                        invoiceNo: b.invoiceNo,
                        assignedHandymen: b.assignedHandymen,
                        services: const [],
                      ),
                      onTap: () => Navigator.pushNamed(
                        context,
                        Routes.handymanBookingDetails,
                        arguments: b.id,
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../app/generalImports.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  BookingScreenState createState() => BookingScreenState();
}

class BookingScreenState extends State<BookingScreen>
    with
        AutomaticKeepAliveClientMixin,
        SingleTickerProviderStateMixin,
        WidgetsBindingObserver {
  int currFilter = 0;
  String? selectedStatus;
  String? selectedBookingOrder;
  int currentOrder = 0;
  List<Map> filters = [];
  List<Map> orderFilters = [];

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

  void scrollListener() {
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
    'awaiting',
    'confirmed',
    'on_the_way',
    'arrived',
    'started',
    'rescheduled',
    'booking_ended',
    'completed',
    'cancelled',
  ];

  void _updateFilterLists() {
    filters = [
      {'id': '0', 'fName': 'all'.translate(context: context)},
      {'id': '1', 'fName': 'awaiting'.translate(context: context)},
      {'id': '2', 'fName': 'confirmed'.translate(context: context)},
      {'id': '3', 'fName': 'on_the_way'.translate(context: context)},
      {'id': '4', 'fName': 'arrived'.translate(context: context)},
      {'id': '5', 'fName': 'started'.translate(context: context)},
      {'id': '6', 'fName': 'rescheduled'.translate(context: context)},
      {'id': '7', 'fName': 'booking_ended'.translate(context: context)},
      {'id': '8', 'fName': 'completed'.translate(context: context)},
      {'id': '9', 'fName': 'cancelled'.translate(context: context)},
    ];
    orderFilters = [
      {'id': '0', 'fName': 'defaultBookings'.translate(context: context)},
      {'id': '1', 'fName': 'customBookings'.translate(context: context)},
    ];
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Add listener once in initState — same pattern as HomeScreen
    widget.scrollController.addListener(scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchBookingsCubit>().fetchBookings(
        status: selectedStatus,
        customRequestOrder: selectedBookingOrder,
      );
    });
  }

  @override
  void didChangeDependencies() {
    // Only update translated labels here — do NOT add scroll listener here
    _updateFilterLists();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    widget.scrollController.removeListener(scrollListener);
    widget.scrollController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (currFilter == index) return;
    currFilter = index;
    selectedStatus = _statusValues[index];
    setState(() {});
    context.read<FetchBookingsCubit>().fetchBookings(
      status: selectedStatus,
      customRequestOrder: selectedBookingOrder,
    );
  }

  void _onOrderTapped(int index) {
    if (currentOrder == index) return;
    currentOrder = index;
    selectedBookingOrder = index == 1 ? '1' : '';
    setState(() {});
    context.read<FetchBookingsCubit>().fetchBookings(
      status: selectedStatus,
      customRequestOrder: selectedBookingOrder,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<LanguageDataCubit, LanguageDataState>(
      listener: (context, state) {
        if (state is GetLanguageDataSuccess) {
          currFilter = 0;
          selectedStatus = null;
          _updateFilterLists();
          context.read<FetchBookingsCubit>().fetchBookings(
            status: selectedStatus,
            customRequestOrder: selectedBookingOrder,
          );
          setState(() {});
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: UiUtils.getSystemUiOverlayStyle(context: context),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primaryColor,
            body: Stack(
              children: [
                // NestedScrollView — same pattern as HomeScreen
                NestedScrollView(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      CustomText(
                                        'bookingTab'.translate(
                                          context: context,
                                        ),
                                        fontSize: fontAnimation.value,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.blackColor,
                                      ),
                                      BlocBuilder<
                                        FetchBookingsCubit,
                                        FetchBookingsState
                                      >(
                                        builder: (context, state) {
                                          if (state is FetchBookingsSuccess) {
                                            return HeadingAmountAnimation(
                                              key: ValueKey(state.total),
                                              text:
                                                  '${state.total} ${'bookingTab'.translate(context: context)}',
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
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.7,
                                            height: fontAnimation2.value + 8,
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      const CustomShadowLineForDevider(
                                        direction:
                                            ShadowDirection.centerToSides,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 55,
                                    child: _buildTabBar(context),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ];
                  },
                  body: BookingsTabContent(
                    status: selectedStatus,
                    bookingOrder: selectedBookingOrder,
                  ),
                ),
                // Floating bottom order tab bar
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 70,
                    ),
                    child: CustomContainer(
                      height: 55,
                      borderRadius: UiUtils.borderRadiusOf50,
                      border: Border.all(
                        color: context.colorScheme.lightGreyColor,
                        width: 0.2,
                      ),
                      color: context.colorScheme.secondaryColor,
                      child: _buildBookingOrderTabBar(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: filters.length,
      itemBuilder: (BuildContext context, int index) {
        final bool isSelected = currFilter == index;
        return CustomInkWellContainer(
          onTap: () => _onTabTapped(index),
          child: CustomContainer(
            color: isSelected
                ? Theme.of(context).colorScheme.accentColor
                : Colors.transparent,
            borderRadius: UiUtils.borderRadiusOf10,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            constraints: const BoxConstraints(minWidth: 90),
            child: Center(
              child: Text(
                filters[index]['fName'],
                style: TextStyle(
                  color: isSelected
                      ? AppColors.whiteColors
                      : Theme.of(context).colorScheme.blackColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBookingOrderTabBar(BuildContext context) {
    return Row(
      children: List.generate(orderFilters.length, (int index) {
        final bool isSelected = currentOrder == index;
        return Expanded(
          child: CustomInkWellContainer(
            showSplashEffect: false,
            onTap: () => _onOrderTapped(index),
            child: CustomContainer(
              color: isSelected
                  ? Theme.of(context).colorScheme.accentColor
                  : Theme.of(context).colorScheme.secondaryColor,
              borderRadius: UiUtils.borderRadiusOf50,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 50,
              child: Center(
                child: CustomText(
                  orderFilters[index]['fName'],
                  color: isSelected
                      ? AppColors.whiteColors
                      : Theme.of(context).colorScheme.blackColor,
                  fontWeight: FontWeight.w500,
                  maxLines: 1,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app/generalImports.dart';

class HandymanDashboardScreen extends StatefulWidget {
  const HandymanDashboardScreen({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  HandymanDashboardScreenState createState() => HandymanDashboardScreenState();
}

class HandymanDashboardScreenState extends State<HandymanDashboardScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late bool _isAvailable;
  HandymanLoginModel? _loginData;

  late final AnimationController _animationController = AnimationController(
    vsync: this,
  );

  late Animation<double> fontAnimation = Tween<double>(begin: 22.0, end: 20.0)
      .animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
          reverseCurve: Curves.easeInOut,
        ),
      );

  late Animation<double> fontAnimation2 = Tween<double>(begin: 16.0, end: 8.0)
      .animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
          reverseCurve: Curves.easeInOut,
        ),
      );

  late Animation<double> avatarAnimation = Tween<double>(begin: 42.0, end: 32.0)
      .animate(
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

  @override
  void initState() {
    super.initState();
    _loginData = HiveRepository.getHandymanData();
    _isAvailable = _loginData?.available ?? true;
    widget.scrollController.addListener(scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HandymanProfileCubit>().fetchProfile();
      context.read<HandymanDashboardCubit>().fetch();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    widget.scrollController.removeListener(scrollListener);
    super.dispose();
  }

  String _getFormattedDate() {
    final currentLang = HiveRepository.getCurrentLanguage();
    final localesToTry = <String>[];
    if (currentLang != null && currentLang.languageCode.isNotEmpty) {
      localesToTry.add(currentLang.languageCode);
    }
    localesToTry.add('en');
    for (final locale in localesToTry) {
      try {
        return DateFormat('EEEE d MMMM', locale).format(DateTime.now());
      } catch (_) {
        continue;
      }
    }
    return DateFormat('EEEE d MMMM').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // Date/time format comes from the country settings; rebuild when they load.
    context.watch<FetchCountrySettingsCubit>();

    return BlocListener<HandymanProfileCubit, HandymanProfileState>(
      listener: (context, state) {
        if (state is HandymanProfileSuccess) {
          setState(() => _isAvailable = state.profile.available);
        } else if (state is HandymanProfileFailure) {
          setState(() => _isAvailable = !_isAvailable);
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: UiUtils.getSystemUiOverlayStyle(context: context),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primaryColor,
            body: NestedScrollView(
              controller: widget.scrollController,
              headerSliverBuilder: (context, _) {
                return [
                  SliverPersistentHeader(
                    delegate: AppBarPersistentHeaderDelegate(
                      child: _buildSliverHeader(),
                    ),
                    pinned: true,
                  ),
                ];
              },
              body: _buildBody(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliverHeader() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, _) {
        return BlocBuilder<HandymanProfileCubit, HandymanProfileState>(
          builder: (context, state) {
            // final imageUrl =
            //     state.currentProfile?.image ?? (_loginData?.image ?? '');
            final name =
                state.currentProfile?.username ?? (_loginData?.username ?? '—');
            final rating =
                state.currentProfile?.averageRatings ??
                (_loginData?.ratings ?? '0.0');
            final avatarSize = avatarAnimation.value;
            // final iconSize = (avatarSize * 0.52).clamp(16.0, 22.0);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: avatarSize + 16,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomText(
                              name,
                              fontSize: fontAnimation.value,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.blackColor,
                              maxLines: 1,
                            ),
                            const SizedBox(height: 2),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  size: 13,
                                  color: AppColors.starRatingColor,
                                ),
                                const SizedBox(width: 3),
                                CustomText(
                                  rating,
                                  fontSize: fontAnimation2.value,
                                  color: context.colorScheme.lightGreyColor,
                                ),
                                const SizedBox(width: 8),
                                CustomSvgPicture(
                                  svgImage: AppAssets.bCalender,
                                  height: fontAnimation2.value,
                                  width: fontAnimation2.value,
                                  color: context.colorScheme.accentColor,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: CustomText(
                                    _getFormattedDate(),
                                    fontSize: fontAnimation2.value,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.lightGreyColor,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // PositionedDirectional(
                      //   start: 0,
                      //   child: CustomContainer(
                      //     height: avatarSize,
                      //     width: avatarSize,
                      //     shape: BoxShape.circle,
                      //     color: context.colorScheme.accentColor.withValues(
                      //       alpha: 0.15,
                      //     ),
                      //     child: ClipOval(
                      //       child: imageUrl.isNotEmpty
                      //           ? CustomCachedNetworkImage(
                      //               imageUrl: imageUrl,
                      //               width: avatarSize,
                      //               height: avatarSize,
                      //               fit: BoxFit.cover,
                      //             )
                      //           : Center(
                      //               child: CustomSvgPicture(
                      //                 svgImage: AppAssets.user,
                      //                 height: iconSize,
                      //                 width: iconSize,
                      //                 color: context.colorScheme.accentColor,
                      //               ),
                      //             ),
                      //     ),
                      //   ),
                      // ),
                      // PositionedDirectional(
                      //   end: 0,
                      //   child: CustomSwitch(
                      //     value: _isAvailable,
                      //     onChanged: (val) {
                      //       setState(() => _isAvailable = val);
                      //       context
                      //           .read<HandymanProfileCubit>()
                      //           .updateAvailability(available: val);
                      //       UiUtils.showMessage(
                      //         context,
                      //         val
                      //             ? 'You are now Online'
                      //             : 'You are now Offline',
                      //         val
                      //             ? ToastificationType.success
                      //             : ToastificationType.warning,
                      //       );
                      //     },
                      //     activeColor: Theme.of(
                      //       context,
                      //     ).colorScheme.accentColor.withValues(alpha: 0.5),
                      //     trackColor: _isAvailable
                      //         ? Theme.of(context).colorScheme.accentColor
                      //         : Colors.grey,
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const CustomShadowLineForDevider(
                    direction: ShadowDirection.centerToSides,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBody() {
    return CustomRefreshIndicator(
      onRefresh: () async {
        context.read<FetchCountrySettingsCubit>().fetch();
        context.read<HandymanProfileCubit>().fetchProfile();
        context.read<HandymanDashboardCubit>().fetch();
      },
      child: BlocBuilder<HandymanDashboardCubit, HandymanDashboardState>(
        builder: (context, state) {
          if (state is HandymanDashboardFailure) {
            return Center(
              child: ErrorContainer(
                errorMessage: state.errorMessage.translate(context: context),
                onTapRetry: () =>
                    context.read<HandymanDashboardCubit>().fetch(),
              ),
            );
          }

          if (state is HandymanDashboardInProgress ||
              state is HandymanDashboardInitial) {
            return CustomCircularProgressIndicator(
              color: Theme.of(context).colorScheme.accentColor,
            );
          }

          if (state is HandymanDashboardSuccess) {
            return _buildDashboardContent(state.data);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildDashboardContent(HandymanDashboardModel data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSalaryCard(data),
          const SizedBox(height: 16),
          _buildSectionTitle('bookingTab'.translate(context: context)),
          const SizedBox(height: 8),
          _buildBookingCountsRow(data),
          const SizedBox(height: 10),
          _buildTotalLeadRow(data),
          const SizedBox(height: 16),
          _buildSectionTitle('cashCollection'.translate(context: context)),
          const SizedBox(height: 8),
          _buildCashCollectionCard(data.cashCollection),
          if (data.recentCompletedBookings.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildSectionTitle('recentBookings'.translate(context: context)),
            const SizedBox(height: 8),
            ...data.recentCompletedBookings.map(_buildRecentBookingItem),
          ],
          const SizedBox(height: kBottomNavigationBarHeight),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: CustomText(
        title,
        color: context.colorScheme.blackColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildSalaryCard(HandymanDashboardModel data) {
    final salaryText = data.salary != null
        ? data.salary!.providerPriceFormat(
            context,
            currencySymbol: data.currency,
            decimalPlaces: data.currencyDecimalPlaces,
          )
        : '—';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: CustomContainer(
        padding: const EdgeInsets.all(16),
        borderRadius: UiUtils.borderRadiusOf10,
        color: context.colorScheme.accentColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  'salaryLbl'.translate(context: context),
                  color: AppColors.whiteColors.withValues(alpha: 0.8),
                  fontSize: 13,
                ),
                const SizedBox(height: 4),
                CustomText(
                  salaryText,
                  color: AppColors.whiteColors,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            CustomSvgPicture(
              svgImage: AppAssets.ttlEarning,
              height: 32,
              width: 32,
              color: AppColors.whiteColors.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCountsRow(HandymanDashboardModel data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          _buildStatBox(
            data.bookings.todayBookings.toString(),
            'todays'.translate(context: context),
          ),
          const SizedBox(width: 8),
          _buildStatBox(
            data.bookings.tomorrowBookings.toString(),
            'tomorrow'.translate(context: context),
          ),
          const SizedBox(width: 8),
          _buildStatBox(
            data.bookings.upcomingBookings.toString(),
            'upcoming'.translate(context: context),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalLeadRow(HandymanDashboardModel data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          _buildStatBox(
            data.totalBookings.toString(),
            'totalBookingLbl'.translate(context: context),
          ),
          const SizedBox(width: 8),
          _buildStatBox(
            data.leadBookings.toString(),
            'leadBookingsLbl'.translate(context: context),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String count, String label) {
    return Expanded(
      child: CustomContainer(
        padding: const EdgeInsets.all(12),
        borderRadius: UiUtils.borderRadiusOf10,
        border: Border.all(
          color: context.colorScheme.lightGreyColor.withValues(alpha: 0.2),
          width: 0.5,
        ),
        color: context.colorScheme.secondaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(count, color: context.colorScheme.accentColor),
            CustomText(
              label,
              color: context.colorScheme.lightGreyColor,
              fontSize: 12,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCashCollectionCard(HandymanDashboardCashCollection cash) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: CustomContainer(
        padding: const EdgeInsets.all(15),
        borderRadius: UiUtils.borderRadiusOf10,
        border: Border.all(
          color: context.colorScheme.lightGreyColor.withValues(alpha: 0.2),
          width: 0.5,
        ),
        color: context.colorScheme.secondaryColor,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    'overallTotal'.translate(context: context),
                    color: context.colorScheme.lightGreyColor,
                    fontSize: 12,
                  ),
                  const SizedBox(height: 4),
                  CustomText(
                    cash.overallTotal.toString().providerPriceFormat(
                      context,
                      currencySymbol: cash.currency,
                      decimalPlaces: cash.currencyDecimalPlaces,
                    ),
                    color: context.colorScheme.blackColor,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 36,
              color: context.colorScheme.lightGreyColor.withValues(alpha: 0.3),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      'outstandingTotal'.translate(context: context),
                      color: context.colorScheme.lightGreyColor,
                      fontSize: 12,
                    ),
                    const SizedBox(height: 4),
                    CustomText(
                      cash.outstandingTotal.toString().providerPriceFormat(
                        context,
                        currencySymbol: cash.currency,
                        decimalPlaces: cash.currencyDecimalPlaces,
                      ),
                      color: context.colorScheme.blackColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentBookingItem(HandymanRecentBooking booking) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: CustomContainer(
        padding: const EdgeInsets.all(12),
        borderRadius: UiUtils.borderRadiusOf10,
        border: Border.all(
          color: context.colorScheme.lightGreyColor.withValues(alpha: 0.2),
          width: 0.5,
        ),
        color: context.colorScheme.secondaryColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    booking.customerName,
                    color: context.colorScheme.blackColor,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      CustomSvgPicture(
                        svgImage: AppAssets.bCalender,
                        height: 12,
                        width: 12,
                        color: context.colorScheme.accentColor,
                      ),
                      const SizedBox(width: 5),
                      CustomText(
                        booking.dateOfService.formatDate(
                          withTime: booking.startingTime,
                        ),
                        color: context.colorScheme.lightGreyColor,
                        fontSize: 12,
                      ),
                      VerticalDivider(
                        color: context.colorScheme.lightGreyColor,
                        thickness: 0.2,
                      ),
                      CustomSvgPicture(
                        svgImage: AppAssets.bClock,
                        height: 12,
                        width: 12,
                        color: context.colorScheme.accentColor,
                      ),
                      const SizedBox(width: 5),
                      CustomText(
                        booking.startingTime.formatTime(
                          onDate: booking.dateOfService,
                        ),
                        color: context.colorScheme.lightGreyColor,
                        fontSize: 12,
                      ),
                    ],
                  ),
                  if (booking.address
                      .replaceAll(',', '')
                      .trim()
                      .isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        CustomSvgPicture(
                          svgImage: AppAssets.mapPic,
                          color: context.colorScheme.accentColor,
                          height: 12,
                          width: 12,
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: CustomText(
                            booking.address,
                            color: context.colorScheme.lightGreyColor,
                            fontSize: 12,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            CustomText(
              booking.finalTotal
                  .replaceAll(',', '')
                  .toString()
                  .priceFormat(
                    context,
                    currencySymbol: booking.currency,
                    decimalPlaces: booking.currencyDecimalPlaces,
                  ),
              color: context.colorScheme.accentColor,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

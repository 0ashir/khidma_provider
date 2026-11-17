import 'package:edemand_partner/ui/widgets/scheduledMaintainanceContainer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../app/generalImports.dart';
import 'widgets/providerTeamStatusSection.dart';
import 'widgets/subscriptionCardWidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.scrollController,
    this.navigateToTab,
  });

  final ScrollController scrollController;
  final void Function(int)? navigateToTab;

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  int gridItems = 4;
  final GlobalKey<ProviderTeamStatusSectionState> _teamStatusKey =
      GlobalKey<ProviderTeamStatusSectionState>();
  late final AnimationController _animationController = AnimationController(
    vsync: this,
  );
  late Animation<double> fontAnimation = Tween<double>(begin: 18.0, end: 17.0)
      .animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
          reverseCurve: Curves.easeInOut,
        ),
      );
  late Animation<double> fontAnimation2 = Tween<double>(begin: 13.0, end: 11.0)
      .animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
          reverseCurve: Curves.easeInOut,
        ),
      );

  late final ScrollController bookingController = ScrollController()
    ..addListener(pageScrollListen);

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
  void dispose() {
    _animationController.dispose();
    widget.scrollController.removeListener(scrollListener);
    widget.scrollController.dispose();
    super.dispose();
  }

  void pageScrollListen() {
    if (mounted && bookingController.isEndReached()) {
      // Check if mounted first
      if (context.read<FetchBookingsCubit>().hasMoreData()) {
        context.read<FetchBookingsCubit>().fetchMoreBookings(
          status: 'awaiting',
          fetchBothBookings: '1',
        );
      }
    }
  }

  String _getFormattedDate() {
    final List<String> localesToTry = [];

    // Add current language code
    final currentLang = HiveRepository.getCurrentLanguage();
    if (currentLang != null && currentLang.languageCode.isNotEmpty) {
      localesToTry.add(currentLang.languageCode);
    }

    // Add default language code from state
    try {
      final languageListState = context.read<LanguageListCubit>().state;
      if (languageListState is GetLanguageListSuccess) {
        final defaultLang = languageListState.defaultLanguage;
        if (defaultLang != null &&
            defaultLang.languageCode.isNotEmpty &&
            !localesToTry.contains(defaultLang.languageCode)) {
          localesToTry.add(defaultLang.languageCode);
        }
      }
    } catch (_) {
      // LanguageListCubit might not be available or state not ready
    }

    // Always add 'en' as final fallback
    localesToTry.add('en');

    // Try each locale until one works
    for (final locale in localesToTry) {
      try {
        return DateFormat('EEEE d MMMM', locale).format(DateTime.now());
      } catch (_) {
        // Continue to next locale if this one fails
        continue;
      }
    }

    // Last resort: format without locale
    try {
      return DateFormat('EEEE d MMMM').format(DateTime.now());
    } catch (_) {
      // If even that fails, return a simple formatted date
      return DateFormat.yMMMMEEEEd().format(DateTime.now());
    }
  }

  String _getSafeLanguageCode() {
    // Use common validation + fallback helper so DateFormat always gets a safe locale
    final Locale currentLocale = LocaleUtils.getCurrentLocale(context);
    return LocaleUtils.getValidLanguageCodeOrFallback(
      currentLocale.languageCode,
    );
  }

  @override
  void initState() {
    widget.scrollController.addListener(scrollListener);

    context.read<FetchBookingsCubit>().fetchBookings(
      status: 'awaiting',
      fetchBothBookings: '1',
    );

    context.read<FetchHomeDataCubit>().getHomeData();
    context.read<FetchSystemSettingsCubit>().getSettings(isAnonymous: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: UiUtils.getSystemUiOverlayStyle(context: context),
      child: SafeArea(
        child: Scaffold(
          // floatingActionButton: Padding(
          //   padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight),
          //   child: FloatingActionButton(
          //     mini: true,
          //     heroTag: 'home_handyman_fab',
          //     tooltip: 'Handyman Module',
          //     backgroundColor: context.colorScheme.accentColor,
          //     onPressed: () {
          //       Navigator.of(context).pushNamed(Routes.handymanMain);
          //     },
          //     child: CustomSvgPicture(
          //       svgImage: AppAssets.group,
          //       color: AppColors.whiteColors,
          //     ),
          //   ),
          // ),
          backgroundColor: Theme.of(context).colorScheme.primaryColor,
          body: NestedScrollView(
            controller: widget.scrollController,
            headerSliverBuilder: (context, _) {
              return [
                SliverPersistentHeader(
                  delegate: AppBarPersistentHeaderDelegate(
                    maxHeight: 64,
                    minHeight: 60,
                    child: Center(
                      child: AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, _) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                context
                                        .watch<ProviderDetailsCubit>()
                                        .providerDetails
                                        .providerInformation
                                        ?.getTranslatedUsername(
                                          HiveRepository.getCurrentLanguage()
                                                  ?.languageCode ??
                                              'en',
                                        ) ??
                                    '',
                                fontSize: fontAnimation.value,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.blackColor,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomSvgPicture(
                                    svgImage: AppAssets.bCalender,
                                    height: fontAnimation2.value,
                                    width: fontAnimation2.value,
                                    color: context.colorScheme.accentColor,
                                  ),
                                  const SizedBox(width: 5),
                                  CustomText(
                                    _getFormattedDate(),
                                    fontSize: fontAnimation2.value,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.lightGreyColor,
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  pinned: true,
                ),
              ];
            },
            body: dashboard(),
          ),
        ),
      ),
    );
  }

  Widget _buildBookingBox(String count, String label) {
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

  Widget dashboard() {
    return CustomRefreshIndicator(
      onRefresh: () async {
        context.read<FetchSystemSettingsCubit>().getSettings(
          isAnonymous: false,
        );
        context.read<FetchCountrySettingsCubit>().fetch();
        context.read<FetchHomeDataCubit>().getHomeData();
        _teamStatusKey.currentState?.refresh();
        context.read<FetchBookingsCubit>().fetchBookings(
          status: 'awaiting',
          fetchBothBookings: '1',
        );
        if (bookingController.hasClients) {
          bookingController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
          );
        }
      },
      child: BlocBuilder<FetchSystemSettingsCubit, FetchSystemSettingsState>(
        builder: (context, settingsState) {
          return BlocBuilder<FetchHomeDataCubit, FetchHomeDataState>(
            builder: (BuildContext context, FetchHomeDataState state) {
              if (settingsState is FetchSystemSettingsSuccess) {
                if (state is FetchHomeDataFailure) {
                  return Center(
                    child: ErrorContainer(
                      onTapRetry: () {
                        context.read<FetchHomeDataCubit>().getHomeData();
                        context.read<FetchBookingsCubit>().fetchBookings(
                          status: 'awaiting',
                          fetchBothBookings: '1',
                        );
                      },
                      errorMessage: state.errorMessage.translate(
                        context: context,
                      ),
                    ),
                  );
                }
                if (state is FetchHomeDataSuccess) {
                  final subscriptionInformation =
                      state.homedata.subscriptionInformation;
                  final bookingInformation = state.homedata.bookings;
                  final earningReport = state.homedata.earningReport;
                  final customJobs = state.homedata.customJobs;
                  final salesData = state.homedata.salesData;
                  UiUtils.customRequestCounter = customJobs!.totalOpenJobs
                      .toString();
                  return SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 2, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProviderTeamStatusSection(key: _teamStatusKey),
                        ScheduledMaintenanceContainer(
                          appSettings: context
                              .read<FetchSystemSettingsCubit>()
                              .appSetting,
                        ),
                        if (context
                            .watch<FetchSystemSettingsCubit>()
                            .subscriptionsEnabled)
                          SubscriptionCardWidget(
                            subscriptionInformation: subscriptionInformation,
                            localLanguageCode: _getSafeLanguageCode(),
                            onTap: () {
                              // Navigate to subscription screen
                              Navigator.of(context)
                                  .pushNamed(
                                    Routes.subscriptionScreen,
                                    arguments: {"from": "drawer"},
                                  )
                                  .then((value) {
                                    if (value == 'subscription') {
                                      context
                                          .read<FetchHomeDataCubit>()
                                          .getHomeData();
                                    }
                                  });
                            },
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: CustomText(
                            'bookingTab'.translate(context: context),
                            color: context.colorScheme.blackColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            height: 2,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildBookingBox(
                                bookingInformation!.todayBookings!.toString(),
                                'todays'.translate(context: context),
                              ),
                              const SizedBox(width: 5),
                              _buildBookingBox(
                                bookingInformation.tommorrowBookings.toString(),
                                'tomorrow'.translate(context: context),
                              ),
                              const SizedBox(width: 5),
                              _buildBookingBox(
                                bookingInformation.upcomingBookings.toString(),
                                'upcoming'.translate(context: context),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: CustomContainer(
                            height: 390,
                            padding: const EdgeInsets.only(top: 15),
                            child: MonthlyEarningBarChart(
                              monthlySales: salesData!.monthlySales,
                              yearlySales: salesData.yearlySales,
                              weeklySales: salesData.weeklySales,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: CustomText(
                            'earningReport'.translate(context: context),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: CustomContainer(
                            padding: const EdgeInsets.all(15),
                            color: context.colorScheme.secondaryColor,
                            borderRadius: UiUtils.borderRadiusOf10,
                            border: Border.all(
                              color: context.colorScheme.lightGreyColor
                                  .withValues(alpha: 0.2),
                              width: 0.5,
                            ),
                            child: Table(
                              columnWidths: const {
                                0: FlexColumnWidth(),
                                1: FlexColumnWidth(),
                              },
                              children: [
                                TableRow(
                                  children: [
                                    _buildEarningItem(
                                      'myIncome'.translate(context: context),
                                      (earningReport!.myIncome ?? "0")
                                          .replaceAll(',', '')
                                          .toString()
                                          .providerPriceFormat(
                                            context,
                                            currencySymbol:
                                                earningReport.currencySymbol,
                                            decimalPlaces: earningReport
                                                .currencyDecimalPlaces,
                                          ),
                                    ),
                                    _buildEarningItem(
                                      'remainingIncome'.translate(
                                        context: context,
                                      ),
                                      (earningReport.remainingIncome ?? "0")
                                          .replaceAll(',', '')
                                          .toString()
                                          .providerPriceFormat(
                                            context,
                                            currencySymbol:
                                                earningReport.currencySymbol,
                                            decimalPlaces: earningReport
                                                .currencyDecimalPlaces,
                                          ),
                                    ),
                                  ],
                                ),
                                const TableRow(
                                  children: [
                                    SizedBox(height: 10),
                                    SizedBox(height: 10),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    _buildEarningItem(
                                      'adminCommLbl'.translate(
                                        context: context,
                                      ),
                                      (earningReport.adminCommission ?? "0")
                                          .replaceAll(',', '')
                                          .toString()
                                          .providerPriceFormat(
                                            context,
                                            currencySymbol:
                                                earningReport.currencySymbol,
                                            decimalPlaces: earningReport
                                                .currencyDecimalPlaces,
                                          ),
                                    ),
                                    _buildEarningItem(
                                      'futureEarning'.translate(
                                        context: context,
                                      ),
                                      (earningReport
                                                  .futureEarningFromBookings ??
                                              "0")
                                          .replaceAll(',', '')
                                          .toString()
                                          .providerPriceFormat(
                                            context,
                                            currencySymbol:
                                                earningReport.currencySymbol,
                                            decimalPlaces: earningReport
                                                .currencyDecimalPlaces,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        if ((context.watch<FetchBookingsCubit>().state
                                is FetchBookingsSuccess) &&
                            (context.watch<FetchBookingsCubit>().state
                                    as FetchBookingsSuccess)
                                .bookings
                                .isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: CustomText(
                              'pendingBookings'.translate(context: context),
                              fontSize: 18,
                              textAlign: TextAlign.start,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomContainer(
                            height:
                                context.watch<FetchBookingsCubit>().state
                                    is FetchBookingsSuccess
                                ? 290
                                : 0,
                            child: BlocBuilder<FetchBookingsCubit, FetchBookingsState>(
                              builder:
                                  (
                                    BuildContext context,
                                    FetchBookingsState bookingState,
                                  ) {
                                    if (bookingState
                                        is FetchBookingsInProgress) {
                                      return const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 6.0,
                                        ),
                                        child: ShimmerLoadingContainer(
                                          child: CustomShimmerContainer(
                                            width: 170,
                                          ),
                                        ),
                                      );
                                    }

                                    if (bookingState is FetchBookingsSuccess) {
                                      if (bookingState.bookings.isEmpty) {
                                        return const SizedBox.shrink();
                                      }
                                      return SingleChildScrollView(
                                        controller: bookingController,
                                        scrollDirection: Axis.horizontal,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                        ),
                                        child: Row(
                                          children: [
                                            ListView.separated(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  bookingState.bookings.length,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemBuilder:
                                                  (
                                                    BuildContext context,
                                                    int index,
                                                  ) {
                                                    final BookingsModel
                                                    bookingModel = bookingState
                                                        .bookings[index];
                                                    return BlocProvider<
                                                      UpdateBookingStatusCubit
                                                    >(
                                                      create:
                                                          (
                                                            BuildContext
                                                            context,
                                                          ) =>
                                                              UpdateBookingStatusCubit(),
                                                      child: Builder(
                                                        builder: (context) {
                                                          return SizedBox(
                                                            width: 300,
                                                            child: BookingCardContainer(
                                                              bookingModel:
                                                                  bookingModel,
                                                              isFrom: 'home',
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  },
                                              separatorBuilder:
                                                  (
                                                    BuildContext context,
                                                    int index,
                                                  ) =>
                                                      const SizedBox(width: 10),
                                            ),
                                            if (bookingState
                                                .isLoadingMoreBookings)
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                    ),
                                                child:
                                                    CustomCircularProgressIndicator(
                                                      color: Theme.of(
                                                        context,
                                                      ).colorScheme.accentColor,
                                                    ),
                                              ),
                                          ],
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                            ),
                          ),
                        ],
                        if (customJobs.totalOpenJobs! > 0) ...[
                          const SizedBox(height: 10),
                          Container(
                            color: context.colorScheme.secondaryColor,
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomContainer(
                                      height: 50,
                                      width: 50,
                                      borderRadius: UiUtils.borderRadiusOf10,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primaryColor,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 10,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            UiUtils.borderRadiusOf10,
                                          ),
                                          child: const CustomSvgPicture(
                                            svgImage: AppAssets.bagImage,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: SizedBox(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              "jobRequestsForYouLbl".translate(
                                                context: context,
                                              ),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.blackColor,
                                              maxLines: 1,
                                            ),
                                            Row(
                                              children: [
                                                CustomText(
                                                  UiUtils.customRequestCounter,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.blackColor,
                                                ),
                                                const SizedBox(width: 3),
                                                CustomText(
                                                  UiUtils.customRequestCounter
                                                              .toInt() >
                                                          1
                                                      ? "requestsLbl".translate(
                                                          context: context,
                                                        )
                                                      : "requestLbl".translate(
                                                          context: context,
                                                        ),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.blackColor,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    InkWell(
                                      child: CustomText(
                                        "viewAll".translate(context: context),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.blackColor,
                                        maxLines: 1,
                                        showUnderline: true,
                                      ),
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          Routes.jobRequestScreen,
                                          arguments: widget.scrollController,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Column(
                                  children: [
                                    ListView.separated(
                                      shrinkWrap: true,
                                      itemCount: customJobs.openJobs!.length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (BuildContext context, int index) {
                                        final JobRequestModel jobRequestModel =
                                            customJobs.openJobs![index];

                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              Routes.openJobRequestDetails,
                                              arguments: {
                                                'jobRequestModel':
                                                    jobRequestModel,
                                              },
                                            );
                                          },
                                          child: Padding(
                                            padding:
                                                const EdgeInsetsDirectional.only(
                                                  end: 10,
                                                  start: 10,
                                                  top: 5,
                                                ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: SizedBox(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CustomText(
                                                          jobRequestModel
                                                                  .translatedServiceTitle ??
                                                              '',
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .blackColor,
                                                          maxLines: 2,
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        CustomText(
                                                          jobRequestModel
                                                                  .translatedServiceShortDescription ??
                                                              '',
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Theme.of(context)
                                                              .colorScheme
                                                              .lightGreyColor,
                                                          maxLines: 2,
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  CustomContainer(
                                                                    height: 18,
                                                                    width: 18,
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    child: ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            UiUtils.borderRadiusOf50,
                                                                          ),
                                                                      child: CustomCachedNetworkImage(
                                                                        imageUrl:
                                                                            jobRequestModel.image ??
                                                                            '',
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Expanded(
                                                                    child: CustomText(
                                                                      jobRequestModel
                                                                              .username ??
                                                                          '',
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Theme.of(
                                                                        context,
                                                                      ).colorScheme.blackColor,
                                                                      maxLines:
                                                                          1,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            InkWell(
                                                              child: CustomText(
                                                                "view".translate(
                                                                  context:
                                                                      context,
                                                                ),
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Theme.of(context)
                                                                    .colorScheme
                                                                    .blackColor,
                                                                maxLines: 1,
                                                                showUnderline:
                                                                    true,
                                                              ),
                                                              onTap: () {
                                                                Navigator.pushNamed(
                                                                  context,
                                                                  Routes
                                                                      .openJobRequestDetails,
                                                                  arguments: {
                                                                    'jobRequestModel':
                                                                        jobRequestModel,
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                            if (index == 0) {
                                              return const Divider();
                                            } else {
                                              return const SizedBox(height: 10);
                                            }
                                          },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 100),
                      ],
                    ),
                  );
                }
              } else if (settingsState is FetchSystemSettingsFailure) {
                return Center(
                  child: ErrorContainer(
                    onTapRetry: () {
                      context.read<FetchSystemSettingsCubit>().getSettings(
                        isAnonymous: false,
                      );
                    },
                    errorMessage: settingsState.errorMessage.translate(
                      context: context,
                    ),
                  ),
                );
              }
              return ShimmerHomeScreen();
            },
          );
        },
      ),
    );
  }

  Widget _buildEarningItem(String title, String amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: context.colorScheme.accentColor,
          maxLines: 1,
        ),
        const SizedBox(height: 4),
        CustomText(amount, fontSize: 18, fontWeight: FontWeight.w600),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

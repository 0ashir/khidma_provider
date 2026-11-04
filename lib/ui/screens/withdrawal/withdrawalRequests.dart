import 'package:edemand_partner/ui/screens/withdrawal/withDrawalStatusEnum.dart';
import 'package:flutter/material.dart';

import '../../../app/generalImports.dart';

class WithdrawalRequestsScreen extends StatefulWidget {
  const WithdrawalRequestsScreen({super.key});

  @override
  WithdrawalRequestsScreenState createState() =>
      WithdrawalRequestsScreenState();

  static Route<WithdrawalRequestsScreen> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => FetchWithdrawalRequestCubit(),
          ),
          BlocProvider(
            create: (BuildContext context) => SendWithdrawalRequestCubit(),
          ),
          BlocProvider(
            create: (BuildContext context) => GetCustomFieldsCubit(),
          ),
        ],
        child: const WithdrawalRequestsScreen(),
      ),
    );
  }
}

class WithdrawalRequestsScreenState extends State<WithdrawalRequestsScreen>
    with SingleTickerProviderStateMixin {
  late final ScrollController _pageScrollController = ScrollController()
    ..addListener(_pageScrollListen);
  late TabController _tabController;
  final List<String> statuses = WithDrawalStatusEnum.values
      .map((e) => e.name)
      .toList();
  String selectedStatus = "all";
  ValueNotifier<bool> isScrolling = ValueNotifier(false);
  OverlayEntry? overlayEntry;

  @override
  void initState() {
    _tabController = TabController(length: statuses.length, vsync: this);
    fetchWithDrawalRequest();
    context.read<GetCustomFieldsCubit>().fetchCustomFields();
    super.initState();
  }

  @override
  void dispose() {
    isScrolling.dispose();
    overlayEntry?.remove();
    overlayEntry?.dispose();
    super.dispose();
  }

  void fetchWithDrawalRequest() {
    context.read<FetchWithdrawalRequestCubit>().fetchWithdrawals(
      status: selectedStatus,
    );
  }

  void _pageScrollListen() {
    if (_pageScrollController.position.pixels > 7 && !isScrolling.value) {
      isScrolling.value = true;
    } else if (_pageScrollController.position.pixels < 7 && isScrolling.value) {
      isScrolling.value = false;
    }
    if (_pageScrollController.isEndReached()) {
      if (context.read<FetchWithdrawalRequestCubit>().hasMoreData()) {
        context.read<FetchWithdrawalRequestCubit>().fetchMoreWithdrawals(
          status: selectedStatus,
        );
      }
    }
  }

  Widget setTitleAndSubDetails({
    required String title,
    required String subTitle,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: CustomText(
            title.translate(context: context),
            fontSize: 14,
            maxLines: 1,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.blackColor,
          ),
        ),
        const Expanded(child: SizedBox(width: 5)),
        Expanded(
          flex: 6,
          child: CustomText(
            subTitle,
            fontSize: 11,
            maxLines: 3,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.blackColor,
          ),
        ),
      ],
    );
  }

  Widget mainWidget() {
    return Stack(
      children: [
        CustomRefreshIndicator(
          onRefresh: () async {
            fetchWithDrawalRequest();
          },
          child: BlocConsumer<FetchWithdrawalRequestCubit, FetchWithdrawalRequestState>(
            listener: (context, state) {
              if (state is FetchWithdrawalRequestSuccess) {
                // update amount globally
                context.read<FetchSystemSettingsCubit>().updateAmount(
                  state.availableBalance,
                );
              }
            },
            builder: (BuildContext context, FetchWithdrawalRequestState state) {
              if (state is FetchWithdrawalRequestFailure) {
                return Center(
                  child: ErrorContainer(
                    onTapRetry: () {
                      fetchWithDrawalRequest();
                    },
                    errorMessage: state.errorMessage.translate(
                      context: context,
                    ),
                  ),
                );
              }
              if (state is FetchWithdrawalRequestSuccess) {
                return state.withdrawals.isEmpty
                    ? Center(
                        child: NoDataContainer(
                          title: 'noDataFound'.translate(context: context),
                          subTitle: 'noDataFoundSubTitle'.translate(
                            context: context,
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        controller: _pageScrollController,
                        clipBehavior: Clip.none,
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            const SizedBox(height: 130),
                            CustomDivider(
                              indent: 10,
                              endIndent: 10,
                              color: context.colorScheme.lightGreyColor
                                  .withAlpha(50),
                              thickness: 0.5,
                            ),
                            ListView.separated(
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 10,
                              ),
                              itemCount: state.withdrawals.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                final WithdrawalModel withdrawal =
                                    state.withdrawals[index];
                                return CustomContainer(
                                  width: MediaQuery.sizeOf(context).width,
                                  padding: const EdgeInsetsDirectional.all(12),
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondaryColor,
                                  borderRadius: UiUtils.borderRadiusOf10,
                                  boxShadow: [
                                    BoxShadow(
                                      color: context.colorScheme.lightGreyColor
                                          .withAlpha(20),
                                      offset: const Offset(0, 1),
                                      blurRadius: 2,
                                    ),
                                  ],
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            (withdrawal.amount ?? "0")
                                                .replaceAll(',', '')
                                                .toString()
                                                .providerPriceFormat(context),
                                            color:
                                                context.colorScheme.blackColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          CustomText(
                                            withdrawal.createdAt!
                                                .formatDateAndTimeOnlyDate(),
                                            color: context
                                                .colorScheme
                                                .lightGreyColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            "AC/ ${withdrawal.bankDetails!.formatAccountNumber()}",
                                            color: context
                                                .colorScheme
                                                .lightGreyColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          CustomText(
                                            withdrawal.translatedStatus!.trim(),
                                            color: UiUtils.getStatusColor(
                                              context: context,
                                              statusVal: withdrawal.status!
                                                  .trim()
                                                  .toLowerCase(),
                                            ),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const SizedBox(height: 10),
                            ),
                            if (state.isLoadingMore) ...[
                              CustomCircularProgressIndicator(
                                color: Theme.of(
                                  context,
                                ).colorScheme.accentColor,
                              ),
                            ],
                          ],
                        ),
                      );
              }
              return ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                itemCount: 9,
                // Increased by 1 to account for the SizedBox
                physics: const NeverScrollableScrollPhysics(),
                clipBehavior: Clip.none,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return const SizedBox(height: 130);
                  }

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ShimmerLoadingContainer(
                      child: CustomShimmerContainer(
                        height: context.screenHeight * 0.1,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: CustomContainer(
            child: CustomAddButton(
              onTap: () {
                final getCustomFieldsCubit = context
                    .read<GetCustomFieldsCubit>();

                UiUtils.showModelBottomSheets(
                  context: context,
                  enableDrag: true,
                  isScrollControlled: true,
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (BuildContext context) =>
                            SendWithdrawalRequestCubit(),
                      ),
                      BlocProvider.value(value: getCustomFieldsCubit),
                    ],
                    child: const SendWithdrawalRequestBottomsheet(),
                  ),
                );
                return;
              },
              margin: EdgeInsets.only(
                left: 15,
                right: 15,
                top: 10,
                bottom: MediaQuery.of(context).padding.bottom + 10,
              ),
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomSvgPicture(
                    svgImage: AppAssets.add,
                    color: AppColors.whiteColors,
                  ),
                  const SizedBox(width: 10),
                  CustomText(
                    'addNewRequest'.translate(context: context),
                    color: AppColors.whiteColors,
                    fontSize: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ValueListenableBuilder(
            valueListenable: isScrolling,
            builder: (BuildContext context, Object? value, Widget? child) =>
                CustomContainer(
                  color: context.colorScheme.primaryColor,
                  boxShadow: isScrolling.value
                      ? [
                          BoxShadow(
                            offset: const Offset(0, 0.75),
                            spreadRadius: 1,
                            blurRadius: 5,
                            color: Theme.of(
                              context,
                            ).colorScheme.blackColor.withValues(alpha: 0.2),
                          ),
                        ]
                      : [],
                  child: CustomContainer(
                    margin: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 5,
                    ),
                    height: 125,
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 5,
                    ),
                    width: MediaQuery.sizeOf(context).width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'yourBalanceLbl'.translate(context: context),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: context.colorScheme.blackColor,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          (context.watch<FetchSystemSettingsCubit>().state
                                  as FetchSystemSettingsSuccess)
                              .availableAmount
                              .toString()
                              .providerPriceFormat(context),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: context.colorScheme.blackColor,
                          ),
                        ),
                        const SizedBox(height: 15),
                        TabBar(
                          indicatorWeight: 0,
                          dividerHeight: 0,
                          dividerColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                          tabAlignment: TabAlignment.start,
                          indicatorPadding: const EdgeInsets.symmetric(
                            vertical: 5,
                          ),
                          indicatorSize: TabBarIndicatorSize.label,
                          overlayColor: const WidgetStatePropertyAll(
                            Colors.transparent,
                          ),
                          indicator: BoxDecoration(
                            color: context.colorScheme.accentColor,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(UiUtils.borderRadiusOf6),
                            ),
                          ),
                          controller: _tabController,
                          labelColor: context.colorScheme.accentColor,
                          unselectedLabelColor: context.colorScheme.blackColor,
                          tabs: statuses.map((status) {
                            final bool isSelected = status == selectedStatus;
                            return Tab(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18.0,
                                  vertical: 0,
                                ),
                                child: CustomText(
                                  status.translate(context: context),
                                  textAlign: TextAlign.center,
                                  color: isSelected
                                      ? AppColors.whiteColors
                                      : context.colorScheme.blackColor,
                                ),
                              ),
                            );
                          }).toList(),
                          onTap: (index) {
                            setState(() {
                              selectedStatus = statuses[index];
                            });
                            fetchWithDrawalRequest();
                          },
                          isScrollable: true,
                        ),
                      ],
                    ),
                  ),
                ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryColor,
      appBar: UiUtils.getSimpleAppBar(
        statusBarColor: context.colorScheme.secondaryColor,
        context: context,
        elevation: 1,
        title: 'withdrawalRequest'.translate(context: context),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 10),
            child: IconButton(
              onPressed: () {
                if (overlayEntry?.mounted ?? false) {
                  return;
                }
                overlayEntry = OverlayEntry(
                  builder: (BuildContext context) => Positioned.directional(
                    textDirection: Directionality.of(context),
                    end: 10,
                    top: context.screenHeight * .10,
                    child: CustomContainer(
                      width: MediaQuery.sizeOf(context).width * .9,
                      color: Theme.of(context).colorScheme.secondaryColor,
                      borderRadius: UiUtils.borderRadiusOf5,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 0.5,
                          spreadRadius: 0.5,
                          color: context.colorScheme.lightGreyColor,
                        ),
                      ],
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          'withdrawalRequestDescription'.translate(
                            context: context,
                          ),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.blackColor,
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                );

                Overlay.of(context).insert(overlayEntry!);
                Timer(const Duration(seconds: 5), () => overlayEntry!.remove());
              },
              icon: Icon(
                Icons.help_outline_outlined,
                color: Theme.of(context).colorScheme.blackColor,
              ),
            ),
          ),
        ],
      ),
      body: mainWidget(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.bott,
    );
  }
}

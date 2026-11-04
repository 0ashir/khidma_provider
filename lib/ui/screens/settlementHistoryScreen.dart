import 'package:flutter/material.dart';

import '../../app/generalImports.dart';

class SettlementHistoryScreen extends StatefulWidget {
  const SettlementHistoryScreen({super.key});

  @override
  SettlementHistoryScreenState createState() => SettlementHistoryScreenState();

  static Route<SettlementHistoryScreen> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => BlocProvider(
        create: (BuildContext context) => FetchSettlementHistoryCubit(),
        child: const SettlementHistoryScreen(),
      ),
    );
  }
}

class SettlementHistoryScreenState extends State<SettlementHistoryScreen> {
  late final ScrollController _pageScrollController = ScrollController()
    ..addListener(_pageScrollListen);

  ValueNotifier<bool> isScrolling = ValueNotifier(false);
  OverlayEntry? overlayEntry;

  @override
  void initState() {
    context.read<FetchSettlementHistoryCubit>().fetchSettlementHistory();
    super.initState();
  }

  @override
  void dispose() {
    isScrolling.dispose();
    overlayEntry?.remove();
    overlayEntry?.dispose();
    super.dispose();
  }

  void _pageScrollListen() {
    if (_pageScrollController.position.pixels > 7 && !isScrolling.value) {
      isScrolling.value = true;
    } else if (_pageScrollController.position.pixels < 7 && isScrolling.value) {
      isScrolling.value = false;
    }
    if (_pageScrollController.isEndReached()) {
      if (context.read<FetchSettlementHistoryCubit>().hasMoreData()) {
        context
            .read<FetchSettlementHistoryCubit>()
            .fetchMoreSettlementHistory();
      }
    }
  }

  Widget showSettlementHistoryList({
    required List<SettlementModel> settlementData,
    required bool isLoadingMore,
    required String amountReceivable,
  }) {
    return Expanded(
      child: SingleChildScrollView(
        controller: _pageScrollController,
        child: Column(
          children: [
            ListView.separated(
              shrinkWrap: true,
              clipBehavior: Clip.hardEdge,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              itemCount: settlementData.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return CustomContainer(
                  width: MediaQuery.sizeOf(context).width,
                  padding: const EdgeInsetsDirectional.all(12),
                  color: Theme.of(context).colorScheme.secondaryColor,
                  borderRadius: UiUtils.borderRadiusOf10,
                  boxShadow: [
                    BoxShadow(
                      color: context.colorScheme.lightGreyColor.withAlpha(20),
                      offset: const Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            (settlementData[index].amount ?? "0")
                                .replaceAll(',', '')
                                .toString()
                                .providerPriceFormat(
                                  context,
                                  currencySymbol:
                                      settlementData[index].currencySymbol,
                                  decimalPlaces: settlementData[index]
                                      .currencyDecimalPlaces,
                                ),
                            color: context.colorScheme.blackColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          CustomText(
                            settlementData[index].date!.formatDate(),
                            color: context.colorScheme.lightGreyColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CustomText(
                              settlementData[index].message!,
                              color: context.colorScheme.blackColor,
                              fontSize: 12,
                              maxLines: 1,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          CustomText(
                            settlementData[index].translatedStatus.toString(),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.greenColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 10),
            ),
            if (isLoadingMore) ...[
              CustomCircularProgressIndicator(
                color: Theme.of(context).colorScheme.accentColor,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget mainWidget() {
    return CustomRefreshIndicator(
      onRefresh: () async {
        context.read<FetchSettlementHistoryCubit>().fetchSettlementHistory();
      },
      child:
          BlocBuilder<FetchSettlementHistoryCubit, FetchSettlementHistoryState>(
            builder: (BuildContext context, FetchSettlementHistoryState state) {
              if (state is FetchSettlementHistoryFailure) {
                return Center(
                  child: ErrorContainer(
                    onTapRetry: () {
                      context
                          .read<FetchSettlementHistoryCubit>()
                          .fetchSettlementHistory();
                    },
                    errorMessage: state.errorMessage.translate(
                      context: context,
                    ),
                  ),
                );
              }
              if (state is FetchSettlementHistorySuccess) {
                return Column(
                  children: [
                    CustomContainer(
                      height: 95,
                      margin: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 5,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 5,
                      ),
                      width: MediaQuery.sizeOf(context).width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'amountReceivable'.translate(context: context),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: context.colorScheme.blackColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            state.amountReceivable
                                .replaceAll(',', '')
                                .providerPriceFormat(
                                  context,
                                  currencySymbol: state.currencySymbol,
                                  decimalPlaces: state.currencyDecimalPlaces,
                                ),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: context.colorScheme.blackColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          CustomDivider(
                            color: context.colorScheme.lightGreyColor.withAlpha(
                              50,
                            ),
                            thickness: 0.5,
                          ),
                        ],
                      ),
                    ),
                    if (state.settlementDetails.isEmpty) ...[
                      Center(
                        child: NoDataContainer(
                          title: 'settlementHistoryNotFound'.translate(
                            context: context,
                          ),
                          subTitle: 'settlementHistoryNotFoundSubTitle'
                              .translate(context: context),
                        ),
                      ),
                    ] else ...[
                      showSettlementHistoryList(
                        settlementData: state.settlementDetails,
                        isLoadingMore: state.isLoadingMore,
                        amountReceivable: state.amountReceivable,
                      ),
                    ],
                  ],
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                itemCount: 8,
                physics: const NeverScrollableScrollPhysics(),
                clipBehavior: Clip.none,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ShimmerLoadingContainer(
                      child: CustomShimmerContainer(
                        height: context.screenHeight * 0.12,
                      ),
                    ),
                  );
                },
              );
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InterstitialAdWidget(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryColor,
        bottomNavigationBar: const BannerAdWidget(),
        appBar: UiUtils.getSimpleAppBar(
          statusBarColor: context.colorScheme.secondaryColor,
          context: context,
          title: 'settlementHistory'.translate(context: context),
          elevation: 1,
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
                            'settlementDescription'.translate(context: context),
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
                  Timer(
                    const Duration(seconds: 5),
                    () => overlayEntry?.remove(),
                  );
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
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}

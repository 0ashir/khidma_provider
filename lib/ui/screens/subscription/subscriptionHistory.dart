import 'package:edemand_partner/app/generalImports.dart';
import 'package:flutter/material.dart';
import 'package:edemand_partner/ui/widgets/subscriptionAccessGuard.dart';

class SubscriptionHistoryScreen extends StatefulWidget {
  const SubscriptionHistoryScreen({super.key});

  @override
  SubscriptionHistoryScreenState createState() =>
      SubscriptionHistoryScreenState();

  static Route<SubscriptionHistoryScreen> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => const SubscriptionHistoryScreen(),
    );
  }
}

class SubscriptionHistoryScreenState extends State<SubscriptionHistoryScreen> {
  late final ScrollController _pageScrollController = ScrollController()
    ..addListener(_pageScrollListen);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _pageScrollListen() {
    if (_pageScrollController.isEndReached()) {
      if (context.read<FetchPreviousSubscriptionsCubit>().hasMoreData()) {
        context
            .read<FetchPreviousSubscriptionsCubit>()
            .fetchMorePreviousSubscriptions();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!context.watch<FetchSystemSettingsCubit>().subscriptionsEnabled) {
      return const SubscriptionAccessGuard();
    }
    return AnnotatedSafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryColor,
        appBar: UiUtils.getSimpleAppBar(
          context: context,
          elevation: 1,
          title: 'previousSubscriptions'.translate(context: context),
          statusBarColor: context.colorScheme.secondaryColor,
        ),
        body: mainWidget(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  Widget getTitleAndDetails({
    required String title,
    required String subDetails,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title.translate(context: context),
          fontSize: 14,
          color: Theme.of(context).colorScheme.lightGreyColor,
        ),
        const SizedBox(width: 2),
        CustomText(
          subDetails,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Theme.of(context).colorScheme.blackColor,
        ),
      ],
    );
  }

  Widget showPreviousSubscriptionList({
    required List<dynamic> subscriptionsData,
    required bool isLoadingMore,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      controller: _pageScrollController,
      clipBehavior: Clip.none,
      child: Column(
        children: [
          if (subscriptionsData.isEmpty) ...[
            Center(
              child: NoDataContainer(
                title: 'noDataFound'.translate(context: context),
                subTitle: 'noDataFoundSubTitle'.translate(context: context),
              ),
            ),
          ],
          if (subscriptionsData.isNotEmpty) ...[
            Column(
              children: List.generate(
                subscriptionsData.length + (isLoadingMore ? 1 : 0),
                (index) {
                  if (index >= subscriptionsData.length) {
                    return const CustomCircularProgressIndicator();
                  }
                  return SubscriptionDetailsContainer(
                    isActiveSubscription: false,
                    needToShowPaymentStatus: true,
                    isAvailableForPurchase: false,
                    isPreviousSubscription: true,
                    showLoading: false,
                    onBuyButtonPressed: () {},
                    subscriptionDetails: subscriptionsData[index],
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget mainWidget() {
    return CustomRefreshIndicator(
      onRefresh: () async {
        context
            .read<FetchPreviousSubscriptionsCubit>()
            .fetchPreviousSubscriptions();
      },
      child:
          BlocBuilder<
            FetchPreviousSubscriptionsCubit,
            FetchPreviousSubscriptionsState
          >(
            builder: (context, state) {
              if (state is FetchPreviousSubscriptionsFailure) {
                return Center(
                  child: ErrorContainer(
                    onTapRetry: () {
                      context
                          .read<FetchPreviousSubscriptionsCubit>()
                          .fetchPreviousSubscriptions();
                    },
                    errorMessage: state.errorMessage.translate(
                      context: context,
                    ),
                  ),
                );
              }
              if (state is FetchPreviousSubscriptionsSuccess) {
                return state.subscriptionsData.isEmpty
                    ? Center(
                        child: NoDataContainer(
                          title: 'previousSubscriptionsNotFound'.translate(
                            context: context,
                          ),
                          subTitle: 'previousSubscriptionsNotFoundSubTitle'
                              .translate(context: context),
                        ),
                      )
                    : showPreviousSubscriptionList(
                        subscriptionsData: state.subscriptionsData,
                        isLoadingMore: state.isLoadingMoreSubscriptions,
                      );
              }
              return ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                itemCount: 8,
                physics: const NeverScrollableScrollPhysics(),
                clipBehavior: Clip.none,
                itemBuilder: (BuildContext context, int index) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ShimmerLoadingContainer(
                      child: CustomShimmerContainer(height: 300),
                    ),
                  );
                },
              );
            },
          ),
    );
  }
}

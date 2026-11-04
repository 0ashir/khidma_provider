import 'package:flutter/material.dart';

import '../../../app/generalImports.dart';

class HandymanCashCollectionScreen extends StatefulWidget {
  const HandymanCashCollectionScreen({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  State<HandymanCashCollectionScreen> createState() =>
      _HandymanCashCollectionScreenState();
}

class _HandymanCashCollectionScreenState
    extends State<HandymanCashCollectionScreen>
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

  String? _selectedType;
  DateTime? _dateFrom;
  DateTime? _dateTo;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  bool get _hasActiveFilter =>
      _selectedType != null || (_dateFrom != null && _dateTo != null);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_headerScrollListener);
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HandymanCashCollectionCubit>().fetch();
    });
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_headerScrollListener);
    _debounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = _searchController.text.trim();
      context.read<HandymanCashCollectionCubit>().fetch(
        search: query.isEmpty ? null : query,
        type: _selectedType,
        dateFrom: _dateFrom,
        dateTo: _dateTo,
      );
    });
  }

  Future<void> _openFilterSheet() async {
    final result = await UiUtils.showModelBottomSheets(
      context: context,
      child: HandymanCashCollectionFilterBottomSheet(
        initialType: _selectedType,
        initialDateFrom: _dateFrom,
        initialDateTo: _dateTo,
      ),
    );
    if (result == null || result is! Map) return;

    setState(() {
      _selectedType = result['type'] as String?;
      _dateFrom = result['dateFrom'] as DateTime?;
      _dateTo = result['dateTo'] as DateTime?;
    });

    final query = _searchController.text.trim();
    context.read<HandymanCashCollectionCubit>().fetch(
      search: query.isEmpty ? null : query,
      type: _selectedType,
      dateFrom: _dateFrom,
      dateTo: _dateTo,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                    minExtent: 240,
                    maxExtent: 250,
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, _) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                CustomText(
                                  'cashCollection'.translate(context: context),
                                  fontSize: fontAnimation.value,
                                  fontWeight: FontWeight.bold,
                                  color: context.colorScheme.blackColor,
                                ),
                                BlocBuilder<
                                  HandymanCashCollectionCubit,
                                  HandymanCashCollectionState
                                >(
                                  builder: (context, state) {
                                    if (state
                                        is HandymanCashCollectionSuccess) {
                                      return HeadingAmountAnimation(
                                        key: ValueKey(state.total),
                                        text:
                                            '${state.total} ${'cashCollection'.translate(context: context)}',
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
                            BlocBuilder<
                              HandymanCashCollectionCubit,
                              HandymanCashCollectionState
                            >(
                              builder: (context, state) {
                                final summary =
                                    state is HandymanCashCollectionSuccess
                                    ? state.summary
                                    : null;
                                final isLoading =
                                    state is HandymanCashCollectionInProgress;
                                return _SummaryCard(
                                  summary: summary,
                                  isLoading: isLoading,
                                );
                              },
                            ),
                            _buildFilterRow(),
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
      onRefresh: () async =>
          context.read<HandymanCashCollectionCubit>().refresh(),
      child:
          BlocBuilder<HandymanCashCollectionCubit, HandymanCashCollectionState>(
            builder: (context, state) {
              if (state is HandymanCashCollectionInProgress) {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 6,
                  ),
                  itemCount: 6,
                  itemBuilder: (_, __) => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: ShimmerLoadingContainer(
                      child: CustomShimmerContainer(
                        height: 90,
                        borderRadius: UiUtils.borderRadiusOf10,
                      ),
                    ),
                  ),
                );
              }

              if (state is HandymanCashCollectionFailure) {
                return Center(
                  child: ErrorContainer(
                    errorMessage: state.errorMessage,
                    onTapRetry: () =>
                        context.read<HandymanCashCollectionCubit>().fetch(),
                  ),
                );
              }

              if (state is HandymanCashCollectionSuccess) {
                if (state.rows.isEmpty) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: context.screenHeight * 0.5,
                        child: Center(
                          child: NoDataContainer(
                            title: 'noDataFound'.translate(context: context),
                            subTitle: 'noDataFoundSubTitle'.translate(
                              context: context,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                final showExtra = state.isLoadingMore || state.hasError;
                return NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollEndNotification &&
                        notification.metrics.extentAfter == 0 &&
                        context
                            .read<HandymanCashCollectionCubit>()
                            .hasMoreData()) {
                      context.read<HandymanCashCollectionCubit>().fetchMore();
                    }
                    return false;
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: state.rows.length + (showExtra ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == state.rows.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                            child: CustomLoadingMoreContainer(
                              isError: state.isLoadingMore,
                          onErrorButtonPressed: () {
                            context
                                .read<HandymanCashCollectionCubit>()
                                .fetchMore();
                          }
                            ),
                          ),
                        );
                      }
                      return _CollectionRow(item: state.rows[index]);
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
    );
  }

  Widget _buildFilterRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CustomTextFormField(
              controller: _searchController,
              hintText: 'search'.translate(context: context),
              textInputAction: TextInputAction.search,
              isDense: true,
              suffixIcon: Icon(
                Icons.search,
                color: context.colorScheme.accentColor,
              ),
              borderColor: context.colorScheme.lightGreyColor.withValues(
                alpha: 0.4,
              ),
            ),
          ),
          const SizedBox(width: 10),
          CustomInkWellContainer(
            onTap: _openFilterSheet,
            child: CustomContainer(
              height: 48,
              width: 48,
              borderRadius: UiUtils.borderRadiusOf10,
              border: Border.all(
                color: context.colorScheme.lightGreyColor.withValues(
                  alpha: 0.4,
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Center(
                    child: Icon(
                      Icons.filter_list,
                      color: context.colorScheme.accentColor,
                    ),
                  ),
                  if (_hasActiveFilter)
                    const Positioned(
                      top: 8,
                      right: 8,
                      child: CustomContainer(
                        height: 8,
                        width: 8,
                        shape: BoxShape.circle,
                        color: AppColors.redColor,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.summary, required this.isLoading});

  final HandymanCashCollectionSummary? summary;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 12, 15, 4),
      child: CustomContainer(
        borderRadius: UiUtils.borderRadiusOf10,
        color: context.colorScheme.accentColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: isLoading || summary == null
            ? const ShimmerLoadingContainer(
                child: CustomShimmerContainer(
                  height: 52,
                  borderRadius: UiUtils.borderRadiusOf10,
                ),
              )
            : Row(
                children: [
                  Expanded(
                    child: _SummaryItem(
                      label: 'overallTotal'.translate(context: context),
                      value: summary!.overallTotal
                          .toString()
                          .providerPriceFormat(
                            context,
                            currencySymbol: summary!.currency,
                            decimalPlaces: summary!.currencyDecimalPlaces,
                          ),
                      valueColor: AppColors.whiteColors,
                      labelColor: AppColors.whiteColors.withValues(alpha: 0.75),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: AppColors.whiteColors.withValues(alpha: 0.3),
                  ),
                  Expanded(
                    child: _SummaryItem(
                      label: 'outstandingTotal'.translate(context: context),
                      value: summary!.outstandingTotal
                          .toString()
                          .providerPriceFormat(
                            context,
                            currencySymbol: summary!.currency,
                            decimalPlaces: summary!.currencyDecimalPlaces,
                          ),
                      valueColor: AppColors.whiteColors,
                      labelColor: AppColors.whiteColors.withValues(alpha: 0.75),
                      align: TextAlign.end,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.labelColor,
    this.align = TextAlign.start,
  });

  final String label;
  final String value;
  final Color valueColor;
  final Color labelColor;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: align == TextAlign.end
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          CustomText(
            label,
            fontSize: 11,
            color: labelColor,
            fontWeight: FontWeight.w400,
          ),
          const SizedBox(height: 4),
          CustomText(
            value,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ],
      ),
    );
  }
}

class _CollectionRow extends StatelessWidget {
  const _CollectionRow({required this.item});

  final HandymanCashCollectionModel item;

  @override
  Widget build(BuildContext context) {
    final isCollection = item.isCollection;
    final typeColor = isCollection
        ? AppColors.greenColor
        : AppColors.starRatingColor;
    final typeBg = typeColor.withValues(alpha: 0.1);

    return GestureDetector(
      onTap: () {
        final orderId = item.orderId;
        if (orderId != null && orderId.isNotEmpty) {
          Navigator.pushNamed(
            context,
            Routes.handymanBookingDetails,
            arguments: orderId,
          );
        }
      },
      child: CustomContainer(
        borderRadius: UiUtils.borderRadiusOf10,
        color: context.colorScheme.secondaryColor,
        padding: const EdgeInsets.all(12),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.lightGreyColor.withValues(alpha: 0.15),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type badge
                CustomContainer(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  borderRadius: UiUtils.borderRadiusOf5,
                  color: typeBg,
                  child: CustomText(
                    item.type.capitalize(),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: typeColor,
                  ),
                ),
                const Spacer(),
                // Amount
                CustomText(
                  item.amount.toString().providerPriceFormat(
                    context,
                    currencySymbol: item.currency,
                    decimalPlaces: item.currencyDecimalPlaces,
                  ),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isCollection
                      ? AppColors.greenColor
                      : context.colorScheme.blackColor,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (item.customerName != null &&
                    item.customerName!.isNotEmpty) ...[
                  CustomSvgPicture(
                    svgImage: AppAssets.user,
                    height: 12,
                    width: 12,
                    color: context.colorScheme.lightGreyColor,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: CustomText(
                      item.customerName!,
                      fontSize: 12,
                      color: context.colorScheme.blackColor,
                      fontWeight: FontWeight.w500,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                if (item.orderId != null && item.orderId!.isNotEmpty) ...[
                  CustomText(
                    '#${item.orderId}',
                    fontSize: 12,
                    color: context.colorScheme.accentColor,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ],
            ),
            if (item.message != null && item.message!.isNotEmpty) ...[
              const SizedBox(height: 4),
              CustomText(
                item.message!,
                fontSize: 11,
                color: context.colorScheme.lightGreyColor,
                maxLines: 2,
              ),
            ],
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (item.dateOfService != null &&
                    item.dateOfService!.isNotEmpty)
                  Row(
                    children: [
                      CustomSvgPicture(
                        svgImage: AppAssets.bCalender,
                        height: 11,
                        width: 11,
                        color: context.colorScheme.lightGreyColor,
                      ),
                      const SizedBox(width: 3),
                      CustomText(
                        item.dateOfService!.formatDateAndTimeOnlyDate(),
                        fontSize: 11,
                        color: context.colorScheme.lightGreyColor,
                      ),
                    ],
                  )
                else
                  const SizedBox.shrink(),
                CustomText(
                  item.createdAt.formatDateAndTime(),
                  fontSize: 11,
                  color: context.colorScheme.lightGreyColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

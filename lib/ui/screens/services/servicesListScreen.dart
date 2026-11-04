import 'package:edemand_partner/ui/screens/services/enum/sortOrderEnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import '../../../app/generalImports.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  ServicesScreenState createState() => ServicesScreenState();
}

class ServicesScreenState extends State<ServicesScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  double? minFilterRange;
  double? maxFilterRange;

  double _bottomPadding = 50.0;
  bool _showFloatingButton = true;

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

  void scrollListener() {
    _animationController.value = UiUtils.inRange(
      currentValue: widget.scrollController.offset,
      minValue: widget.scrollController.position.minScrollExtent,
      maxValue: widget.scrollController.position.maxScrollExtent,
      newMaxValue: 1.0,
      newMinValue: 0.0,
    );

    // Check if we're at the top (within 50px threshold)
    final bool isAtTop = widget.scrollController.offset <= 50;

    if (isAtTop) {
      // Always show button when at top
      if (_bottomPadding != 50.0 || _showFloatingButton != true) {
        setState(() {
          _bottomPadding = 50.0;
          _showFloatingButton = true;
        });
        _floatingButtonAnimationController.forward();
      }
    } else if (widget.scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_bottomPadding != 10.0 || _showFloatingButton != false) {
        setState(() {
          _bottomPadding = 10.0;
          _showFloatingButton = false;
        });
        _floatingButtonAnimationController.reverse();
      }
    } else if (widget.scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (_bottomPadding != 50.0 || _showFloatingButton != true) {
        setState(() {
          _bottomPadding = 50.0;
          _showFloatingButton = true;
        });
        _floatingButtonAnimationController.forward();
      }
    }
  }

  String prevVal = '';

  Timer? _searchDelay;
  String previouseSearchQuery = '';
  final ScrollController searchScrollController = ScrollController();
  bool searchTap = false;
  bool isSearching = false;
  bool isFiltering = false;
  SortOrder rating = SortOrder.none;
  SortOrder pricing = SortOrder.none;
  SortOrder booking = SortOrder.none;

  late TextEditingController searchController = TextEditingController()
    ..addListener(searchServiceListener);

  late final AnimationController _filterButtonOpacityAnimation =
      AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );

  late final AnimationController _floatingButtonAnimationController =
      AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      );

  late Animation<double> _floatingButtonAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _floatingButtonAnimationController,
          curve: Curves.easeInOut,
        ),
      );

  @override
  void initState() {
    widget.scrollController.addListener(scrollListener);
    getServices();
    context.read<FetchServiceCategoryCubit>().fetchCategories();
    context.read<FetchTaxesCubit>().fetchTaxes();
    _resetFloatingButton();
    _checkInitialScrollPosition();
    super.initState();
  }

  void _resetFloatingButton() {
    setState(() {
      _showFloatingButton = true;
      _bottomPadding = 50.0;
    });
    _floatingButtonAnimationController.forward();
  }

  void _checkInitialScrollPosition() {
    // Check if we're near the top when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.scrollController.hasClients) {
        final bool isAtTop = widget.scrollController.offset <= 50;
        if (isAtTop && !_showFloatingButton) {
          _resetFloatingButton();
        }
      }
    });
  }

  void getServices() {
    final Map<String, String> params = getSortParameter();

    context.read<FetchServicesCubit>().fetchServices(
      order: params['order'],
      sort: params['sort'],
    );
  }

  String getSortBy() {
    if (rating != SortOrder.none) {
      return "average_rating";
    } else if (pricing != SortOrder.none) {
      return "price";
    } else if (booking != SortOrder.none) {
      return "total_bookings";
    }
    return '';
  }

  String getSortOrder() {
    if (rating != SortOrder.none) {
      return rating == SortOrder.ascending ? "asc" : "desc";
    } else if (pricing != SortOrder.none) {
      return pricing == SortOrder.ascending ? "asc" : "desc";
    } else if (booking != SortOrder.none) {
      return booking == SortOrder.ascending ? "asc" : "desc";
    }
    return '';
  }

  Map<String, String> getSortParameter() {
    final String sortBy = getSortBy();
    final String sortOrder = getSortOrder();

    if (sortBy.isNotEmpty && sortOrder.isNotEmpty) {
      return {"sort": sortBy, "order": sortOrder};
    }
    return {};
  }

  void searchServiceListener() {
    _searchDelay?.cancel();
    searchCallAfterDelay();
  }

  void searchCallAfterDelay() {
    _searchDelay = Timer(const Duration(milliseconds: 500), searchService);
  }

  Future<void> searchService() async {
    if (searchController.text.isNotEmpty || previouseSearchQuery != '') {
      if (previouseSearchQuery != searchController.text) {
        final Map<String, String> params = getSortParameter();
        context.read<FetchServicesCubit>().searchService(
          order: params['order'],
          sort: params['sort'],
          searchController.text,
        );
        previouseSearchQuery = searchController.text;
      }
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    searchScrollController.dispose();
    _animationController.dispose();
    _floatingButtonAnimationController.dispose();
    widget.scrollController.removeListener(scrollListener);
    widget.scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: UiUtils.getSystemUiOverlayStyle(context: context),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).colorScheme.primaryColor,
          body: Stack(
            children: [
              NestedScrollView(
                controller: widget.scrollController,
                headerSliverBuilder: (context, _) {
                  return [
                    SliverPersistentHeader(
                      delegate: LongAppBarPersistentHeaderDelegate(
                        child: Center(
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
                                        'serviceTab'.translate(
                                          context: context,
                                        ),
                                        fontSize: fontAnimation.value,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.blackColor,
                                      ),
                                      context.watch<FetchServicesCubit>().state
                                              is FetchServicesSuccess
                                          ? HeadingAmountAnimation(
                                              key: ValueKey(
                                                (context
                                                            .read<
                                                              FetchServicesCubit
                                                            >()
                                                            .state
                                                        as FetchServicesSuccess)
                                                    .total,
                                              ),
                                              text:
                                                  '${(context.read<FetchServicesCubit>().state as FetchServicesSuccess).total.toString()} ${'serviceTab'.translate(context: context)}',
                                              textStyle: TextStyle(
                                                color: context
                                                    .colorScheme
                                                    .lightGreyColor,
                                                fontWeight: FontWeight.w400,
                                                fontSize: fontAnimation2.value,
                                              ),
                                            )
                                          : SizedBox(
                                              width:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.7,
                                              height: fontAnimation2.value,
                                            ),
                                      const SizedBox(height: 10),
                                      const CustomShadowLineForDevider(
                                        direction:
                                            ShadowDirection.centerToSides,
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 5,
                                    ),
                                    child: topWidget(),
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
                body: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification notification) {
                    if (notification is ScrollUpdateNotification) {
                      final direction = notification.scrollDelta ?? 0;
                      final bool isAtTop = widget.scrollController.offset <= 50;

                      if (isAtTop) {
                        // Always show button when at top
                        if (_bottomPadding != 50.0 ||
                            _showFloatingButton != true) {
                          setState(() {
                            _bottomPadding = 50.0;
                            _showFloatingButton = true;
                          });
                          _floatingButtonAnimationController.forward();
                        }
                      } else if (direction > 0) {
                        if (_bottomPadding != 10.0 ||
                            _showFloatingButton != false) {
                          setState(() {
                            _bottomPadding = 10.0;
                            _showFloatingButton = false;
                          });
                          _floatingButtonAnimationController.reverse();
                        }
                      } else if (direction < 0) {
                        if (_bottomPadding != 50.0 ||
                            _showFloatingButton != true) {
                          setState(() {
                            _bottomPadding = 50.0;
                            _showFloatingButton = true;
                          });
                          _floatingButtonAnimationController.forward();
                        }
                      }
                    }
                    if (notification is ScrollEndNotification &&
                        notification.metrics.extentAfter == 0) {
                      if (widget.scrollController.isEndReached()) {
                        if (context
                            .read<FetchServicesCubit>()
                            .hasMoreServices()) {
                          final Map<String, String> params = getSortParameter();
                          context.read<FetchServicesCubit>().fetchMoreServices(
                            order: params['order'],
                            sort: params['sort'],
                          );
                        }
                      }
                    }
                    return false;
                  },
                  child: mainWidget(),
                ),
              ),
              AnimatedBuilder(
                animation: _floatingButtonAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, 1 - _floatingButtonAnimation.value),
                    child: Opacity(
                      opacity: _floatingButtonAnimation.value,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: AnimatedPadding(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          padding: EdgeInsets.only(
                            bottom: _bottomPadding,
                            left: 15,
                            right: 15,
                          ),
                          child: const AddFloatingButton(
                            routeNm: Routes.createService,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget topWidget() {
    return BlocConsumer<FetchServicesCubit, FetchServicesState>(
      listener: (BuildContext context, FetchServicesState state) {
        if (state is FetchServicesSuccess) {
          _filterButtonOpacityAnimation.forward();
          // Check scroll position and show button if at top
          _checkInitialScrollPosition();
        }
      },
      builder: (BuildContext context, FetchServicesState state) {
        return Padding(
          padding: const EdgeInsetsDirectional.only(top: 10, start: 20),
          child: SingleChildScrollView(
            controller: searchScrollController,
            physics: isFiltering
                ? const AlwaysScrollableScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _customButton(
                  svg: isFiltering ? AppAssets.close : AppAssets.filter,
                  bgColor: isFiltering
                      ? context.colorScheme.secondaryColor
                      : searchTap
                      ? context.colorScheme.accentColor
                      : context.colorScheme.accentColor.withValues(alpha: 0.12),
                  svgColor: isFiltering
                      ? context.colorScheme.blackColor
                      : searchTap
                      ? context.colorScheme.secondaryColor
                      : context.colorScheme.accentColor,
                ),
                Stack(
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        _buildFilterButton(
                          svgColor: rating.svgColor(context),
                          svg: rating.asset,
                          bgColor: rating.backgroundColor(context),
                          text: 'ratings'.translate(context: context),
                          onTap: () {
                            setState(() {
                              rating = SortOrder.values[(rating.index + 1) % 3];
                              pricing = SortOrder.none;
                              booking = SortOrder.none;
                              getServices();
                            });
                          },
                        ),
                        const SizedBox(width: 10),
                        _buildFilterButton(
                          svgColor: pricing.svgColor(context),
                          svg: pricing.asset,
                          bgColor: pricing.backgroundColor(context),
                          text: 'pricing'.translate(context: context),
                          onTap: () {
                            setState(() {
                              pricing =
                                  SortOrder.values[(pricing.index + 1) % 3];
                              rating = SortOrder.none;
                              booking = SortOrder.none;
                              getServices();
                            });
                          },
                        ),
                        const SizedBox(width: 10),
                        _buildFilterButton(
                          svgColor: booking.svgColor(context),
                          svg: booking.asset,
                          bgColor: booking.backgroundColor(context),
                          text: 'booking'.translate(context: context),
                          onTap: () {
                            setState(() {
                              booking =
                                  SortOrder.values[(booking.index + 1) % 3];
                              pricing = SortOrder.none;
                              rating = SortOrder.none;
                              getServices();
                            });
                          },
                        ),
                        const SizedBox(width: 10),
                        _customButton(
                          svg: AppAssets.search,
                          bgColor: context.colorScheme.secondaryColor,
                          svgColor: Theme.of(
                            context,
                          ).colorScheme.lightGreyColor,
                          borderColor: context.colorScheme.lightGreyColor,
                          onTap: () {
                            searchScrollController.animateTo(
                              0.0,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                            return SlideTransition(
                              position:
                                  Directionality.of(
                                    context,
                                  ).toString().contains(
                                    TextDirection.RTL.value.toLowerCase(),
                                  )
                                  ? Tween<Offset>(
                                      begin: const Offset(-1, 0),
                                      end: Offset.zero,
                                    ).animate(animation)
                                  : Tween<Offset>(
                                      begin: const Offset(1, 0),
                                      end: Offset.zero,
                                    ).animate(animation),
                              child: child,
                            );
                          },
                      child: isFiltering
                          ? const SizedBox.shrink(key: ValueKey('hidden'))
                          : _searchBar(key: const ValueKey('searchBar')),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _customButton({
    required String svg,
    Color? bgColor,
    Color? svgColor,
    VoidCallback? onTap,
    Color? borderColor,
  }) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
        setState(() {
          isFiltering = !isFiltering;
          isSearching = !isSearching;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: 40,
        width: 40,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: borderColor != null
              ? Border.all(
                  color: borderColor.withValues(alpha: 0.5),
                  width: 0.5,
                )
              : null,
          color: bgColor ?? const Color(0XFF212121).withAlpha(50),
          borderRadius: BorderRadius.circular(6),
        ),
        child: CustomSvgPicture(svgImage: svg, color: svgColor),
      ),
    );
  }

  Widget _searchBar({Key? key}) {
    return ColoredBox(
      key: key,
      color: context.colorScheme.primaryColor,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(end: 50),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 40,
          width: MediaQuery.of(context).size.width / 1.32,
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(UiUtils.borderRadiusOf6),
            border: Border.all(
              color: searchTap
                  ? context.colorScheme.accentColor
                  : context.colorScheme.lightGreyColor,
            ),
            color: searchTap
                ? context.colorScheme.accentColor.withValues(alpha: 0.05)
                : context.colorScheme.secondaryColor,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: TextFormField(
            onTap: () {
              setState(() {
                searchTap = true;
                isSearching = true;
              });
            },
            onTapOutside: (event) {
              setState(() {
                searchTap = false;
                isSearching = false;
              });
            },
            controller: searchController,
            style: TextStyle(
              fontSize: 15,
              color: context.colorScheme.blackColor,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 7,
                horizontal: 10,
              ),
              border: InputBorder.none,
              fillColor: Theme.of(context).colorScheme.blackColor,
              hintText: 'searchServicesLbl'.translate(context: context),
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.lightGreyColor,
                fontSize: 15,
              ),
              prefixIcon: CustomSvgPicture(
                svgImage: AppAssets.search,
                color: Theme.of(
                  context,
                ).colorScheme.blackColor.withValues(alpha: 0.7),
              ),
            ),
            textAlignVertical: TextAlignVertical.center,
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
              setState(() {
                isSearching = false;
                searchTap = false;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton({
    required String svg,
    required String text,
    Color? bgColor,
    Color? svgColor,
    VoidCallback? onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color:
            bgColor ?? context.colorScheme.accentColor.withValues(alpha: 0.05),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: CustomContainer(
          borderRadius: UiUtils.borderRadiusOf6,
          color:
              bgColor ??
              context.colorScheme.accentColor.withValues(alpha: 0.05),
          gradient: bgColor == null
              ? null
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    context.colorScheme.accentColor,
                    context.colorScheme.accentColor.withValues(alpha: 0.05),
                    Colors.transparent,
                    Colors.transparent,
                    context.colorScheme.accentColor.withValues(alpha: 0.05),
                    context.colorScheme.accentColor,
                  ],
                  stops: const [0.03, 0.25, 0.3, 0.7, 0.75, 0.97],
                  transform: const GradientRotation(0.5),
                ),
          child: CustomContainer(
            margin: const EdgeInsets.all(2),
            color: context.colorScheme.secondaryColor,
            borderRadius: UiUtils.borderRadiusOf6,
            child: CustomContainer(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              color:
                  bgColor ??
                  context.colorScheme.accentColor.withValues(alpha: 0.05),
              borderRadius: UiUtils.borderRadiusOf6,
              child: Row(
                children: [
                  CustomText(text, fontSize: 14, fontWeight: FontWeight.w400),
                  CustomSvgPicture(svgImage: svg, color: svgColor),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getTitleAndSubDetails({
    required String title,
    required String subDetails,
    bool? showRatingIcon,
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
        Row(
          children: [
            Visibility(
              visible: showRatingIcon ?? false,
              child: const Icon(
                Icons.star_outlined,
                color: AppColors.starRatingColor,
                size: 20,
              ),
            ),
            CustomText(
              subDetails,
              fontSize: 14,
              maxLines: 2,
              color: Theme.of(context).colorScheme.blackColor,
            ),
          ],
        ),
      ],
    );
  }

  Widget mainWidget() {
    return BlocListener<DeleteServiceCubit, DeleteServiceState>(
      listener: (BuildContext context, DeleteServiceState deleteServiceState) {
        if (deleteServiceState is DeleteServiceSuccess) {
          Navigator.pop(context);
          context.read<FetchServicesCubit>().deleteServiceFromCubit(
            deleteServiceState.id,
          );
          UiUtils.showMessage(
            context,
            'serviceDeletedSuccessfully',
            ToastificationType.success,
          );
        }
        if (deleteServiceState is DeleteServiceFailure) {
          UiUtils.showMessage(
            context,
            deleteServiceState.errorMessage,
            ToastificationType.error,
          );
        }
      },
      child: CustomRefreshIndicator(
        onRefresh: () async {
          getServices();
          context.read<FetchTaxesCubit>().fetchTaxes();
          context.read<FetchServiceCategoryCubit>().fetchCategories();
          // Always show floating button on refresh
          _resetFloatingButton();
        },
        child: BlocBuilder<FetchServicesCubit, FetchServicesState>(
          builder: (BuildContext context, FetchServicesState state) {
            if (state is FetchServicesFailure) {
              return Center(
                child: ErrorContainer(
                  onTapRetry: () {
                    getServices();
                    context.read<FetchTaxesCubit>().fetchTaxes();
                  },
                  errorMessage: state.errorMessage.translate(context: context),
                ),
              );
            }
            if (state is FetchServicesSuccess) {
              if (state.services.isEmpty) {
                return Center(
                  child: NoDataContainer(
                    title: 'noDataFound'.translate(context: context),
                    subTitle: 'noDataFoundSubTitle'.translate(context: context),
                  ),
                );
              }
              return SingleChildScrollView(
                clipBehavior: Clip.hardEdge,
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(
                        bottom: 120,
                        left: 15,
                        right: 15,
                        top: 15,
                      ),
                      itemCount: state.services.length,
                      physics: const NeverScrollableScrollPhysics(),
                      clipBehavior: Clip.hardEdge,
                      itemBuilder: (BuildContext context, int index) {
                        final ServiceModel service = state.services[index];

                        return ServiceContainer(
                          onTap: () {
                            // Log service tap
                            ClarityService.logAction(
                              ClarityActions.serviceTapped,
                              {
                                'service_id': service.id ?? '',
                                'service_name': service.title ?? '',
                                'service_price': service.price ?? '',
                                'category_id': service.categoryId ?? '',
                                'category_name': service.categoryName ?? '',
                              },
                            );

                            Navigator.pushNamed(
                              context,
                              Routes.serviceDetails,
                              arguments: {'serviceModel': service},
                            );
                          },
                          listingUI: true,
                          service: service,
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(height: 10),
                    ),
                    if (state.isLoadingMoreServices)
                      CustomCircularProgressIndicator(
                        color: Theme.of(context).colorScheme.accentColor,
                      ),
                  ],
                ),
              );
            }
            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              clipBehavior: Clip.none,
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    addAutomaticKeepAlives: false,
                    addRepaintBoundaries: false,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsetsDirectional.all(16),
                    itemCount: 8,
                    itemBuilder: (BuildContext context, int index) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.0),
                        child: ShimmerLoadingContainer(
                          child: CustomShimmerContainer(height: 150),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

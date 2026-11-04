import 'package:flutter/material.dart';

import '../../app/generalImports.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  CategoriesState createState() => CategoriesState();

  static Route<Categories> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => FetchCategoriesCubit(),
          ),
        ],
        child: const Categories(),
      ),
    );
  }
}

class CategoriesState extends State<Categories> {
  DateTime currDate = DateTime.now();
  TimeOfDay currTime = TimeOfDay.now();
  late final ScrollController _pageScrollController = ScrollController()
    ..addListener(_pageScrollListen);
  late Map categoryStatus = {
    '0': 'deactive'.translate(context: context),
    '1': 'active'.translate(context: context),
  };
  late List<String> selectedCategoryIds = context
      .read<ProviderDetailsCubit>()
      .getSubscribedCategories();

  // Track collapsed categories (all expanded by default)
  Set<String> collapsedCategoryIds = {};

  void _pageScrollListen() {
    if (_pageScrollController.isEndReached()) {
      if (context.read<FetchCategoriesCubit>().hasMoreCategories()) {
        context.read<FetchCategoriesCubit>().fetchMoreCategories();
      }
    }
  }

  @override
  void initState() {
    context.read<FetchCategoriesCubit>().fetchCategories();
    context.read<ProviderDetailsCubit>().providerDetails;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    categoryStatus = {
      '0': 'deactive'.translate(context: context),
      '1': 'active'.translate(context: context),
    };
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedSafeArea(
      isAnnotated: true,
      child: PopScope(
        canPop:
            context.watch<ManageCategoryPreferenceCubit>().state
                is! ManageCategoryPreferenceInProgress,
        child: InterstitialAdWidget(
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primaryColor,
            appBar: AppBar(
              elevation: 1,
              backgroundColor: Theme.of(context).colorScheme.secondaryColor,
              surfaceTintColor: Theme.of(context).colorScheme.secondaryColor,
              title: CustomText(
                'subscribeCategoriesLbl'.translate(context: context),
                color: Theme.of(context).colorScheme.blackColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              leading: CustomBackArrow(
                canGoBack:
                    context.watch<ManageCategoryPreferenceCubit>().state
                        is! ManageCategoryPreferenceInProgress,
              ),
            ),
            bottomNavigationBar: const BannerAdWidget(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: bottomBarWidget(),
            body: mainWidget(),
          ),
        ),
      ),
    );
  }

  Widget bottomBarWidget() {
    return BlocConsumer<
      ManageCategoryPreferenceCubit,
      ManageCategoryPreferenceState
    >(
      listener: (context, state) {
        if (state is ManageCategoryPreferenceFailure) {
          UiUtils.showMessage(
            context,
            'selectCategory',
            ToastificationType.error,
          );
        } else if (state is ManageCategoryPreferenceSuccess) {
          context
              .read<ProviderDetailsCubit>()
              .updateProviderCustomJobCategories(selectedCategoryIds);

          UiUtils.showMessage(
            context,
            'categoryUpdated',
            ToastificationType.success,
            onMessageClosed: () {
              // Additional actions if needed after success
            },
          );
        }
      },
      builder: (context, state) {
        final bool isLoading = state is ManageCategoryPreferenceInProgress;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CustomRoundedButton(
            textSize: 15,
            widthPercentage: 1,
            backgroundColor: Theme.of(context).colorScheme.accentColor,
            buttonTitle: 'subscribeCategoriesLbl'.translate(context: context),
            showBorder: false,
            child: isLoading
                ? Center(
                    child: CustomCircularProgressIndicator(
                      color: AppColors.whiteColors,
                    ),
                  )
                : null,
            onTap: () {
              if (isLoading) {
                return;
              }
              context
                  .read<ManageCategoryPreferenceCubit>()
                  .ManageCategoryPreference(categoryId: selectedCategoryIds);
            },
          ),
        );
      },
    );
  }

  Widget mainWidget() {
    return CustomRefreshIndicator(
      onRefresh: () async {
        context.read<FetchCategoriesCubit>().fetchCategories();
      },
      child: BlocBuilder<FetchCategoriesCubit, FetchCategoriesState>(
        builder: (BuildContext context, FetchCategoriesState state) {
          if (state is FetchCategoriesFailure) {
            return Center(
              child: ErrorContainer(
                onTapRetry: () {
                  context.read<FetchCategoriesCubit>().fetchCategories();
                },
                errorMessage: state.errorMessage.translate(context: context),
              ),
            );
          }

          if (state is FetchCategoriesSuccess) {
            if (state.categories.isEmpty) {
              return NoDataContainer(
                title: 'noDataFound'.translate(context: context),
                subTitle: 'noDataFoundSubTitle'.translate(context: context),
              );
            }
            return SingleChildScrollView(
              controller: _pageScrollController,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              clipBehavior: Clip.none,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  ListView.builder(
                    padding: const EdgeInsets.only(bottom: 60),
                    shrinkWrap: true,
                    itemCount: state.categories.length,
                    physics: const NeverScrollableScrollPhysics(),
                    clipBehavior: Clip.none,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildCategoryTile(
                        category: state.categories[index],
                        depth: 0,
                      );
                    },
                  ),
                  if (state.isLoadingMoreCategories)
                    CustomCircularProgressIndicator(
                      color: AppColors.whiteColors,
                    ),
                ],
              ),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: 8,
            physics: const NeverScrollableScrollPhysics(),
            clipBehavior: Clip.none,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ShimmerLoadingContainer(
                  child: CustomShimmerContainer(
                    height: context.screenHeight * 0.19,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCategoryTile({
    required CategoryModel category,
    required int depth,
  }) {
    final bool isSelected = selectedCategoryIds.contains(category.id);
    final bool hasChildren =
        category.subCategories != null && category.subCategories!.isNotEmpty;
    final bool isExpanded = !collapsedCategoryIds.contains(category.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsetsDirectional.only(
            bottom: 10,
            start: (depth * 12).clamp(0, 48).toDouble(),
          ),
          child: GestureDetector(
            onTap: () {
              // Log category tap
              ClarityService.logAction(ClarityActions.categoryTapped, {
                'category_id': category.id ?? '',
                'category_name': category.translatedName ?? '',
              });

              if (selectedCategoryIds.contains(category.id)) {
                selectedCategoryIds.remove(category.id);
              } else {
                selectedCategoryIds.add(category.id!);
              }
              setState(() {});
            },
            child: CustomContainer(
              padding: const EdgeInsetsDirectional.all(10),
              color: Theme.of(context).colorScheme.secondaryColor,
              borderRadius: UiUtils.borderRadiusOf10,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (hasChildren)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (isExpanded) {
                                collapsedCategoryIds.add(category.id!);
                              } else {
                                collapsedCategoryIds.remove(category.id);
                              }
                            });
                          },
                          customBorder: const CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: AnimatedRotation(
                              turns: isExpanded ? 0.5 : 0,
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: context.colorScheme.lightGreyColor,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      UiUtils.borderRadiusOf5,
                    ),
                    child: CustomContainer(
                      height: 48,
                      width: 48,
                      child: CustomCachedNetworkImage(
                        imageUrl: category.categoryImage ?? '',
                        width: 48,
                        height: 48,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: CustomText(
                                  category.translatedName ?? '',
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.blackColor,
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (selectedCategoryIds.contains(
                                      category.id,
                                    )) {
                                      selectedCategoryIds.remove(category.id);
                                    } else {
                                      selectedCategoryIds.add(category.id!);
                                    }
                                  });
                                },
                                customBorder: const CircleBorder(),
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: CustomCheckBox(
                                      value: isSelected,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (selectedCategoryIds.contains(
                                            category.id,
                                          )) {
                                            selectedCategoryIds.remove(
                                              category.id,
                                            );
                                          } else {
                                            selectedCategoryIds.add(
                                              category.id!,
                                            );
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        setCommissionAndStatus(
                          lhs: 'statusLbl'.translate(context: context),
                          rhs: categoryStatus[category.status],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        ClipRect(
          child: AnimatedAlign(
            alignment: Alignment.topCenter,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            heightFactor: hasChildren && isExpanded ? 1.0 : 0.0,
            child: Column(
              children: hasChildren
                  ? category.subCategories!
                        .map(
                          (subCategory) => _buildCategoryTile(
                            category: subCategory,
                            depth: depth + 1,
                          ),
                        )
                        .toList()
                  : [],
            ),
          ),
        ),
      ],
    );
  }

  Widget setCommissionAndStatus({required String lhs, required String rhs}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: CustomText(
            lhs,
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.blackColor,
          ),
        ),
        CustomText(
          (lhs == 'adminCommLbl'.translate(context: context))
              ? rhs.formatPercentage()
              : rhs,
          fontWeight: (lhs == 'adminCommLbl'.translate(context: context))
              ? FontWeight.w700
              : FontWeight.w400,
          fontSize: 13,
          color: rhs == 'active'.translate(context: context)
              ? AppColors.greenColor
              : AppColors.redColor,
        ),
      ],
    );
  }
}

import 'package:edemand_partner/ui/widgets/customWarningBottomSheet.dart';
import 'package:flutter/material.dart';

import '../../../../app/generalImports.dart';

/// Provider-side screen listing handymen the provider manages, with
/// search, pagination, status/availability toggles, edit and delete.
class ManageHandymenListScreen extends StatefulWidget {
  const ManageHandymenListScreen({super.key});

  @override
  State<ManageHandymenListScreen> createState() =>
      _ManageHandymenListScreenState();

  static Route<dynamic> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(builder: (_) => const ManageHandymenListScreen());
  }
}

class _ManageHandymenListScreenState extends State<ManageHandymenListScreen> {
  final TextEditingController _searchController = TextEditingController();

  late final ScrollController _pageScrollController = ScrollController()
    ..addListener(_pageScrollListener);

  @override
  void initState() {
    super.initState();
    context.read<FetchHandymenCubit>().fetchHandymen();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageScrollController.dispose();
    super.dispose();
  }

  void _pageScrollListener() {
    if (_pageScrollController.isEndReached()) {
      context.read<FetchHandymenCubit>().fetchMore();
    }
  }

  void _onSearch() {
    context.read<FetchHandymenCubit>().fetchHandymen(
      search: _searchController.text.trim(),
    );
  }

  void _openManageScreen({HandymanModel? handyman}) {
    Navigator.pushNamed(
      context,
      Routes.addHandyman,
      arguments: {'handyman': handyman},
    ).then((_) {
      if (mounted) {
        context.read<FetchHandymenCubit>().fetchHandymen(
          search: _searchController.text.trim(),
        );
      }
    });
  }

  void _confirmDelete(HandymanModel handyman) {
    UiUtils.showModelBottomSheets(
      context: context,
      child: CustomWarningBottomSheet(
        conformText: 'continue'.translate(context: context),
        onTapConformText: () {
          Navigator.pop(context);
          context.read<DeleteHandymanCubit>().deleteHandyman(handyman.id);
        },
        closeText: 'notYet'.translate(context: context),
        onTapCloseText: () => Navigator.pop(context),
        detailsWarningMessage: 'handymanDeleteWarning'.translate(
          context: context,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryColor,
      appBar: UiUtils.getSimpleAppBar(
        context: context,
        title: 'manageHandymenLbl'.translate(context: context),
        statusBarColor: context.colorScheme.secondaryColor,
        elevation: 1,
        actions: [
          IconButton(
            icon: const CustomSvgPicture(svgImage: AppAssets.location),
            onPressed: () =>
                Navigator.pushNamed(context, Routes.handymanLiveMap),
          ),
        ],
      ),
      bottomNavigationBar: CustomContainer(
        color: context.colorScheme.secondaryColor,
        child: CustomAddButton(
          onTap: () => _openManageScreen(),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 10,
            top: 10,
            left: 10,
            right: 10,
          ),
          child: CustomText(
            'addNewHandyman'.translate(context: context),
            color: AppColors.whiteColors,
            fontSize: 16,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<DeleteHandymanCubit, DeleteHandymanState>(
            listener: (context, state) {
              if (state is DeleteHandymanSuccess) {
                context.read<FetchHandymenCubit>().removeHandyman(state.id);
                UiUtils.showMessage(
                  context,
                  state.message.isNotEmpty
                      ? state.message
                      : 'dataDeletedSuccessfully'.translate(context: context),
                  ToastificationType.success,
                );
              }
              if (state is DeleteHandymanFailure) {
                UiUtils.showMessage(
                  context,
                  state.errorMessage,
                  ToastificationType.error,
                );
              }
            },
          ),
          BlocListener<HandymanToggleCubit, HandymanToggleState>(
            listener: (context, state) {
              if (state is HandymanToggleSuccess) {
                final bool newValue = state.value == 1;
                final String messageKey =
                    state.kind == HandymanToggleKind.status
                    ? (newValue
                          ? 'handymanActivatedSuccessfully'
                          : 'handymanDeactivatedSuccessfully')
                    : (newValue
                          ? 'handymanAvailableSuccessfully'
                          : 'handymanUnavailableSuccessfully');
                UiUtils.showMessage(
                  context,
                  messageKey.translate(context: context),
                  ToastificationType.success,
                );
              }
              if (state is HandymanToggleFailure) {
                // Revert the optimistic update.
                if (state.kind == HandymanToggleKind.status) {
                  context.read<FetchHandymenCubit>().setActive(
                    state.id,
                    state.previousValue,
                  );
                } else {
                  context.read<FetchHandymenCubit>().setAvailability(
                    state.id,
                    state.previousValue,
                  );
                }
                UiUtils.showMessage(
                  context,
                  state.errorMessage,
                  ToastificationType.error,
                );
              }
            },
          ),
        ],
        child: Column(
          children: [
            _buildSearchField(),
            Expanded(child: _buildList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 12, 15, 4),
      child: CustomTextFormField(
        controller: _searchController,
        hintText: 'searchHandymanHint'.translate(context: context),
        textInputAction: TextInputAction.search,
        onSubmit: _onSearch,
        suffixIcon: IconButton(
          icon: Icon(Icons.search, color: context.colorScheme.accentColor),
          onPressed: _onSearch,
        ),
      ),
    );
  }

  Widget _buildList() {
    return CustomRefreshIndicator(
      onRefresh: () async {
        context.read<FetchHandymenCubit>().fetchHandymen(
          search: _searchController.text.trim(),
        );
      },
      child: BlocBuilder<FetchHandymenCubit, FetchHandymenState>(
        builder: (context, state) {
          if (state is FetchHandymenInProgress) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              itemCount: 8,
              itemBuilder: (_, __) => const Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: ShimmerLoadingContainer(
                  child: CustomShimmerContainer(height: 90),
                ),
              ),
            );
          }
          if (state is FetchHandymenFailure) {
            return Center(
              child: ErrorContainer(
                errorMessage: state.errorMessage.translate(context: context),
                onTapRetry: () {
                  context.read<FetchHandymenCubit>().fetchHandymen(
                    search: _searchController.text.trim(),
                  );
                },
              ),
            );
          }
          if (state is FetchHandymenSuccess) {
            if (state.handymen.isEmpty) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: NoDataContainer(
                  title: 'noHandymenFound'.translate(context: context),
                  subTitle: 'noHandymenFoundSubTitle'.translate(
                    context: context,
                  ),
                ),
              );
            }
            return ListView.separated(
              controller: _pageScrollController,
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: state.handymen.length + (state.isLoadingMore ? 1 : 0),
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                if (index >= state.handymen.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Center(child: CustomCircularProgressIndicator()),
                  );
                }
                return _handymanCard(state.handymen[index]);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _handymanCard(HandymanModel handyman) {
    final togglingState = context.watch<HandymanToggleCubit>().state;
    final bool isTogglingStatus =
        togglingState is HandymanToggleInProgress &&
        togglingState.id == handyman.id &&
        togglingState.kind == HandymanToggleKind.status;
    // final bool isTogglingAvailability =
    //     togglingState is HandymanToggleInProgress &&
    //     togglingState.id == handyman.id &&
    //     togglingState.kind == HandymanToggleKind.availability;

    return CustomContainer(
      padding: const EdgeInsets.all(12),
      color: context.colorScheme.secondaryColor,
      borderRadius: UiUtils.borderRadiusOf10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomImageContainer(
                imageURL: handyman.image,
                height: 64,
                width: 64,
                borderRadius: UiUtils.borderRadiusOf6,
                boxShadow: const [],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      handyman.username,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: context.colorScheme.blackColor,
                    ),
                    const SizedBox(height: 4),
                    CustomText(
                      '${handyman.countryCode} ${handyman.phone}'.trim(),
                      fontSize: 13,
                      color: context.colorScheme.lightGreyColor,
                    ),
                    if (handyman.email.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      CustomText(
                        handyman.email,
                        fontSize: 13,
                        color: context.colorScheme.lightGreyColor,
                      ),
                    ],
                    if (handyman.averageRating != '0.0') ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 15,
                            color: AppColors.starRatingColor,
                          ),
                          const SizedBox(width: 3),
                          CustomText(
                            handyman.averageRating,
                            fontSize: 13,
                            color: context.colorScheme.blackColor,
                          ),
                          const SizedBox(width: 4),
                          CustomText(
                            '(${handyman.totalRatings})',
                            fontSize: 13,
                            color: context.colorScheme.lightGreyColor,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _toggleRow(
                  label: 'active'.translate(context: context),
                  value: handyman.isActive,
                  isBusy: isTogglingStatus,
                  onChanged: () {
                    context.read<FetchHandymenCubit>().setActive(
                      handyman.id,
                      handyman.isActive ? 0 : 1,
                    );
                    context.read<HandymanToggleCubit>().toggleStatus(
                      handyman.id,
                      currentValue: handyman.isActive,
                    );
                  },
                ),
              ),
              // const SizedBox(width: 8),
              // Expanded(
              //   child: _toggleRow(
              //     label: 'availableLbl'.translate(context: context),
              //     value: handyman.available,
              //     isBusy: isTogglingAvailability,
              //     onChanged: () {
              //       context.read<FetchHandymenCubit>().setAvailability(
              //         handyman.id,
              //         handyman.available ? 0 : 1,
              //       );
              //       context.read<HandymanToggleCubit>().toggleAvailability(
              //         handyman.id,
              //         currentValue: handyman.available,
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _actionButton(
                  label: 'editBtnLbl'.translate(context: context),
                  color: context.colorScheme.accentColor,
                  textColor: AppColors.whiteColors,
                  onTap: () => _openManageScreen(handyman: handyman),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _actionButton(
                  label: 'deleteBtnLbl'.translate(context: context),
                  color: AppColors.redColor.withAlpha(20),
                  textColor: AppColors.redColor,
                  onTap: () => _confirmDelete(handyman),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _toggleRow({
    required String label,
    required bool value,
    required bool isBusy,
    required VoidCallback onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: CustomText(
            label,
            fontSize: 13,
            color: context.colorScheme.blackColor,
          ),
        ),
        CustomSwitch(
          value: value,
          activeColor: context.colorScheme.surfaceContainer,
          thumbColor: value ? Colors.green : Colors.red,
          trackColor: value
              ? Colors.green.withAlpha(20)
              : Colors.red.withAlpha(20),
          onChanged: isBusy ? null : (_) => onChanged(),
        ),
      ],
    );
  }

  Widget _actionButton({
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: CustomContainer(
        height: 40,
        color: color,
        borderRadius: UiUtils.borderRadiusOf6,
        child: Center(
          child: CustomText(
            label,
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:edemand_partner/ui/widgets/customWarningBottomSheet.dart';
import 'package:flutter/material.dart';

import '../../../app/generalImports.dart';

class PromoCode extends StatefulWidget {
  const PromoCode({super.key});

  @override
  PromoCodeState createState() => PromoCodeState();

  static Route<PromoCode> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => DeletePromocodeCubit(),
          ),
        ],
        child: const PromoCode(),
      ),
    );
  }
}

class PromoCodeState extends State<PromoCode> {
  //int? expandedIndex; // Keeps track of the currently expanded container
  int? expandedIndex = 0; // Keeps track of the currently expanded container

  late final ScrollController _pageScrollController = ScrollController()
    ..addListener(_pageScrollListener);

  @override
  void initState() {
    context.read<FetchPromocodesCubit>().fetchPromocodeList();

    super.initState();
  }

  void _pageScrollListener() {
    if (_pageScrollController.isEndReached()) {
      context.read<FetchPromocodesCubit>().fetchMorePromocodes();
    }
  }

  void deletePromocode(promocode) {
    Navigator.pop(context);
    if (promocode.id != null) {
      context.read<DeletePromocodeCubit>().deletePromocode(
        int.parse(promocode.id!),
        onDelete: () {
          debugPrint("delete===dialog");
        },
      );
    } else {
      UiUtils.showMessage(
        context,
        'somethingWentWrongTitle',
        ToastificationType.error,
      );
    }
  }

  Widget durationContainer(String startDate, String endDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          'durationLbl'.translate(context: context),
          fontSize: 13,
          color: context.colorScheme.lightGreyColor,
        ),
        CustomText(
          "${startDate.split(' ')[0].formatDate()} To ${endDate.split(' ')[0].formatDate()}",
          fontSize: 13,
        ),
      ],
    );
  }

  Widget discountAllusersUsedByContainer(
    String discount,
    String allowedUsers,
    String usedBy,
    String discountType,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                'discountLbl'.translate(context: context),
                fontSize: 13,
                color: context.colorScheme.lightGreyColor,
              ),
              CustomText(
                discountType == 'amount'
                    ? discount
                          .replaceAll(',', '')
                          .toString()
                          .providerPriceFormat(context)
                    : '$discount %',
                fontSize: 13,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                'allowedUsers'.translate(context: context),
                fontSize: 13,
                color: context.colorScheme.lightGreyColor,
              ),
              CustomText(allowedUsers, fontSize: 13),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                'usedBy'.translate(context: context),
                fontSize: 13,
                color: context.colorScheme.lightGreyColor,
              ),
              CustomText('$usedBy ', fontSize: 13),
            ],
          ),
        ),
      ],
    );
  }

  Widget setStatusAndButtons(
    BuildContext context, {
    required String promoCodeStatus,
    VoidCallback? editAction,
    VoidCallback? deleteAction,
    VoidCallback? statusUpdateAction,
    double? height,
  }) {
    //set required later
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              UiUtils.showModelBottomSheets(
                context: context,
                child: CustomWarningBottomSheet(
                  conformText: 'continue'.translate(context: context),
                  onTapConformText: deleteAction!,
                  closeText: 'notYet'.translate(context: context),
                  onTapCloseText: () {
                    Navigator.pop(context);
                  },
                  detailsWarningMessage: 'promocodeDeleteWarning'.translate(
                    context: context,
                  ),
                ),
              );
            },
            child: CustomContainer(
              borderRadius: UiUtils.borderRadiusOf6,
              color: AppColors.redColor.withAlpha(20),
              height: height,
              child: Center(
                child: CustomText(
                  'deleteBtnLbl'.translate(context: context),
                  color: AppColors.redColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: statusButton(
            height: height,
            status: promoCodeStatus,
            statusUpdateAction: statusUpdateAction,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: editAction,
            child: CustomContainer(
              borderRadius: UiUtils.borderRadiusOf6,
              color: context.colorScheme.accentColor,
              height: height,
              child: Center(
                child: CustomText(
                  'editBtnLbl'.translate(context: context),
                  color: AppColors.whiteColors,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget statusButton({
    required String status,
    double? height,
    VoidCallback? statusUpdateAction,
  }) {
    final List<Map> statusFilterMap = [
      {
        'value': '0',
        'title': 'deactive'.translate(context: context),
        "color": context.colorScheme.blackColor,
      },
      {
        'value': '1',
        'title': 'active'.translate(context: context),
        "color": AppColors.greenColor,
      },
    ];

    final Map currentStatus = statusFilterMap
        .where((Map element) => element['value'] == status)
        .toList()[0];

    return GestureDetector(
      onTap: statusUpdateAction,
      child: CustomContainer(
        height: height,
        color: (currentStatus['color'] as Color).withValues(alpha: 0.3),
        borderRadius: UiUtils.borderRadiusOf6,
        padding: const EdgeInsets.all(5),
        child: Center(
          child: CustomText(
            currentStatus['title'],
            fontSize: 14,
            maxLines: 2,
            color: currentStatus['color'] as Color,
          ),
        ),
      ),
    );
  }

  Widget mainWidget() {
    return CustomRefreshIndicator(
      onRefresh: () async {
        context.read<FetchPromocodesCubit>().fetchPromocodeList();
      },
      child: SingleChildScrollView(
        clipBehavior: Clip.none,
        physics: const AlwaysScrollableScrollPhysics(),
        child: BlocBuilder<FetchPromocodesCubit, FetchPromocodesState>(
          builder: (BuildContext context, FetchPromocodesState state) {
            if (state is FetchPromocodesInProgress) {
              return ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: 10,
                physics: const NeverScrollableScrollPhysics(),
                clipBehavior: Clip.none,
                itemBuilder: (BuildContext context, int index) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    child: ShimmerLoadingContainer(
                      child: CustomShimmerContainer(height: 100),
                    ),
                  );
                },
              );
            }
            if (state is FetchPromocodesFailure) {
              return Center(
                child: ErrorContainer(
                  onTapRetry: () {
                    context.read<FetchPromocodesCubit>().fetchPromocodeList();
                  },
                  errorMessage: state.errorMessage.translate(context: context),
                ),
              );
            }
            if (state is FetchPromocodesSuccess) {
              if (state.promocodes.isEmpty) {
                return NoDataContainer(
                  title: 'noPromoCodeAvailable'.translate(context: context),
                  subTitle: 'noPromoCodeAvailableSubTitle'.translate(
                    context: context,
                  ),
                );
              }
              return ListView.separated(
                controller: _pageScrollController,
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: state.promocodes.length,
                physics: const NeverScrollableScrollPhysics(),
                clipBehavior: Clip.none,
                itemBuilder: (BuildContext context, int index) {
                  final bool isExpanded = expandedIndex == index;

                  final PromocodeModel promocode = state.promocodes[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        expandedIndex = isExpanded ? null : index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: context.colorScheme.secondaryColor,
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomImageContainer(
                                borderRadius: UiUtils.borderRadiusOf6,
                                imageURL: promocode.image!,
                                height: 80,
                                width: 80,
                                border: Border.all(
                                  color: context.colorScheme.blackColor,
                                  width: 0.2,
                                ),
                                boxShadow: [],
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        promocode.promoCode!,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.blackColor,
                                      ),
                                      const SizedBox(height: 8),
                                      CustomText(
                                        promocode.translatedMessage!,
                                        maxLines: 2,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.lightGreyColor,
                                        fontSize: 13,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          AnimatedCrossFade(
                            duration: const Duration(milliseconds: 300),
                            firstChild: const SizedBox.shrink(),
                            secondChild: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  child: discountAllusersUsedByContainer(
                                    promocode.discount!,
                                    promocode.noOfUsers!,
                                    promocode.totalUsedNumber!,
                                    promocode.discountType!,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  child: durationContainer(
                                    promocode.startDate!,
                                    promocode.endDate!,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  child:
                                      context
                                              .watch<DeletePromocodeCubit>()
                                              .state
                                          is DeleteServiceInProgress
                                      ? const CircularProgressIndicator()
                                      : setStatusAndButtons(
                                          promoCodeStatus: promocode.status!,
                                          context,
                                          height: 40,
                                          statusUpdateAction: () {
                                            final String value =
                                                promocode.status == "1"
                                                ? "0"
                                                : "1";

                                            statusChange(value, promocode);
                                          },
                                          editAction: () {
                                            Navigator.pushNamed(
                                              context,
                                              Routes.addPromoCode,
                                              arguments: {
                                                'promocode': promocode,
                                              },
                                            );
                                          },
                                          deleteAction: () {
                                            deletePromocode(promocode);
                                          },
                                        ),
                                ),
                              ],
                            ),
                            crossFadeState: isExpanded
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    CustomDivider(
                      color: context.colorScheme.secondaryColor,
                      height: 10,
                    ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void statusChange(String status, PromocodeModel promocode) {
    UiUtils.removeFocus();

    // Prepare multi-language data like in managePromoCode.dart
    final Map<String, String>? multiLangMessages = promocode.translatedMessages;
    String? translatedFieldsJson;

    if (multiLangMessages != null && multiLangMessages.isNotEmpty) {
      final translatedFields = {'message': multiLangMessages};
      translatedFieldsJson = jsonEncode(translatedFields);
    }

    final CreatePromocodeModel createPromocode = CreatePromocodeModel(
      promo_id: promocode.id,
      status: status,
      promoCode: promocode.promoCode,
      startDate: promocode.startDate,
      endDate: promocode.endDate,
      minimumOrderAmount: promocode.minimumOrderAmount,
      discountType: promocode.discountType,
      discount: promocode.discount,
      maxDiscountAmount: promocode.maxDiscountAmount,
      message: promocode.translatedMessage,
      multiLanguageMessages: multiLangMessages,
      translatedFieldsJson: translatedFieldsJson,
      repeat_usage: promocode.repeatUsage,
      no_of_users: promocode.noOfUsers,
      no_of_repeat_usage: promocode.noOfRepeatUsage,
    );

    context.read<CreatePromocodeCubit>().createPromocode(createPromocode);
  }

  @override
  Widget build(BuildContext context) {
    return InterstitialAdWidget(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryColor,
        appBar: UiUtils.getSimpleAppBar(
          statusBarColor: context.colorScheme.secondaryColor,
          context: context,
          title: 'promoCodeLbl'.translate(context: context),
          elevation: 1,
        ),
        bottomNavigationBar: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomContainer(
              color: context.colorScheme.secondaryColor,
              child: CustomAddButton(
                onTap: () {
                  Navigator.pushNamed(context, Routes.addPromoCode);
                },
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 10,
                  top: 10,
                  left: 10,
                  right: 10,
                ),
                child: Center(
                  child: CustomText(
                    'addNewPromocode'.translate(context: context),
                    color: AppColors.whiteColors,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const BannerAdWidget(),
          ],
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: BlocListener<DeletePromocodeCubit, DeletePromocodeState>(
          listener: (BuildContext context, DeletePromocodeState state) {
            if (state is DeletePromocodeSuccess) {
              context.read<FetchPromocodesCubit>().deletePromocodeFromCubit(
                state.id,
              );

              UiUtils.showMessage(
                context,
                'promocodeDeleteSuccess',
                ToastificationType.success,
              );
              debugPrint("delete===success");
              // Navigator.pop(context);
            }
            if (state is DeletePromocodeFailure) {
              UiUtils.showMessage(
                context,
                state.errorMessage,
                ToastificationType.error,
              );
              debugPrint("delete===failure");
            }
          },
          child: mainWidget(),
        ),
      ),
    );
  }
}

import 'package:edemand_partner/ui/screens/services/enum/statusEnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../../app/generalImports.dart';

class ServiceDetails extends StatefulWidget {
  const ServiceDetails({super.key, required this.service});

  final ServiceModel service;

  @override
  ServiceDetailsState createState() => ServiceDetailsState();

  static Route<ServiceDetails> route(RouteSettings routeSettings) {
    final Map arguments = routeSettings.arguments as Map;

    return CupertinoPageRoute(
      builder: (_) => ServiceDetails(service: arguments['serviceModel']),
    );
  }
}

class ServiceDetailsState extends State<ServiceDetails>
    with SingleTickerProviderStateMixin {
  Map<String, String> allowNotAllowFilter = {'0': 'notAllowed', '1': 'allowed'};
  late TabController _tabController;
  String selectedFilter = 'reviewsTab';
  final List<String> filterOptions = ["reviewsTab", "details"];
  ScrollController _serviceListScrollController = ScrollController();
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: filterOptions.length, vsync: this);
    Future.delayed(Duration.zero, () {
      if (mounted) context.read<FetchCountrySettingsCubit>().ensureLoaded();
    });
    context.read<FetchServiceReviewsCubit>().fetchReviews(
      int.parse(widget.service.id!),
    );

    // Log service viewed
    ClarityService.logAction(ClarityActions.serviceViewed, {
      'service_id': widget.service.id ?? '',
      'service_name': widget.service.title ?? '',
      'service_price': widget.service.price ?? '',
      'category_id': widget.service.categoryId ?? '',
      'category_name': widget.service.categoryName ?? '',
    });
  }

  @override
  Widget build(BuildContext context) {
    return InterstitialAdWidget(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondaryColor,
        bottomNavigationBar: const BannerAdWidget(),
        body: mainWidget(),
        bottomSheet: BottomDeleteButton(),
      ),
    );
  }

  Widget BottomDeleteButton() {
    return CustomContainer(
      height: 60 + MediaQuery.of(context).padding.bottom,
      color: context.colorScheme.secondaryColor,
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
        top: 10,
        bottom: 10 + MediaQuery.of(context).padding.bottom,
      ),
      boxShadow: [
        BoxShadow(color: context.colorScheme.lightGreyColor, blurRadius: 3.0),
      ],
      child: Row(
        children: [
          GestureDetector(
            child: CustomContainer(
              borderRadius: UiUtils.borderRadiusOf6,
              color: AppColors.redColor.withValues(alpha: 0.2),
              padding: const EdgeInsets.all(8),
              child: const CustomSvgPicture(
                svgImage: AppAssets.trash,
                color: AppColors.redColor,
              ),
            ),
            onTap: () {
              clickOfDeleteButton(serviceId: widget.service.id!);
            },
          ),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              child: CustomContainer(
                borderRadius: UiUtils.borderRadiusOf6,
                color: context.colorScheme.accentColor,
                child: Center(
                  child: CustomText(
                    'editServiceBtnLbl'.translate(context: context),
                    color: AppColors.whiteColors,
                    fontSize: 16,
                  ),
                ),
              ),
              onTap: () {
                FocusScope.of(context).unfocus();
                Navigator.pushNamed(
                  context,
                  Routes.createService,
                  arguments: {'service': widget.service},
                ).then((value) {
                  if (value is ServiceModel) {
                    setState(() {
                      widget.service.copyFrom(value);
                    });
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void clickOfDeleteButton({required String serviceId}) {
    UiUtils.showAnimatedDialog(
      context: context,
      child: BlocProvider.value(
        value: BlocProvider.of<DeleteServiceCubit>(context),
        child: Builder(
          builder: (context) {
            return ConfirmationDialog(
              title: "deleteService",
              description: "deleteDescription",
              confirmButtonName: "delete",
              showProgressIndicator:
                  context.watch<DeleteServiceCubit>().state
                      is DeleteServiceInProgress,
              confirmButtonPressed: () {
                context.read<DeleteServiceCubit>().deleteService(
                  int.parse(serviceId),
                  onDelete: () {
                    Navigator.pop(context);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget mainWidget() {
    return NestedScrollView(
      controller: _serviceListScrollController,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            leading: UiUtils.getBackArrow(context),
            backgroundColor: context.colorScheme.secondaryColor,
            surfaceTintColor: context.colorScheme.secondaryColor,
            pinned: true,
            title: CustomText(
              'serviceDetailsLbl'.translate(context: context),
              color: context.colorScheme.blackColor,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ServiceContainer(listingUI: false, service: widget.service),
                descriptionWidget(),
              ],
            ),
          ),
          SliverPersistentHeader(
            floating: false,
            pinned: true,
            delegate: SliverAppBarDelegate(
              TabBar(
                physics: const NeverScrollableScrollPhysics(),
                onTap: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
                controller: _tabController,
                isScrollable: false,
                dividerColor: Colors.transparent,
                labelPadding: const EdgeInsets.all(3),
                indicatorColor: Colors.transparent,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                ),
                tabs: filterOptions.map((e) {
                  final int index = filterOptions.indexOf(e);
                  return Tab(
                    child: CustomContainer(
                      height: 40,
                      borderRadius: UiUtils.borderRadiusOf5,
                      color: selectedIndex == index
                          ? context.colorScheme.accentColor
                          : context.colorScheme.primaryColor,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 2,
                      ),
                      child: CustomText(
                        e.translate(context: context),
                        color: selectedIndex == index
                            ? AppColors.whiteColors
                            : context.colorScheme.blackColor,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ];
      },
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          setRatingsAndReviews(),
          SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                serviceDetailsWidget(),
                if (widget.service.otherImages != null &&
                    widget.service.otherImages!.isNotEmpty) ...[
                  showDivider(),
                  otherImagesWidget(),
                ],
                if (widget.service.files != null &&
                    widget.service.files!.isNotEmpty) ...[
                  showDivider(),
                  filesImagesWidget(),
                ],
                if (widget.service.getTranslatedFaqs(
                          HiveRepository.getCurrentLanguage()?.languageCode ??
                              'en',
                        ) !=
                        null &&
                    widget.service
                        .getTranslatedFaqs(
                          HiveRepository.getCurrentLanguage()?.languageCode ??
                              'en',
                        )!
                        .isNotEmpty) ...[
                  showDivider(),
                  faqsWidget(),
                ],
                if (widget.service.getTranslatedLongDescription(
                          HiveRepository.getCurrentLanguage()?.languageCode ??
                              'en',
                        ) !=
                        null &&
                    widget.service
                        .getTranslatedLongDescription(
                          HiveRepository.getCurrentLanguage()?.languageCode ??
                              'en',
                        )!
                        .toString()
                        .trim()
                        .isNotEmpty) ...[
                  showDivider(),
                  longDescriptionWidget(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget otherImagesWidget() {
    return CustomContainer(
      color: Theme.of(context).colorScheme.secondaryColor,
      borderRadius: UiUtils.borderRadiusOf10,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomText(
            'otherImages'.translate(context: context),
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.blackColor,
            fontSize: 14,
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.service.otherImages!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.imagePreviewScreen,
                        arguments: {
                          'startFrom': index,
                          'isReviewType': false,
                          'dataURL': widget.service.otherImages!,
                        },
                      ).then((Object? value) {
                        //locked in portrait mode only
                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.portraitUp,
                          DeviceOrientation.portraitDown,
                        ]);
                      });
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        UiUtils.borderRadiusOf10,
                      ),
                      child: CustomCachedNetworkImage(
                        imageUrl: widget.service.otherImages![index],
                        width: 150,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget filesImagesWidget() {
    return CustomContainer(
      color: Theme.of(context).colorScheme.secondaryColor,
      borderRadius: UiUtils.borderRadiusOf10,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomText(
            'files'.translate(context: context),
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.blackColor,
            fontSize: 14,
          ),
          const SizedBox(height: 10),
          Column(
            children: List.generate(widget.service.files!.length, (index) {
              return Column(
                children: [
                  CustomInkWellContainer(
                    onTap: () {
                      launchUrl(
                        Uri.parse(widget.service.files![index]),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    child: SizedBox(
                      width: double.maxFinite,
                      child: Row(
                        children: [
                          Icon(
                            Icons.description_outlined,
                            color: Theme.of(context).colorScheme.lightGreyColor,
                            size: 30,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            widget.service.files![index].extractFileName(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.blackColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!(index == widget.service.files!.length - 1))
                    const Divider(),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget longDescriptionWidget() {
    return CustomContainer(
      color: Theme.of(context).colorScheme.secondaryColor,
      borderRadius: UiUtils.borderRadiusOf10,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomText(
            'serviceDescription'.translate(context: context),
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.blackColor,
            fontSize: 14,
          ),
          const SizedBox(height: 10),
          HtmlWidget(
            widget.service
                .getTranslatedLongDescription(
                  HiveRepository.getCurrentLanguage()?.languageCode ?? 'en',
                )
                .toString(),
            textStyle: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.blackColor.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 70),
        ],
      ),
    );
  }

  Widget faqsWidget() {
    return CustomContainer(
      color: Theme.of(context).colorScheme.secondaryColor,
      borderRadius: UiUtils.borderRadiusOf10,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomText(
            'faqsFull'.translate(context: context),
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.blackColor,
            fontSize: 14,
          ),
          const SizedBox(height: 10),
          StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: List.generate(
                  widget.service
                      .getTranslatedFaqs(
                        HiveRepository.getCurrentLanguage()?.languageCode ??
                            'en',
                      )!
                      .length,
                  (final int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Theme(
                        data: Theme.of(
                          context,
                        ).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          tilePadding: EdgeInsets.zero,
                          childrenPadding: EdgeInsets.zero,
                          collapsedIconColor: Theme.of(
                            context,
                          ).colorScheme.blackColor,
                          expandedAlignment: Alignment.topLeft,
                          title: Text(
                            widget.service
                                    .getTranslatedFaqs(
                                      HiveRepository.getCurrentLanguage()
                                              ?.languageCode ??
                                          'en',
                                    )![index]
                                    .question ??
                                '',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.blackColor,
                              fontStyle: FontStyle.normal,
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                          ),
                          children: <Widget>[
                            Text(
                              widget.service
                                      .getTranslatedFaqs(
                                        HiveRepository.getCurrentLanguage()
                                                ?.languageCode ??
                                            'en',
                                      )![index]
                                      .answer ??
                                  '',
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.lightGreyColor,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget showDivider() {
    return Divider(
      height: 1,
      thickness: 0.5,
      color: Theme.of(context).colorScheme.lightGreyColor,
    );
  }

  Widget getTitleAndSubDetails({
    required String title,
    required String subDetails,
    double? width,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          title.translate(context: context),
          fontSize: 14,
          maxLines: 2,
          fontWeight: FontWeight.w500,
          color: context.colorScheme.blackColor,
        ),
        const SizedBox(height: 5),
        CustomContainer(
          width: width,
          color: Colors.transparent,
          borderRadius: UiUtils.borderRadiusOf5,
          child: CustomReadMoreTextContainer(
            text: subDetails,
            textStyle: TextStyle(
              fontSize: 14,
              color: Theme.of(
                context,
              ).colorScheme.blackColor.withValues(alpha: 0.45),
            ),
          ),
        ),
      ],
    );
  }

  Widget setStars(double ratings, {required Alignment atCenter}) {
    return RatingBar.readOnly(
      initialRating: ratings,
      isHalfAllowed: true,
      halfFilledIcon: Icons.star_half,
      filledIcon: Icons.star_rounded,
      emptyIcon: Icons.star_border_rounded,
      filledColor: AppColors.starRatingColor,
      halfFilledColor: AppColors.starRatingColor,
      emptyColor: Theme.of(context).colorScheme.lightGreyColor,
      aligns: atCenter,
      onRatingChanged: (double rating) {},
    );
  }

  Widget getTitle({required String title}) {
    return CustomText(
      title.translate(context: context),
      maxLines: 1,
      fontWeight: FontWeight.bold,
      fontSize: 14,
      color: Theme.of(context).colorScheme.blackColor,
    );
  }

  Widget descriptionWidget() {
    return CustomContainer(
      borderRadius: UiUtils.borderRadiusOf10,
      color: Theme.of(context).colorScheme.secondaryColor,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: getTitleAndSubDetails(
        title: 'aboutService',
        subDetails:
            widget.service.getTranslatedDescription(
              HiveRepository.getCurrentLanguage()?.languageCode ?? 'en',
            ) ??
            widget.service.description ??
            '',
      ),
    );
  }

  Widget durationWidget() {
    return CustomContainer(
      borderRadius: UiUtils.borderRadiusOf10,
      color: Theme.of(context).colorScheme.secondaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            'durationLbl'.translate(context: context),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.blackColor,
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                'durationDescrLbl'.translate(context: context),
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.lightGreyColor,
              ),
              CustomText(
                "${widget.service.duration!} ${widget.service.durationTypeLabelKey.translate(context: context)}",
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.blackColor,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                'requiredMembers'.translate(context: context),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.blackColor,
              ),
              CustomText(
                widget.service.numberOfMembersRequired!,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.blackColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget serviceDetailsWidget() {
    final StateStatus status = StateStatus.fromApi(widget.service.status!);

    return CustomContainer(
      color: Theme.of(context).colorScheme.secondaryColor,
      borderRadius: UiUtils.borderRadiusOf10,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 2.6,
      child: GridView.count(
        padding: EdgeInsets.zero,
        crossAxisCount: 2,
        crossAxisSpacing: 1.0,
        mainAxisSpacing: 1.0,
        childAspectRatio: 3 / 1.2,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildGridItem(
            'statusLbl'.translate(context: context),
            widget.service.translatedStatus.toString(),
            status.getStatusColor(context),
          ),
          _buildGridItem(
            'adminApproval'.translate(context: context),
            (widget.service.isApprovedByAdmin == "1"
                    ? "approved"
                    : "disApproved")
                .translate(context: context),
            widget.service.isApprovedByAdmin!.capitalize() == '1'
                ? AppColors.greenColor
                : AppColors.redColor,
          ),
          _buildGridItem(
            'taxTypeLbl'.translate(context: context),
            widget.service.taxType!.translate(context: context).capitalize(),
            context.colorScheme.blackColor,
          ),
          if (context.isPayLaterAvailable)
            _buildGridItem(
              'payLater'.translate(context: context),
              allowNotAllowFilter[widget.service.isPayLaterAllowed!]?.translate(
                    context: context,
                  ) ??
                  '',
              context.colorScheme.blackColor,
            ),
          _buildGridItem(
            'cancellation'.translate(context: context),
            widget.service.cancelableTill! == '' ||
                    widget.service.cancelableTill! == '00' ||
                    widget.service.cancelable! == '0'
                ? allowNotAllowFilter[widget.service.isCancelable!]!.translate(
                    context: context,
                  )
                : "${widget.service.cancelableTill!} ${"minutes".translate(context: context)}",
            context.colorScheme.blackColor,
          ),
          _buildGridItem(
            'serviceAtStore'.translate(context: context),
            allowNotAllowFilter[widget.service.isStoreAllowed!]!.translate(
              context: context,
            ),
            context.colorScheme.blackColor,
          ),
          _buildGridItem(
            'serviceAtDoorstep'.translate(context: context),
            allowNotAllowFilter[widget.service.isDoorStepAllowed!]!.translate(
              context: context,
            ),
            context.colorScheme.blackColor,
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(String title, String value, Color? color) {
    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            title,
            color: context.colorScheme.lightGreyColor,
            fontSize: 14.0,
          ),
          const SizedBox(height: 2.0),
          CustomText(
            value,
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
            color: color,
          ),
        ],
      ),
    );
  }

  Widget getTitleAndSubDetailsWithBackgroundColor({
    required String title,
    required String subDetails,
    Color? subTitleBackgroundColor,
    Color? subTitleColor,
    double? width,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          title.translate(context: context),
          fontSize: 14,
          maxLines: 2,
          color: Theme.of(context).colorScheme.lightGreyColor,
        ),
        CustomContainer(
          width: width,
          constraints: const BoxConstraints(minWidth: 100),
          color:
              subTitleBackgroundColor?.withValues(alpha: 0.2) ??
              Colors.transparent,
          borderRadius: UiUtils.borderRadiusOf5,
          padding: const EdgeInsets.all(5),
          child: Center(
            child: CustomText(
              subDetails,
              fontSize: 14,
              maxLines: 2,
              color: subTitleColor ?? Theme.of(context).colorScheme.blackColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget setKeyValueRow({required String key, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          key,
          fontWeight: FontWeight.w400,
          color: Theme.of(context).colorScheme.lightGreyColor,
        ),
        CustomText(
          value,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.blackColor,
        ),
      ],
    );
  }

  Widget setRatingsAndReviews() {
    return BlocBuilder<FetchServiceReviewsCubit, FetchServiceReviewsState>(
      builder: (BuildContext context, FetchServiceReviewsState state) {
        if (state is FetchServiceReviewsInProgress) {
          return ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            itemCount: 8,
            physics: const NeverScrollableScrollPhysics(),
            clipBehavior: Clip.none,
            itemBuilder: (BuildContext context, int index) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: ShimmerLoadingContainer(
                  child: CustomShimmerContainer(height: 60),
                ),
              );
            },
          );
        }

        if (state is FetchServiceReviewsFailure) {
          return const SizedBox();
        }

        if (state is FetchServiceReviewsSuccess) {
          if (state.reviews.isEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  'noRatingsAvailable'.translate(context: context),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                CustomText(
                  'noratingsyet'.translate(context: context),
                  fontSize: 14,
                  color: context.colorScheme.lightGreyColor,
                ),
              ],
            );
          }
          return CustomContainer(
            color: Theme.of(context).colorScheme.secondaryColor,
            borderRadius: UiUtils.borderRadiusOf10,
            padding: EdgeInsets.zero,
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.all(15),
              physics: const NeverScrollableScrollPhysics(),
              clipBehavior: Clip.none,
              itemBuilder: (BuildContext context, int index) {
                final ReviewsModel rating = state.reviews[index];
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            UiUtils.borderRadiusOf50,
                          ),
                          child: CustomCachedNetworkImage(
                            imageUrl: rating.profileImage!,
                            height: 42,
                            width: 42,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomText(
                                      rating.userName!,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.blackColor,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                    width: 45,
                                    child: CustomIconButton(
                                      onPressed: () {},
                                      imgName: AppAssets.star,
                                      titleText: rating.rating!,
                                      fontSize: 14.0,
                                      iconColor: AppColors.starRatingColor,
                                      titleColor: Theme.of(
                                        context,
                                      ).colorScheme.blackColor,
                                      bgColor: Theme.of(
                                        context,
                                      ).colorScheme.secondaryColor,
                                      // textDirection: TextDirection.rtl,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: CustomText(
                                      rating.comment!,
                                      fontSize: 12,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.lightGreyColor,
                                      fontWeight: FontWeight.w400,
                                      maxLines: 2,
                                    ),
                                  ),
                                  CustomText(
                                    rating.ratedOn
                                        .toString()
                                        .formatDateAndTime(),
                                    maxLines: 1,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.lightGreyColor,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (rating.images!.isNotEmpty)
                      SizedBox(
                        height: 65,
                        child: setReviewImages(reviewDetails: rating),
                      ),
                  ],
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  thickness: 0.5,
                  color: Theme.of(
                    context,
                  ).colorScheme.lightGreyColor.withValues(alpha: 0.2),
                );
              },
              itemCount: state.reviews.length,
            ),
          );
        }

        return const CustomContainer();
      },
    );
  }

  Widget setReviewImages({required ReviewsModel reviewDetails}) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: List.generate(
        reviewDetails.images!.length,
        (int index) => CustomInkWellContainer(
          onTap: () =>
              Navigator.pushNamed(
                context,
                Routes.imagePreviewScreen,
                arguments: {
                  'reviewDetails': reviewDetails,
                  'startFrom': index,
                  'isReviewType': true,
                  'dataURL': reviewDetails.images!,
                },
              ).then((Object? value) {
                //locked in portrait mode only
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.portraitDown,
                ]);
              }),
          child: CustomContainer(
            margin: const EdgeInsets.all(5),
            borderRadius: UiUtils.borderRadiusOf10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(UiUtils.borderRadiusOf10),
              child: CustomCachedNetworkImage(
                imageUrl: reviewDetails.images![index],
                height: 38,
                width: 60,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget ratingsWidget(FetchServiceReviewsSuccess state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CustomText(
          state.ratings.averageRating!.length <= 4
              ? state.ratings.averageRating.toString()
              : state.ratings.averageRating.toString().substring(0, 4),
          color: Theme.of(context).colorScheme.blackColor,
          fontSize: 20,
        ),
        setStars(
          double.parse(state.ratings.averageRating!),
          atCenter: Alignment.center,
        ),
        CustomText(
          "${"reviewsTab".translate(context: context)} (${state.total})",
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Theme.of(context).colorScheme.lightGreyColor,
        ),
      ],
    );
  }
}

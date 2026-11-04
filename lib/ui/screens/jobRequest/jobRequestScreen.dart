import 'package:edemand_partner/app/generalImports.dart';
import 'package:edemand_partner/ui/widgets/customWarningBottomSheet.dart';
import 'package:edemand_partner/utils/responsive_size.dart';
import 'package:flutter/material.dart';

class JobRequestScreen extends StatefulWidget {
  const JobRequestScreen({super.key});

  @override
  State<JobRequestScreen> createState() => _JobRequestScreenState();

  static Route<JobRequestScreen> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(builder: (_) => const JobRequestScreen());
  }
}

class _JobRequestScreenState extends State<JobRequestScreen>
    with AutomaticKeepAliveClientMixin {
  ScrollController scrollController = ScrollController();
  int currFilter = 0;
  List<Map> filters = [];
  String? selectedStatus = "open_jobs";
  String? isJobRequestEnable;
  late PageController _pageController;
  List<Widget> _pages = [];

  @override
  void initState() {
    getIsAcceptingCustomJobs();
    _pageController = PageController(initialPage: 0);

    // Initialize API requests for both tabs using their respective cubits
    Future.delayed(Duration.zero, () {
      context.read<FetchJobRequestCubit>().FetchJobRequest(
        jobType: "open_jobs",
      );
      context.read<FetchJobRequestAppliedJobCubit>().FetchJobRequest(
        jobType: "applied_jobs",
      );
    });

    super.initState();
  }

  void getIsAcceptingCustomJobs() {
    isJobRequestEnable = context
        .read<FetchSystemSettingsCubit>()
        .getIsAcceptingCustomJobs();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    filters = [
      {'id': '0', 'fName': 'open_jobs'.translate(context: context)},
      {'id': '1', 'fName': 'applied_jobs'.translate(context: context)},
    ];

    _pages = [
      OpenJobsTabContent(
        scrollController: ScrollController(),
        isJobRequestEnable: isJobRequestEnable,
        key: const PageStorageKey('open_jobs'),
      ),
      AppliedJobsTabContent(
        scrollController: ScrollController(),
        isJobRequestEnable: isJobRequestEnable,
        key: const PageStorageKey('applied_jobs'),
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    filters = [
      {'id': '0', 'fName': 'open_jobs'.translate(context: context)},
      {'id': '1', 'fName': 'applied_jobs'.translate(context: context)},
    ];
    return DefaultTabController(
      length: filters.length,
      child: AnnotatedSafeArea(
        isAnnotated: true,
        child: Scaffold(
          appBar: UiUtils.getSimpleAppBar(
            statusBarColor: context.colorScheme.secondaryColor,
            context: context,
            title: 'jobRequestTitleLbl'.translate(context: context),
            actions: [
              CustomInkWellContainer(
                borderRadius: BorderRadius.circular(5),
                onTap: () {
                  Navigator.of(context).pushNamed(Routes.categories);
                },
                child: CustomContainer(
                  height: 36,
                  width: 40,
                  borderRadius: 5,
                  color: Theme.of(
                    context,
                  ).colorScheme.accentColor.withValues(alpha: 0.1),
                  child: Icon(
                    Icons.format_list_bulleted,
                    color: Theme.of(context).colorScheme.accentColor,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              CustomSwitch(
                activeColor: Theme.of(
                  context,
                ).colorScheme.accentColor.withValues(alpha: 0.5),
                trackColor: isJobRequestEnable == "1"
                    ? Theme.of(context).colorScheme.accentColor
                    : Colors.grey,
                onChanged: (value) {
                  // Show bottom sheet every time toggle is changed
                  UiUtils.showModelBottomSheets(
                    context: context,
                    child: CustomWarningBottomSheet(
                      closeText: 'notYet'.translate(context: context),
                      onTapCloseText: () {
                        Navigator.pop(context);
                      },
                      conformText: 'continue'.translate(context: context),
                      onTapConformText: () {
                        setState(() {
                          isJobRequestEnable = value ? "1" : "0";
                        });
                        context
                            .read<ManageCustomJobValueCubit>()
                            .ManageCustomJobValue(
                              customJobValue: isJobRequestEnable,
                            );
                        Navigator.pop(context); // Close the bottom sheet
                      },
                      detailsWarningMessage: value
                          ? "openJobEnableDescription".translate(
                              context: context,
                            )
                          : "openJobDesableDescription".translate(
                              context: context,
                            ),
                    ),
                  );
                },
                value: isJobRequestEnable == "1",
              ),
              const SizedBox(width: 15),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(55),
              child: _buildTabBar(context, isJobRequestEnable!),
            ),
          ),
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                currFilter = index;
                switch (index) {
                  case 0:
                    selectedStatus = "open_jobs";
                    break;
                  case 1:
                    selectedStatus = 'applied_jobs';
                    break;
                }
              });
            },
            children: _pages,
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context, String isJobRequestEnable) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Center(
      child: CustomContainer(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        color: Theme.of(context).colorScheme.secondaryColor,
        width: deviceWidth,
        height: 55,
        child: Row(
          children: List.generate(filters.length, (index) {
            return Expanded(
              child: CustomInkWellContainer(
                onTap: () {
                  if (currFilter == index) {
                    return;
                  }
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: CustomContainer(
                  color: currFilter == index
                      ? Theme.of(context).colorScheme.accentColor
                      : Theme.of(context).colorScheme.secondaryColor,
                  borderRadius: UiUtils.borderRadiusOf5,
                  border: Border.all(
                    color: currFilter == index
                        ? Theme.of(context).colorScheme.accentColor
                        : Theme.of(
                            context,
                          ).colorScheme.blackColor.withValues(alpha: 0.5),
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  constraints: const BoxConstraints(minWidth: 90),
                  height: 50,
                  child: Center(
                    child: Text(
                      filters[index]['fName']!,
                      style: TextStyle(
                        color: currFilter == index
                            ? AppColors.whiteColors
                            : Theme.of(context).colorScheme.blackColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

// Custom tab content for Open Jobs that uses FetchJobRequestCubit
class OpenJobsTabContent extends StatefulWidget {
  const OpenJobsTabContent({
    super.key,
    required this.scrollController,
    this.isJobRequestEnable,
  });

  final ScrollController scrollController;
  final String? isJobRequestEnable;

  @override
  State<OpenJobsTabContent> createState() => _OpenJobsTabContentState();
}

class _OpenJobsTabContentState extends State<OpenJobsTabContent>
    with AutomaticKeepAliveClientMixin {
  void pageScrollListen() {
    if (widget.scrollController.position.extentAfter == 0) {
      if (context.read<FetchJobRequestCubit>().hasMoreJobRequest()) {
        context.read<FetchJobRequestCubit>().fetchMoreJobRequest("open_jobs");
      }
    }
  }

  @override
  void initState() {
    widget.scrollController.addListener(pageScrollListen);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomRefreshIndicator(
      onRefresh: () async {
        await context.read<FetchJobRequestCubit>().FetchJobRequest(
          jobType: "open_jobs",
        );
      },
      child: SizedBox(
        height: context.screenHeight,
        child: SingleChildScrollView(
          controller: widget.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: openJobsList(),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget openJobsList() {
    return BlocBuilder<FetchJobRequestCubit, FetchJobRequestState>(
      builder: (BuildContext context, FetchJobRequestState state) {
        if (state is FetchJobRequestInProgress) {
          // Show shimmer loading initially
          return ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsetsDirectional.all(16),
            itemCount: 8,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0),
                child: ShimmerLoadingContainer(
                  child: CustomShimmerContainer(height: 170),
                ),
              );
            },
          );
        }

        if (state is FetchJobRequestFailure) {
          // Error state
          return Center(
            child: ErrorContainer(
              onTapRetry: () {
                context.read<FetchJobRequestCubit>().FetchJobRequest(
                  jobType: "open_jobs",
                );
              },
              errorMessage: state.errorMessage.translate(context: context),
            ),
          );
        }

        if (state is FetchJobRequestSuccess) {
          // If there are no items
          if (state.jobRequest.isEmpty) {
            return NoDataContainer(
              imageTitle: AppAssets.design,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              title: 'noJobsAvailable'.translate(context: context),
              subTitle: 'noJobsAvailableDetail'.translate(context: context),
            );
          }
          UiUtils.customRequestCounter = state.total.toString();

          return Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                itemCount: state.jobRequest.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  final JobRequestModel jobRequestModel =
                      state.jobRequest[index];
                  final String requestedStartDate =
                      jobRequestModel.requestedStartDate ?? '';
                  final String requestedStartTime =
                      jobRequestModel.requestedStartTime ?? '';

                  // Combine date and time
                  final String combinedDateTimeString =
                      "$requestedStartDate $requestedStartTime";

                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.openJobRequestDetails,
                        arguments: {'jobRequestModel': jobRequestModel},
                      );
                    },
                    child: CustomContainer(
                      padding: const EdgeInsetsDirectional.all(10),
                      borderRadius: UiUtils.borderRadiusOf10,
                      color: Theme.of(context).colorScheme.secondaryColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            jobRequestModel.translatedServiceTitle ?? '',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.blackColor,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 5),
                          CustomText(
                            jobRequestModel.translatedServiceShortDescription ??
                                '',
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: context.colorScheme.lightGreyColor,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 10),
                          CustomText(
                            "budget".translate(context: context),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.lightGreyColor,
                          ),
                          Row(
                            children: [
                              CustomText(
                                jobRequestModel.formatPrice(
                                  context,
                                  jobRequestModel.minPrice,
                                ),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.blackColor,
                              ),
                              CustomText(
                                " ${"to".translate(context: context)} ",
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(
                                  context,
                                ).colorScheme.lightGreyColor,
                              ),
                              Expanded(
                                child: CustomText(
                                  jobRequestModel.formatPrice(
                                    context,
                                    jobRequestModel.maxPrice,
                                  ),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.blackColor,
                                ),
                              ),
                            ],
                          ),
                          CustomDivider(
                            thickness: 0.5,
                            color: Theme.of(
                              context,
                            ).colorScheme.lightGreyColor.withValues(alpha: 0.3),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomContainer(
                                height: 35,
                                width: 35,
                                shape: BoxShape.circle,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    UiUtils.borderRadiusOf50,
                                  ),
                                  child: CustomCachedNetworkImage(
                                    imageUrl: jobRequestModel.image ?? '',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      jobRequestModel.username ?? '',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.blackColor,
                                      maxLines: 1,
                                    ),
                                    CustomText(
                                      UiUtils.getTimeAgo(
                                        context,
                                        date: DateTime.tryParse(
                                          combinedDateTimeString,
                                        ),
                                      ),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.lightGreyColor,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: showButton(
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    Navigator.pushNamed(
                                      context,
                                      Routes.openJobRequestDetails,
                                      arguments: {
                                        'jobRequestModel': jobRequestModel,
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(height: 10),
              ),
              // Progress indicator logic
              if (state.isLoadingMoreJobRequest)
                CustomCircularProgressIndicator(
                  color: Theme.of(context).colorScheme.accentColor,
                ),
            ],
          );
        }
        return const CustomContainer();
      },
    );
  }

  Widget showButton({void Function()? onPressed}) {
    return SizedBox(
      height: 35,
      width: 120.rh(context),
      child: CustomIconButton(
        // textDirection: TextDirection.ltr,
        imgName:
            Directionality.of(
              context,
            ).toString().contains(TextDirection.ltr.name)
            ? AppAssets.arrowNext
            : AppAssets.backArrowLight,
        iconColor: Theme.of(context).colorScheme.accentColor,
        titleText: 'applyNow'.translate(context: context),
        fontWeight: FontWeight.w400,
        fontSize: 13.0,
        borderRadius: UiUtils.borderRadiusOf5,
        titleColor: Theme.of(context).colorScheme.accentColor,
        borderColor: Colors.transparent,
        bgColor: Theme.of(
          context,
        ).colorScheme.accentColor.withValues(alpha: 0.1),
        onPressed: onPressed,
      ),
    );
  }
}

// Custom tab content for Applied Jobs that uses FetchJobRequestAppliedJobCubit
class AppliedJobsTabContent extends StatefulWidget {
  const AppliedJobsTabContent({
    super.key,
    required this.scrollController,
    this.isJobRequestEnable,
  });

  final ScrollController scrollController;
  final String? isJobRequestEnable;

  @override
  State<AppliedJobsTabContent> createState() => _AppliedJobsTabContentState();
}

class _AppliedJobsTabContentState extends State<AppliedJobsTabContent>
    with AutomaticKeepAliveClientMixin {
  void pageScrollListen() {
    if (widget.scrollController.position.extentAfter == 0) {
      if (context.read<FetchJobRequestAppliedJobCubit>().hasMoreJobRequest()) {
        context.read<FetchJobRequestAppliedJobCubit>().fetchMoreJobRequest(
          "applied_jobs",
        );
      }
    }
  }

  @override
  void initState() {
    widget.scrollController.addListener(pageScrollListen);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomRefreshIndicator(
      onRefresh: () async {
        await context.read<FetchJobRequestAppliedJobCubit>().FetchJobRequest(
          jobType: "applied_jobs",
        );
      },
      child: SizedBox(
        height: context.screenHeight,
        child: SingleChildScrollView(
          controller: widget.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: appliedJobsList(),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget appliedJobsList() {
    return BlocBuilder<FetchJobRequestAppliedJobCubit, FetchJobRequestState>(
      builder: (BuildContext context, FetchJobRequestState state) {
        if (state is FetchJobRequestInProgress) {
          return ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsetsDirectional.all(16),
            itemCount: 8,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0),
                child: ShimmerLoadingContainer(
                  child: CustomShimmerContainer(height: 170),
                ),
              );
            },
          );
        }

        if (state is FetchJobRequestFailure) {
          return Center(
            child: ErrorContainer(
              onTapRetry: () {
                context.read<FetchJobRequestAppliedJobCubit>().FetchJobRequest(
                  jobType: "applied_jobs",
                );
              },
              errorMessage: state.errorMessage.translate(context: context),
            ),
          );
        }
        if (state is FetchJobRequestSuccess) {
          if (state.jobRequest.isEmpty) {
            return NoDataContainer(
              imageTitle: AppAssets.design,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              title: 'noJobsAvailable'.translate(context: context),
              subTitle: 'noJobsAvailableDetail'.translate(context: context),
            );
          }

          return Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                itemCount: state.jobRequest.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  final JobRequestModel jobRequestModel =
                      state.jobRequest[index];
                  final String requestedStartDate =
                      jobRequestModel.requestedStartDate!;
                  final String requestedStartTime =
                      jobRequestModel.requestedStartTime!;

                  // Combine and parse using intl package
                  final String combinedDateTimeString =
                      "$requestedStartDate $requestedStartTime";

                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.appliedJobrequestDetails,
                        arguments: {'jobRequestModel': jobRequestModel},
                      );
                    },
                    child: CustomContainer(
                      padding: const EdgeInsetsDirectional.all(10),
                      borderRadius: UiUtils.borderRadiusOf10,
                      color: Theme.of(context).colorScheme.secondaryColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      jobRequestModel.translatedServiceTitle!,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.blackColor,
                                      maxLines: 2,
                                    ),
                                    const SizedBox(height: 5),
                                    CustomText(
                                      jobRequestModel
                                          .translatedServiceShortDescription!,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.lightGreyColor,
                                      maxLines: 2,
                                    ),
                                    const SizedBox(height: 6),
                                    BidStatusBanner(model: jobRequestModel),
                                    const Divider(),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomContainer(
                                          height: 35,
                                          width: 35,
                                          shape: BoxShape.circle,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              UiUtils.borderRadiusOf50,
                                            ),
                                            child: CustomCachedNetworkImage(
                                              imageUrl:
                                                  jobRequestModel.image ?? '',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                jobRequestModel.username!,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.blackColor,
                                                maxLines: 1,
                                              ),
                                              CustomText(
                                                UiUtils.getTimeAgo(
                                                  context,
                                                  date: DateTime.tryParse(
                                                    combinedDateTimeString,
                                                  ),
                                                ),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.lightGreyColor,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                "budget".translate(
                                                  context: context,
                                                ),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.lightGreyColor,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: CustomText(
                                                      "${jobRequestModel.formatPrice(context, jobRequestModel.minPrice)} - ${jobRequestModel.formatPrice(context, jobRequestModel.maxPrice)}",
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Theme.of(
                                                        context,
                                                      ).colorScheme.blackColor,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  CustomSvgPicture(
                                                    svgImage:
                                                        Directionality.of(
                                                          context,
                                                        ).toString().contains(
                                                          TextDirection
                                                              .ltr
                                                              .name,
                                                        )
                                                        ? AppAssets.arrowNext
                                                        : AppAssets
                                                              .backArrowLight,
                                                    width: 15,
                                                    height: 15,
                                                    boxFit: BoxFit.fill,
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.blackColor,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(height: 10),
              ),
              if (state.isLoadingMoreJobRequest)
                CustomCircularProgressIndicator(
                  color: Theme.of(context).colorScheme.accentColor,
                ),
            ],
          );
        }

        return const CustomContainer();
      },
    );
  }
}

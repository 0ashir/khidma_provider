import 'package:flutter/material.dart';

import '../../app/generalImports.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  ReviewsScreenState createState() => ReviewsScreenState();

  static Route route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) {
        return const ReviewsScreen();
      },
    );
  }
}

class ReviewsScreenState extends State<ReviewsScreen>
    with AutomaticKeepAliveClientMixin {
  ScrollController scrollController = ScrollController();
  double twoStarVal = 20;
  double avg = 0;

  @override
  void initState() {
    context.read<FetchReviewsCubit>().fetchReviews();
    scrollController.addListener(pageScrollListen);
    super.initState();
  }

  void pageScrollListen() {
    if (scrollController.isEndReached()) {
      if (context.read<FetchReviewsCubit>().hasMoreReviews()) {
        context.read<FetchReviewsCubit>().fetchMoreReviews();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return AnnotatedSafeArea(
      isAnnotated: true,
      child: Scaffold(
        appBar: UiUtils.getSimpleAppBar(
          statusBarColor: context.colorScheme.secondaryColor,
          context: context,
          title: 'reviewsTitleLbl'.translate(context: context),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryColor,
        body: CustomRefreshIndicator(
          onRefresh: () async {
            context.read<FetchReviewsCubit>().fetchReviews();
          },
          child: SingleChildScrollView(
            controller: scrollController,
            clipBehavior: Clip.none,
            physics: const AlwaysScrollableScrollPhysics(),
            child: BlocBuilder<FetchReviewsCubit, FetchReviewsState>(
              builder: (BuildContext context, FetchReviewsState state) {
                if (state is FetchReviewsSuccess) {}
                return Column(
                  children: [
                    ratingsSummary(state),
                    buildWidget(state),
                    const SizedBox(height: 5),
                    if (state is FetchReviewsSuccess) ...[
                      if (state.isLoadingMoreReviews)
                        CustomCircularProgressIndicator(
                          color: Theme.of(context).colorScheme.accentColor,
                        ),
                    ],
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget ratingsSummary(FetchReviewsState state) {
    if (state is FetchReviewsInProgress) {
      return const ShimmerLoadingContainer(
        child: CustomShimmerContainer(height: 125),
      );
    }

    if (state is FetchReviewsSuccess) {
      final double fiveStarPercentage =
          double.parse(state.ratings.rating5!) /
          double.parse(state.ratings.totalRatings!) *
          100;
      final double fourStarPercentage =
          double.parse(state.ratings.rating4!) /
          double.parse(state.ratings.totalRatings!) *
          100;
      final double threeStarPercentage =
          double.parse(state.ratings.rating3!) /
          double.parse(state.ratings.totalRatings!) *
          100;
      final double twoStarPercentage =
          double.parse(state.ratings.rating2!) /
          double.parse(state.ratings.totalRatings!) *
          100;
      final double oneStarPercentage =
          double.parse(state.ratings.rating1!) /
          double.parse(state.ratings.totalRatings!) *
          100;
      if (state.reviews.isEmpty) {
        return NoDataContainer(
          title: 'noDataFound'.translate(context: context),
          subTitle: 'noDataFoundSubTitle'.translate(context: context),
        );
      }
      return CustomContainer(
        height: 120,
        color: Theme.of(context).colorScheme.secondaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            totalReviews(state),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                setLinearProgressIndicator(
                  semanticLbl: '5star',
                  progressVal: fiveStarPercentage,
                ),
                setLinearProgressIndicator(
                  semanticLbl: '4star',
                  progressVal: fourStarPercentage,
                ),
                setLinearProgressIndicator(
                  semanticLbl: '3star',
                  progressVal: threeStarPercentage,
                ),
                setLinearProgressIndicator(
                  semanticLbl: '2star',
                  progressVal: twoStarPercentage,
                ),
                setLinearProgressIndicator(
                  semanticLbl: '1star',
                  progressVal: oneStarPercentage,
                ),
              ],
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget totalReviews(FetchReviewsSuccess state) {
    return CustomContainer(
      borderRadius: UiUtils.borderRadiusOf10,
      color: context.colorScheme.accentColor.withAlpha(20),
      height: 100,
      width: MediaQuery.of(context).size.width / 2.6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            state.ratings.averageRating!.length <= 4
                ? state.ratings.averageRating.toString()
                : state.ratings.averageRating.toString().substring(0, 4),
            fontSize: 26,
            color: Theme.of(context).colorScheme.accentColor,
          ),
          Align(
            alignment: Alignment.center,
            child: RatingBar.readOnly(
              initialRating: double.parse(state.ratings.averageRating!),
              isHalfAllowed: true,
              halfFilledIcon: Icons.star_half,
              filledIcon: Icons.star,
              emptyIcon: Icons.star_border,
              filledColor: AppColors.starRatingColor,
              halfFilledColor: AppColors.starRatingColor,
              emptyColor: AppColors.starRatingColor,
              onRatingChanged: (double rating) {},
              aligns: Alignment.center,
            ),
          ),
          CustomText(
            '${"totalReviewsLbl".translate(context: context)} (${state.total})',
            fontSize: 10,
            color: Theme.of(context).colorScheme.lightGreyColor,
          ),
        ],
      ),
    );
  }

  Widget setLinearProgressIndicator({
    Color? bgColor,
    Animation<Color?>? valueColor,
    required double progressVal,
    required String semanticLbl,
  }) {
    valueColor ??= AlwaysStoppedAnimation<Color>(
      context.colorScheme.accentColor,
    );
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: CustomText(
              semanticLbl.substring(0, 1),
              color: Theme.of(context).colorScheme.blackColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            flex: 3,
            child: SizedBox(
              child: CustomTweenAnimation(
                curve: Curves.fastLinearToSlowEaseIn,
                beginValue: 0,
                endValue: progressVal.isNaN ? 0 : progressVal,
                durationInSeconds: 1,
                builder: (BuildContext context, double value, Widget? child) =>
                    ProgressBar(
                      max: 100,
                      current: value.isNaN ? 0 : value,
                      color: context.colorScheme.accentColor,
                    ),
              ),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            flex: 1,
            child: CustomText(
              '${progressVal.round().toString()} %',
              color: Theme.of(context).colorScheme.blackColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildWidget(FetchReviewsState state) {
    if (state is FetchReviewsInProgress) {
      return ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsetsDirectional.only(top: 20),
        itemCount: 8,
        physics: const NeverScrollableScrollPhysics(),
        clipBehavior: Clip.none,
        itemBuilder: (BuildContext context, int index) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: ShimmerLoadingContainer(
              child: CustomShimmerContainer(height: 128),
            ),
          );
        },
      );
    }

    if (state is FetchReviewsFailure) {
      return Center(
        child: ErrorContainer(
          onTapRetry: () {
            context.read<FetchReviewsCubit>().fetchReviews();
          },
          errorMessage: state.errorMessage.translate(context: context),
        ),
      );
    }

    if (state is FetchReviewsSuccess) {
      return ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsetsDirectional.only(top: 10),
        itemCount: state.reviews.length,
        physics: const NeverScrollableScrollPhysics(),
        clipBehavior: Clip.none,
        itemBuilder: (BuildContext context, int index) {
          final ReviewsModel review = state.reviews[index];
          return CustomContainer(
            padding: const EdgeInsetsDirectional.all(10),
            color: Theme.of(context).colorScheme.secondaryColor,
            child: Column(
              children: [
                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    review.service_name!.capitalize(),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.blackColor,
                  ),
                ),
                const SizedBox(height: 10),
                setDetailsRow(model: review),
                if (review.images!.isNotEmpty)
                  SizedBox(
                    height: 65,
                    child: setReviewImages(reviewDetails: review),
                  ),
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 10),
      );
    }
    return const CustomContainer();
  }

  Widget setReviewImages({required ReviewsModel reviewDetails}) {
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  'dataURL': reviewDetails.images,
                },
              ).then((Object? value) {
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
                width: 80,
                height: 38,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget setDetailsRow({required ReviewsModel model}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(UiUtils.borderRadiusOf50),
          child: CustomCachedNetworkImage(
            imageUrl: model.profileImage!,
            width: 42,
            height: 42,
          ),
        ),

        const SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomText(
                      model.userName ?? '',
                      fontSize: 14,
                      maxLines: 1,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.blackColor,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    width: 50,
                    child: CustomIconButton(
                      onPressed: () {},
                      imgName: AppAssets.star,
                      titleText: model.rating!,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      iconColor: AppColors.starRatingColor,
                      titleColor: Theme.of(context).colorScheme.blackColor,
                      bgColor: Theme.of(context).colorScheme.secondaryColor,
                      // textDirection: TextDirection.rtl,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomReadMoreTextContainer(
                    text: model.comment ?? '',
                    textStyle: TextStyle(
                      fontSize: 12,
                      color: Theme.of(
                        context,
                      ).colorScheme.blackColor.withValues(alpha: 0.7),
                    ),
                    trimLines: 2,
                  ),
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomText(
                      UiUtils.getTimeAgo(
                        context,
                        date: DateTime.tryParse(model.ratedOn ?? ''),
                      ),
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.lightGreyColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        //Ratings
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

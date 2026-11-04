import 'package:flutter/material.dart';

import '../../../app/generalImports.dart';

class HandymanReviewsScreen extends StatefulWidget {
  const HandymanReviewsScreen({super.key});

  @override
  State<HandymanReviewsScreen> createState() => _HandymanReviewsScreenState();

  static Route route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => BlocProvider<FetchHandymanReviewsCubit>(
        create: (_) => FetchHandymanReviewsCubit(),
        child: const HandymanReviewsScreen(),
      ),
    );
  }
}

class _HandymanReviewsScreenState extends State<HandymanReviewsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<FetchHandymanReviewsCubit>().fetchReviews();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.isEndReached()) {
      if (context.read<FetchHandymanReviewsCubit>().hasMoreReviews()) {
        context.read<FetchHandymanReviewsCubit>().fetchMoreReviews();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedSafeArea(
      isAnnotated: true,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryColor,
        appBar: UiUtils.getSimpleAppBar(
          statusBarColor: context.colorScheme.secondaryColor,
          context: context,
          title: 'reviewsTitleLbl'.translate(context: context),
        ),
        body: CustomRefreshIndicator(
          onRefresh: () async {
            context.read<FetchHandymanReviewsCubit>().fetchReviews();
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            clipBehavior: Clip.none,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildRatingSummary(),
                BlocBuilder<
                  FetchHandymanReviewsCubit,
                  FetchHandymanReviewsState
                >(
                  builder: (context, state) => Column(
                    children: [
                      _buildList(state),
                      if (state is FetchHandymanReviewsSuccess &&
                          state.isLoadingMore)
                        CustomCircularProgressIndicator(
                          color: context.colorScheme.accentColor,
                        ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingSummary() {
    return BlocBuilder<HandymanProfileCubit, HandymanProfileState>(
      builder: (context, state) {
        final profile = state.currentProfile;
        if (profile == null) return const SizedBox.shrink();

        final avg = double.tryParse(profile.averageRatings) ?? 0.0;
        final count = profile.totalRatings;

        return ColoredBox(
          color: context.colorScheme.secondaryColor,
          child: CustomContainer(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            borderRadius: UiUtils.borderRadiusOf10,
            color: context.colorScheme.accentColor.withValues(alpha: 0.1),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  avg.toStringAsFixed(1),
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: context.colorScheme.accentColor,
                ),
                RatingBar.readOnly(
                  initialRating: avg,
                  isHalfAllowed: true,
                  halfFilledIcon: Icons.star_half,
                  filledIcon: Icons.star,
                  emptyIcon: Icons.star_border,
                  filledColor: AppColors.starRatingColor,
                  halfFilledColor: AppColors.starRatingColor,
                  emptyColor: AppColors.starRatingColor,
                  onRatingChanged: (_) {},
                  aligns: Alignment.center,
                ),
                const SizedBox(height: 4),
                CustomText(
                  '${'totalReviewsLbl'.translate(context: context)} ($count)',
                  fontSize: 11,
                  color: context.colorScheme.lightGreyColor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildList(FetchHandymanReviewsState state) {
    if (state is FetchHandymanReviewsInProgress) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsetsDirectional.only(top: 10),
        itemCount: 6,
        itemBuilder: (_, __) => const Padding(
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          child: ShimmerLoadingContainer(
            child: CustomShimmerContainer(height: 110),
          ),
        ),
      );
    }

    if (state is FetchHandymanReviewsFailure) {
      return Center(
        child: ErrorContainer(
          onTapRetry: () {
            context.read<FetchHandymanReviewsCubit>().fetchReviews();
          },
          errorMessage: state.errorMessage.translate(context: context),
        ),
      );
    }

    if (state is FetchHandymanReviewsSuccess) {
      if (state.reviews.isEmpty) {
        return NoDataContainer(
          title: 'noDataFound'.translate(context: context),
          subTitle: 'noDataFoundSubTitle'.translate(context: context),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        clipBehavior: Clip.none,
        padding: const EdgeInsetsDirectional.only(top: 10),
        itemCount: state.reviews.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) => _buildReviewCard(state.reviews[index]),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildReviewCard(HandymanReviewModel review) {
    return CustomContainer(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      color: context.colorScheme.secondaryColor,
      borderRadius: UiUtils.borderRadiusOf10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(UiUtils.borderRadiusOf50),
                child: review.customerImage.isNotEmpty
                    ? CustomCachedNetworkImage(
                        imageUrl: review.customerImage,
                        width: 36,
                        height: 36,
                      )
                    : CustomContainer(
                        width: 36,
                        height: 36,
                        color: context.colorScheme.lightGreyColor.withValues(
                          alpha: 0.3,
                        ),
                        child: const Icon(Icons.person, size: 18),
                      ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CustomText(
                  review.customerName,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: context.colorScheme.blackColor,
                  maxLines: 1,
                ),
              ),
              CustomIconButton(
                onPressed: () {},
                imgName: AppAssets.star,
                titleText: review.rating.toStringAsFixed(1),
                fontSize: 13,
                fontWeight: FontWeight.w500,
                iconColor: AppColors.starRatingColor,
                titleColor: context.colorScheme.blackColor,
                bgColor: context.colorScheme.secondaryColor,
              ),
            ],
          ),
          if (review.review.isNotEmpty) ...[
            const SizedBox(height: 4),
            CustomReadMoreTextContainer(
              text: review.review,
              textStyle: TextStyle(
                fontSize: 12,
                color: context.colorScheme.blackColor.withValues(alpha: 0.7),
              ),
              trimLines: 3,
            ),
          ],
          const SizedBox(height: 2),
          Align(
            alignment: Alignment.centerRight,
            child: CustomText(
              UiUtils.getTimeAgo(
                context,
                date: DateTime.tryParse(review.createdAt),
              ),
              fontSize: 10,
              color: context.colorScheme.lightGreyColor,
            ),
          ),
          if (review.images.isNotEmpty) ...[
            const SizedBox(height: 8),
            SizedBox(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: review.images.length,
                itemBuilder: (context, index) => CustomInkWellContainer(
                  onTap: () => Navigator.pushNamed(
                    context,
                    Routes.imagePreviewScreen,
                    arguments: {
                      'startFrom': index,
                      'isReviewType': false,
                      'dataURL': review.images,
                    },
                  ),
                  child: CustomContainer(
                    margin: const EdgeInsetsDirectional.only(end: 8),
                    borderRadius: UiUtils.borderRadiusOf10,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        UiUtils.borderRadiusOf10,
                      ),
                      child: CustomCachedNetworkImage(
                        imageUrl: review.images[index],
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

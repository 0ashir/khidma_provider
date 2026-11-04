import 'package:flutter/material.dart';

import '../../app/generalImports.dart';
import '../../utils/checkURLType.dart';
import 'customVideoPlayer/playVideoScreen.dart';
import 'package:intl/intl.dart';

class ImagePreview extends StatefulWidget {
  const ImagePreview({
    super.key,
    required this.reviewDetails,
    required this.startFrom,
    required this.isReviewType,
    required this.dataURL,
  });

  final ReviewsModel? reviewDetails;
  final int startFrom;
  final bool isReviewType;
  final List<dynamic> dataURL;

  @override
  State<ImagePreview> createState() => _ImagePreviewState();

  static Route route(RouteSettings settings) {
    final Map arguments = settings.arguments as Map;
    return CupertinoPageRoute(
      builder: (BuildContext context) {
        return ImagePreview(
          reviewDetails: arguments['reviewDetails'] ?? ReviewsModel(),
          startFrom: arguments['startFrom'],
          isReviewType: arguments['isReviewType'],
          dataURL: arguments['dataURL'],
        );
      },
    );
  }
}

class _ImagePreviewState extends State<ImagePreview>
    with TickerProviderStateMixin {
  ValueNotifier<bool> isShowData = ValueNotifier(true);

  late final AnimationController animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 100),
  );
  late final Animation<double> opacityAnimation = Tween<double>(
    begin: 1,
    end: 0,
  ).animate(CurvedAnimation(parent: animationController, curve: Curves.linear));

  late final PageController _pageController = PageController(
    initialPage: widget.startFrom,
  );

  @override
  void dispose() {
    isShowData.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: widget.dataURL.length,
                itemBuilder: (BuildContext context, int index) {
                  return CustomInkWellContainer(
                    onTap: () {
                      if (widget.isReviewType) {
                        isShowData.value = !isShowData.value;

                        if (isShowData.value) {
                          animationController.forward();
                        } else {
                          animationController.reverse();
                        }
                      }
                    },
                    child:
                        UrlTypeHelper.getType(widget.dataURL[index]) ==
                            UrlType.image
                        ? CustomCachedNetworkImage(
                            imageUrl: widget.dataURL[index].toString(),
                            avoidImageCache: false,
                          )
                        : PlayVideoScreen(videoURL: widget.dataURL[index]),
                  );
                },
              ),
              PositionedDirectional(
                start: 15,
                top: 12 + MediaQuery.viewPaddingOf(context).top,
                child: AnimatedBuilder(
                  animation: animationController,
                  builder: (BuildContext context, Widget? child) => Opacity(
                    opacity: opacityAnimation.value,
                    child: CustomContainer(
                      height: 35,
                      width: 35,
                      padding: const EdgeInsets.all(5),
                      color: Theme.of(
                        context,
                      ).colorScheme.secondaryColor.withValues(alpha: 0.5),
                      borderRadius: UiUtils.borderRadiusOf10,
                      child: CustomInkWellContainer(
                        onTap: () {
                          if (orientation != Orientation.portrait) {
                            SystemChrome.setPreferredOrientations([
                              DeviceOrientation.portraitUp,
                            ]);
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        child: Center(
                          child: CustomSvgPicture(
                            svgImage:
                                Directionality.of(context).toString().contains(
                                  TextDirection.RTL.value.toLowerCase(),
                                )
                                ? AppAssets.arrowNext
                                : AppAssets.backArrowLight,
                            height: 25,
                            width: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (widget.isReviewType) ...[
                Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: AnimatedBuilder(
                    animation: animationController,
                    builder: (BuildContext context, Widget? child) => Opacity(
                      opacity: opacityAnimation.value,
                      child: CustomContainer(
                        constraints: BoxConstraints(
                          maxHeight: context.screenHeight * 0.3,
                        ),
                        width: MediaQuery.sizeOf(context).width,
                        padding: const EdgeInsets.all(15),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).colorScheme.blackColor.withValues(alpha: 0.35),
                            offset: const Offset(0, 0.75),
                            spreadRadius: 5,
                            blurRadius: 25,
                          ),
                        ],
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CircleAvatar(
                              minRadius: 15,
                              maxRadius: 20,
                              child: CustomCachedNetworkImage(
                                imageUrl:
                                    widget.reviewDetails!.profileImage ?? '',
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: SingleChildScrollView(
                                clipBehavior: Clip.none,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CustomReadMoreTextContainer(
                                      text: widget.reviewDetails!.comment ?? '',
                                      textStyle: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.blackColor,
                                        fontSize: 14,
                                      ),
                                      trimLines: 2,
                                    ),
                                    const SizedBox(height: 8),
                                    StarRating(
                                      rating: double.parse(
                                        widget.reviewDetails!.rating!,
                                      ),
                                      onRatingChanged: (double rating) =>
                                          rating,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "${widget.reviewDetails!.userName ?? ''}, ${UiUtils.getTimeAgo(context, date: DateTime.tryParse(widget.reviewDetails!.ratedOn!))}",
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.blackColor,
                                        fontSize: 12,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

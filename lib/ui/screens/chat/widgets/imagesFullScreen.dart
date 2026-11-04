import 'package:edemand_partner/app/generalImports.dart';
import 'package:edemand_partner/ui/screens/chat/widgets/commonImageView.dart';
import 'package:flutter/material.dart';

class ImagesFullScreen extends StatefulWidget {
  final List<String> listOfImages;
  final bool isFile;
  final int? initialPage;
  final String userName;
  final DateTime messageDateTime;

  const ImagesFullScreen({
    super.key,
    required this.listOfImages,
    required this.isFile,
    this.initialPage,
    required this.userName,
    required this.messageDateTime,
  });

  static Route route(RouteSettings routeSettings) {
    final List<String> multipleFiles =
        (routeSettings.arguments as Map?)?["images"] ?? [];
    final bool isItFile = (routeSettings.arguments as Map?)?["isFile"] ?? false;
    final int? initialPageNumber =
        (routeSettings.arguments as Map?)?["initialPage"];

    return CupertinoPageRoute(
      builder: (_) => ImagesFullScreen(
        listOfImages: multipleFiles,
        isFile: isItFile,
        initialPage: initialPageNumber,
        userName: (routeSettings.arguments as Map?)?["userName"] ?? '',
        messageDateTime:
            (routeSettings.arguments as Map?)?["messageDateTime"] ??
            DateTime.now(),
      ),
    );
  }

  @override
  State<ImagesFullScreen> createState() => _ImagesFullScreenState();
}

class _ImagesFullScreenState extends State<ImagesFullScreen> {
  late final ValueNotifier<int> _currentImageIndex;
  late final PageController _pageController;
  late final ScrollController _bottomItemsScrollController;
  bool isFullScreen = false;
  bool shareDownloadLoading = false;

  double bottomItemSize = 70;

  @override
  void initState() {
    final initialPage = widget.initialPage ?? 0;
    _currentImageIndex = ValueNotifier(initialPage);
    _pageController = PageController(initialPage: initialPage);
    _bottomItemsScrollController = ScrollController(
      initialScrollOffset: bottomItemSize * initialPage,
    );
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentImageIndex.dispose();
    super.dispose();
  }

  void _adjustBottomItemScroll({required int currentItemIndex}) {
    if (_bottomItemsScrollController.hasClients &&
        _bottomItemsScrollController.positions.isNotEmpty) {
      if (_bottomItemsScrollController.offset <
              ((bottomItemSize + 6) * currentItemIndex - 100) ||
          _bottomItemsScrollController.offset >
              ((bottomItemSize + 6) * currentItemIndex + 100)) {
        _bottomItemsScrollController.animateTo(
          (bottomItemSize + 6) * currentItemIndex,
          duration: const Duration(milliseconds: 250),
          curve: Curves.linear,
        );
      }
    }
  }

  Widget _topWidget() {
    return Container(
      padding: EdgeInsetsDirectional.only(
        top: MediaQuery.of(context).viewPadding.top,
        bottom: 15,
        start: 15,
        end: 15,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryColor,
      ),
      child: SizedBox(
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CustomBackArrow(),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.userName.isNotEmpty)
                    CustomText(
                      widget.userName,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.blackColor,
                      maxLines: 1,
                    ),
                  CustomText(
                    UiUtils.formatTimeWithDateTime(widget.messageDateTime),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.blackColor,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            if (!widget.isFile && !shareDownloadLoading)
              GestureDetector(
                onTap: () async {
                  if (shareDownloadLoading) {
                    return;
                  }
                  shareDownloadLoading = true;
                  setState(() {});
                  try {
                    await UiUtils.downloadOrShareFile(
                      isDownload: true,
                      url: widget.listOfImages[_currentImageIndex.value],
                      customFileName:
                          "${widget.userName}_${widget.messageDateTime.microsecondsSinceEpoch}_${_currentImageIndex.value}",
                    );
                  } catch (_) {
                    UiUtils.showMessage(
                      context,
                      "downloadFailed",
                      ToastificationType.error,
                    );
                  }
                  shareDownloadLoading = false;
                  setState(() {});
                },
                child: CustomContainer(
                  borderRadius: 5,
                  color: Theme.of(
                    context,
                  ).colorScheme.accentColor.withValues(alpha: 0.15),
                  padding: const EdgeInsets.all(10),
                  height: 40,
                  width: 40,
                  child: CustomSvgPicture(
                    svgImage: AppAssets.downloadIcon,
                    color: Theme.of(context).colorScheme.accentColor,
                  ),
                ),
              ),
            if (shareDownloadLoading)
              const SizedBox(
                height: 20,
                width: 20,
                child: CustomCircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _bottomWidget() {
    return widget.listOfImages.length == 1
        ? const SizedBox.shrink()
        : Container(
            padding: EdgeInsetsDirectional.only(
              bottom: MediaQuery.of(context).viewPadding.bottom + 10,
              top: 15,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryColor,
            ),
            child: SizedBox(
              height: bottomItemSize,
              child: ValueListenableBuilder<int>(
                valueListenable: _currentImageIndex,
                builder: (context, value, _) {
                  return ListView.builder(
                    controller: _bottomItemsScrollController,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsetsDirectional.only(
                      start: 100,
                      end: 100,
                    ),
                    physics: const ClampingScrollPhysics(),
                    itemCount: widget.listOfImages.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          _pageController.jumpToPage(index);
                          _adjustBottomItemScroll(currentItemIndex: index);
                        },
                        child: Container(
                          width: bottomItemSize,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: value == index
                                ? Border.all(
                                    color: AppColors.whiteColors,
                                    width: 3,
                                    strokeAlign: BorderSide.strokeAlignInside,
                                  )
                                : null,
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: CommonImageWidget(
                              imagePath: widget.listOfImages[index],
                              isFile: widget.isFile,
                              boxFit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: UiUtils.getSystemUiOverlayStyle(context: context),
      child: Scaffold(
        body: Stack(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isFullScreen = !isFullScreen;
                });
              },
              child: PageView(
                controller: _pageController,
                onPageChanged: (value) {
                  _currentImageIndex.value = value;
                  _adjustBottomItemScroll(currentItemIndex: value);
                },
                children: widget.listOfImages
                    .map(
                      (e) => InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 4,
                        child: Container(
                          alignment: Alignment.center,
                          child: CommonImageWidget(
                            imagePath: e,
                            isFile: widget.isFile,
                            boxFit: BoxFit.contain,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: AnimatedOpacity(
                opacity: !isFullScreen ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: _topWidget(),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedOpacity(
                opacity: !isFullScreen ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: _bottomWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

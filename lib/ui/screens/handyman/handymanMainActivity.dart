import 'package:edemand_partner/ui/widgets/unreadChatCounterBadgeContainer.dart';
import 'package:flutter/material.dart';

import '../../../app/generalImports.dart';

/// Handyman module navigation shell. Mirrors the provider [MainActivity] bottom
/// navigation and settings overlay, with role-filtered settings items.
class HandymanMainActivity extends StatefulWidget {
  const HandymanMainActivity({super.key});

  @override
  State<HandymanMainActivity> createState() => _HandymanMainActivityState();

  static Route<HandymanMainActivity> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(builder: (_) => const HandymanMainActivity());
  }
}

class _HandymanMainActivityState extends State<HandymanMainActivity>
    with TickerProviderStateMixin {
  ValueNotifier<int> selectedIndexOfBottomNavigationBar = ValueNotifier(0);

  late PageController pageController;

  List<ScrollController> scrollControllerList = [];

  bool _showOverlay = false;

  int? previousSelectedIndex;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 4; i++) {
      scrollControllerList.add(ScrollController());
    }
    pageController = PageController();
    context.read<FetchCountrySettingsCubit>().fetch();
    LocalAwesomeNotification.init(context).then((_) {
      context.read<EnquiryChatUserCubit>().fetchChatUsers();
      context.read<BookingChatUserCubit>().fetchChatUsers();
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    selectedIndexOfBottomNavigationBar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: UiUtils.getSystemUiOverlayStyle(context: context),
      child: PopScope(
        canPop: selectedIndexOfBottomNavigationBar.value == 0,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) {
            return;
          } else {
            if (selectedIndexOfBottomNavigationBar.value != 0) {
              selectedIndexOfBottomNavigationBar.value = 0;
              pageController.jumpToPage(
                selectedIndexOfBottomNavigationBar.value,
              );
            }
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              ValueListenableBuilder(
                valueListenable: selectedIndexOfBottomNavigationBar,
                builder: (BuildContext context, Object? value, Widget? child) {
                  return PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: pageController,
                    onPageChanged: onItemTapped,
                    children: [
                      HandymanDashboardScreen(
                        scrollController: scrollControllerList[0],
                      ),
                      HandymanBookingListScreen(
                        scrollController: scrollControllerList[1],
                      ),
                      HandymanCashCollectionScreen(
                        scrollController: scrollControllerList[2],
                      ),
                      ChatUsersScreen(
                        scrollController: scrollControllerList[3],
                      ),
                    ],
                  );
                },
              ),
              SettingsOverlay(
                role: AppUserRole.handyman,
                isVisible: _showOverlay,
                onToggle: _toggleOverlay,
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10,
                      left: 15,
                      right: 15,
                    ),
                    child: bottomBar(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleOverlay() {
    setState(() => _showOverlay = !_showOverlay);
  }

  void onItemTapped(int index) {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      selectedIndexOfBottomNavigationBar.value = index;
      if (_showOverlay) _showOverlay = false;
    });
    pageController.jumpToPage(selectedIndexOfBottomNavigationBar.value);
  }

  void bottomState(int index) {
    FocusManager.instance.primaryFocus?.unfocus();
    previousSelectedIndex = selectedIndexOfBottomNavigationBar.value;

    setState(() {
      selectedIndexOfBottomNavigationBar.value = index;
      pageController.jumpToPage(index);
    });

    try {
      if (previousSelectedIndex == selectedIndexOfBottomNavigationBar.value &&
          scrollControllerList[selectedIndexOfBottomNavigationBar.value]
              .positions
              .isNotEmpty) {
        scrollControllerList[selectedIndexOfBottomNavigationBar.value]
            .animateTo(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
      }
    } catch (_) {}
  }

  static Widget bottomBarTextButton(
    BuildContext context,
    int selectedIndex,
    int index,
    void Function() onPressed,
    String? imgName, {
    int? unreadNotificationCount,
  }) {
    return InkWell(
      onTap: () => onPressed(),
      child: Padding(
        padding: EdgeInsets.only(bottom: selectedIndex == index ? 2 : 0),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Align(
              child: CustomSvgPicture(
                svgImage: imgName!,
                color: selectedIndex != index
                    ? context.colorScheme.lightGreyColor
                    : context.colorScheme.accentColor,
              ),
            ),
            if ((unreadNotificationCount ?? 0) > 0)
              PositionedDirectional(
                top: 8,
                end: -4,
                child: UnreadChatCounterBadgeContainer(
                  count: unreadNotificationCount ?? 0,
                  padding: 4,
                  fontSize: 10,
                  margin: null,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget bottomBar() {
    return CustomContainer(
      height: kBottomNavigationBarHeight,
      color: context.colorScheme.secondaryColor,
      borderRadius: UiUtils.borderRadiusOf10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          bottomBarTextButton(
            context,
            selectedIndexOfBottomNavigationBar.value,
            0,
            () {
              bottomState(0);
            },
            AppAssets.home,
          ),
          bottomBarTextButton(
            context,
            selectedIndexOfBottomNavigationBar.value,
            1,
            () {
              bottomState(1);
            },
            AppAssets.booking,
          ),

          FloatingActionButton.small(
            heroTag: 'handyman_settings_fab',
            onPressed: _toggleOverlay,
            backgroundColor: context.colorScheme.accentColor,
            elevation: 0,
            shape: const CircleBorder(),
            child: Icon(
              _showOverlay
                  ? Icons.keyboard_arrow_down
                  : Icons.keyboard_arrow_up,
              size: 30,
              color: AppColors.whiteColors,
            ),
          ),

          bottomBarTextButton(
            context,
            selectedIndexOfBottomNavigationBar.value,
            2,
            () {
              bottomState(2);
            },
            AppAssets.ttlEarning,
          ),
          BlocBuilder<EnquiryChatUserCubit, ChatUsersState>(
            builder: (_, enquiryChatsState) {
              final enquiryCount = enquiryChatsState is ChatUsersFetchSuccess
                  ? enquiryChatsState.totalUnreadUsers
                  : 0;
              return BlocBuilder<BookingChatUserCubit, ChatUsersState>(
                builder: (_, bookingChatsState) {
                  final bookingCount =
                      bookingChatsState is ChatUsersFetchSuccess
                      ? bookingChatsState.totalUnreadUsers
                      : 0;
                  return bottomBarTextButton(
                    context,
                    selectedIndexOfBottomNavigationBar.value,
                    3,
                    () {
                      bottomState(3);
                    },
                    AppAssets.chat,
                    unreadNotificationCount: enquiryCount + bookingCount,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

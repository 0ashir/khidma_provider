import 'dart:ui';
import 'package:edemand_partner/ui/widgets/customGridView.dart';
import 'package:edemand_partner/ui/widgets/unreadChatCounterBadgeContainer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../app/generalImports.dart';

enum AppUserRole { provider, handyman }

class SettingsOverlay extends StatefulWidget {
  const SettingsOverlay({
    super.key,
    required this.role,
    required this.isVisible,
    required this.onToggle,
    this.supportUnreadCount,
    this.onSupportChatRead,
  });

  final AppUserRole role;
  final bool isVisible;
  final VoidCallback onToggle;
  final ValueListenable<int>? supportUnreadCount;
  final VoidCallback? onSupportChatRead;

  @override
  State<SettingsOverlay> createState() => _SettingsOverlayState();
}

class _SettingsOverlayState extends State<SettingsOverlay> {
  static const String _supportItemName = 'support';
  static const int _itemsPerPage = 9;

  static const List<({String name, String icon})> _providerItems = [
    (name: 'manageHandymenLbl', icon: AppAssets.drProfile),
    (name: 'slotManagement', icon: AppAssets.bClock),
    (name: 'notifications', icon: AppAssets.notification),
    (name: 'promoCodeLbl', icon: AppAssets.drPromoCode),
    (name: 'cashCollection', icon: AppAssets.drCashCollection),
    (name: 'settlementHistory', icon: AppAssets.drSettlementHistory),
    (name: 'withdrawalRequest', icon: AppAssets.drWithdrawalRequest),
    (name: 'bookingPaymentManagement', icon: AppAssets.drBookingPayment),
    (name: 'reviewsTitleLbl', icon: AppAssets.reviews),
    (name: 'subscriptions', icon: AppAssets.drSubscription),
    (name: 'seo', icon: AppAssets.search),
    (name: _supportItemName, icon: AppAssets.support),
    (name: 'changePassword', icon: AppAssets.drChangePass),
    (name: 'aboutUs', icon: AppAssets.drAboutUs),
    (name: 'contactUs', icon: AppAssets.drContactUs),
    (name: 'customPagesLbl', icon: AppAssets.drTermsConditions),
    (name: 'shareApp', icon: AppAssets.drShareApp),
    (name: 'languageLbl', icon: AppAssets.drLanguage),
    (name: 'darkThemeLbl', icon: AppAssets.drTheme),
    (name: 'logoutLbl', icon: AppAssets.drLogout),
    (name: 'deleteAccount', icon: AppAssets.drDeleteAccount),
  ];

  static const List<({String name, String icon})> _handymanItems = [
    (name: 'notifications', icon: AppAssets.notification),
    (name: 'reviewsTitleLbl', icon: AppAssets.reviews),
    (name: 'changePassword', icon: AppAssets.drChangePass),
    (name: 'aboutUs', icon: AppAssets.drAboutUs),
    (name: 'contactUs', icon: AppAssets.drContactUs),
    (name: 'customPagesLbl', icon: AppAssets.drTermsConditions),
    (name: 'shareApp', icon: AppAssets.drShareApp),
    (name: 'languageLbl', icon: AppAssets.drLanguage),
    (name: 'darkThemeLbl', icon: AppAssets.drTheme),
    (name: 'logoutLbl', icon: AppAssets.drLogout),
  ];

  late List<({String name, String icon})> _orderedGridItems;
  bool _subscriptionsEnabled = false;

  List<({String name, String icon})> get _gridItems => _orderedGridItems
      .where((item) => item.name != 'subscriptions' || _subscriptionsEnabled)
      .toList();
  final PageController _pageController = PageController();
  int _currentPage = 0;
  double _draggedItemSize = 80.0;
  bool _autoScrolling = false;

  int get _pagesCount => (_gridItems.length / _itemsPerPage).ceil();

  String get _storageKey => widget.role == AppUserRole.provider
      ? MainActivityRepository.key
      : MainActivityRepository.handymanKey;

  @override
  void initState() {
    super.initState();
    _orderedGridItems = List.of(
      widget.role == AppUserRole.provider ? _providerItems : _handymanItems,
    );
    _loadSavedPositions();
  }

  @override
  void didUpdateWidget(SettingsOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isVisible && !widget.isVisible) {
      _savePositions();
    }
    if (!oldWidget.isVisible && widget.isVisible) {
      context.read<GetVerificationStatusCubit>().fetch();
      if (widget.role == AppUserRole.provider) {
        context.read<FetchSystemSettingsCubit>().getSettings(
          isAnonymous: false,
        );
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedPositions() async {
    final loaded = await MainActivityRepository.loadPositions(
      _orderedGridItems,
      storageKey: _storageKey,
    );
    if (loaded.isNotEmpty && mounted) {
      setState(() => _orderedGridItems = loaded);
    }
  }

  Future<void> _savePositions() async {
    await MainActivityRepository.savePositions(
      _orderedGridItems,
      storageKey: _storageKey,
    );
  }

  @override
  Widget build(BuildContext context) {
    _subscriptionsEnabled = context
        .watch<FetchSystemSettingsCubit>()
        .subscriptionsEnabled;
    return IgnorePointer(
      ignoring: !widget.isVisible,
      child: SafeArea(
        top: false,
        child: Stack(
          children: [
            if (widget.isVisible)
              GestureDetector(
                onTap: widget.onToggle,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 1000),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: CustomContainer(
                      color: context.colorScheme.blackColor.withValues(
                        alpha: .2,
                      ),
                    ),
                  ),
                ),
              ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              left: 20,
              right: 20,
              bottom: widget.isVisible ? 80 : 20,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                width: widget.isVisible
                    ? MediaQuery.of(context).size.width * 0.9
                    : 0,
                height: widget.isVisible ? null : 0,
                decoration: BoxDecoration(
                  color: context.colorScheme.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 8),
                  ],
                ),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildProfileHeader(context),
                      const Divider(
                        thickness: 0.2,
                        indent: 50.0,
                        endIndent: 30.0,
                      ),
                      if (widget.role == AppUserRole.provider)
                        CustomJobRequestSection(
                          jobRequests: UiUtils.customRequestCounter,
                        ),
                      SizedBox(
                        height: 290,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _pagesCount,
                          onPageChanged: (index) {
                            setState(() => _currentPage = index);
                          },
                          itemBuilder: (context, pageIndex) {
                            return _buildGridView(pageIndex);
                          },
                        ),
                      ),
                      if (_pagesCount != 1) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _pagesCount,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.all(4),
                              width: _currentPage == index ? 12 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _currentPage == index
                                    ? context.colorScheme.accentColor
                                    : context.colorScheme.lightGreyColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    if (widget.role == AppUserRole.provider) {
      return _buildProviderHeader(context);
    }
    return _buildHandymanHeader(context);
  }

  Widget _buildProviderHeader(BuildContext context) {
    final providerInfo = context
        .watch<ProviderDetailsCubit>()
        .providerDetails
        .providerInformation;

    final name =
        providerInfo?.getTranslatedUsername(
          HiveRepository.getCurrentLanguage()?.languageCode ?? 'en',
        ) ??
        '';
    final email =
        context.watch<ProviderDetailsCubit>().providerDetails.user?.email ?? '';
    final imageUrl =
        context.watch<ProviderDetailsCubit>().providerDetails.user?.image ?? '';

    return _buildProfileRow(
      context,
      name: name,
      email: email,
      imageUrl: imageUrl,
      showEditBtn: true,
      onEditTap: () {
        widget.onToggle();
        Navigator.pushNamed(
          context,
          Routes.registration,
          arguments: {'isEditing': true},
        );
      },
      verificationBadge: _buildVerificationBadge(context),
    );
  }

  Widget _buildVerificationBadge(BuildContext context) {
    return BlocBuilder<GetVerificationStatusCubit, GetVerificationStatusState>(
      builder: (context, state) {
        VerificationRequestStatus status = VerificationRequestStatus.none;
        if (state is GetVerificationStatusSuccess) {
          status = state.status.status;
        }

        final IconData icon;
        final Color color;
        final String label;
        switch (status) {
          case VerificationRequestStatus.approved:
            icon = Icons.verified_rounded;
            color = Colors.green.shade700;
            label = 'verifiedLbl'.translate(context: context);
            break;
          case VerificationRequestStatus.pending:
            icon = Icons.hourglass_top_rounded;
            color = Colors.orange.shade800;
            label = 'pending'.translate(context: context);
            break;
          case VerificationRequestStatus.disapproved:
            icon = Icons.error_outline_rounded;
            color = AppColors.redColor;
            label = 'rejected'.translate(context: context);
            break;
          case VerificationRequestStatus.none:
            icon = Icons.shield_outlined;
            color = context.colorScheme.accentColor;
            label = 'verifyLbl'.translate(context: context);
            break;
        }

        return GestureDetector(
          onTap: () {
            widget.onToggle();
            Navigator.pushNamed(context, Routes.providerVerification);
          },
          child: Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: color.withValues(alpha: 0.35)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 12, color: color),
                const SizedBox(width: 3),
                CustomText(
                  label,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                const SizedBox(width: 2),
                Icon(Icons.chevron_right_rounded, size: 13, color: color),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHandymanHeader(BuildContext context) {
    return BlocBuilder<HandymanProfileCubit, HandymanProfileState>(
      builder: (context, state) {
        final profile = state.currentProfile;
        return _buildProfileRow(
          context,
          name: profile?.username ?? '',
          email: profile?.email ?? '',
          imageUrl: profile?.image ?? '',
          showEditBtn: true,
          onEditTap: () {
            if (profile != null) {
              widget.onToggle();
              Navigator.pushNamed(
                context,
                Routes.handymanEditProfile,
                arguments: profile,
              );
            }
          },
        );
      },
    );
  }

  Widget _buildProfileRow(
    BuildContext context, {
    required String name,
    required String email,
    required String imageUrl,
    required bool showEditBtn,
    VoidCallback? onEditTap,
    Widget? verificationBadge,
  }) {
    return CustomContainer(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
      child: Row(
        children: [
          CustomContainer(
            width: 50,
            height: 50,
            borderRadius: UiUtils.borderRadiusOf10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(UiUtils.borderRadiusOf10),
              child: imageUrl.isNotEmpty
                  ? CustomCachedNetworkImage(imageUrl: imageUrl)
                  : const CustomSvgPicture(svgImage: AppAssets.drProfile),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  name,
                  color: Theme.of(context).colorScheme.blackColor,
                  fontWeight: FontWeight.w700,
                ),
                CustomText(
                  email,
                  color: Theme.of(context).colorScheme.blackColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  maxLines: 2,
                ),
                if (verificationBadge != null) verificationBadge,
              ],
            ),
          ),
          if (showEditBtn)
            CustomSvgPicture(
              svgImage: AppAssets.edit,
              color: context.colorScheme.accentColor,
              height: 20,
              width: 20,
              onTap: onEditTap,
            ),
        ],
      ),
    );
  }

  Widget _buildGridView(int pageIndex) {
    final int startIndex = pageIndex * _itemsPerPage;
    final int endIndex = (startIndex + _itemsPerPage).clamp(
      0,
      _gridItems.length,
    );
    final itemsForPage = _gridItems.sublist(startIndex, endIndex);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              height: 80,
            ),
        shrinkWrap: true,
        itemCount: itemsForPage.length,
        itemBuilder: (context, index) {
          return _buildDraggableItem(startIndex + index);
        },
      ),
    );
  }

  Widget _buildDraggableItem(int index) {
    return LongPressDraggable<int>(
      data: index,
      key: ValueKey(_gridItems[index].name),
      onDragUpdate: _handleAutoScroll,
      onDragStarted: () {
        setState(() => _draggedItemSize = 60);
      },
      onDraggableCanceled: (_, __) {
        setState(() => _draggedItemSize = 80);
      },
      feedback: Material(
        color: Colors.transparent,
        child: _buildBox(_gridItems[index], true),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _buildBox(_gridItems[index], false),
      ),
      child: DragTarget<int>(
        onWillAcceptWithDetails: (details) => true,
        onAcceptWithDetails: (details) {
          final draggedIndex = details.data;
          if (draggedIndex == index) return;
          setState(() {
            final draggedItem = _gridItems[draggedIndex];
            final targetItem = _gridItems[index];
            _orderedGridItems.remove(draggedItem);
            final targetIndex = _orderedGridItems.indexOf(targetItem);
            _orderedGridItems.insert(
              targetIndex + (draggedIndex < index ? 1 : 0),
              draggedItem,
            );
            _savePositions();
          });
        },
        builder: (context, candidateData, rejectedData) {
          return Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () => _onItemTap(_gridItems[index].name, context),
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  tween: Tween<double>(
                    begin: _draggedItemSize,
                    end: _draggedItemSize,
                  ),
                  builder: (context, size, child) {
                    return SizedBox(width: size, height: size, child: child);
                  },
                  child: _buildBox(_gridItems[index], false),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBox(({String name, String icon}) item, bool isDragging) {
    if (item.name == _supportItemName && widget.supportUnreadCount != null) {
      return ValueListenableBuilder<int>(
        valueListenable: widget.supportUnreadCount!,
        builder: (_, count, _) => _buildBoxContent(item, isDragging, count),
      );
    }
    return _buildBoxContent(item, isDragging, 0);
  }

  Widget _buildBoxContent(
    ({String name, String icon}) gridItem,
    bool isDragging,
    int unreadCount,
  ) {
    return CustomContainer(
      padding: isDragging ? const EdgeInsets.all(20) : null,
      alignment: Alignment.center,
      color: isDragging
          ? context.colorScheme.secondaryColor.withValues(alpha: 0.7)
          : context.colorScheme.secondaryColor,
      borderRadius: UiUtils.borderRadiusOf10,
      border: Border.all(
        color: context.colorScheme.lightGreyColor.withValues(alpha: 0.2),
        width: 0.5,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CustomSvgPicture(
                svgImage: gridItem.icon,
                color: context.colorScheme.accentColor,
                width: 20,
                height: 20,
              ),
              if (unreadCount > 0)
                PositionedDirectional(
                  top: -6,
                  end: -6,
                  child: UnreadChatCounterBadgeContainer(
                    count: unreadCount,
                    padding: 4,
                    fontSize: 10,
                    margin: null,
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: CustomText(
              gridItem.name == 'darkThemeLbl'
                  ? (context.watch<AppThemeCubit>().state.appTheme ==
                            AppTheme.dark
                        ? 'lightThemeLbl'.translate(context: context)
                        : 'darkThemeLbl'.translate(context: context))
                  : gridItem.name.translate(context: context),
              color: context.colorScheme.blackColor,
              maxLines: 2,
              fontSize: 10,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void _handleAutoScroll(DragUpdateDetails details) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double position = details.globalPosition.dx;

    if (!_autoScrolling) {
      if (_currentPage == 0 && position > screenWidth * 0.9) {
        _autoScrolling = true;
        _pageController
            .nextPage(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
            )
            .then((_) {
              setState(() => _autoScrolling = false);
            });
      } else if (_currentPage == 1 && position < screenWidth * 0.1) {
        _autoScrolling = true;
        _pageController
            .previousPage(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
            )
            .then((_) {
              setState(() => _autoScrolling = false);
            });
      }
    }
  }

  void _onItemTap(String name, BuildContext context) {
    if (name == 'manageHandymenLbl') {
      widget.onToggle();
      Navigator.of(context).pushNamed(Routes.manageHandymen);
    } else if (name == 'slotManagement') {
      widget.onToggle();
      Navigator.of(context).pushNamed(Routes.slotManagement);
    } else if (name == 'notifications') {
      widget.onToggle();
      Navigator.of(context).pushNamed(Routes.notificationsScreen);
    } else if (name == 'promoCodeLbl') {
      widget.onToggle();
      Navigator.of(context).pushNamed(Routes.promoCode);
    } else if (name == 'cashCollection') {
      widget.onToggle();
      Navigator.of(context).pushNamed(Routes.cashCollection);
    } else if (name == 'settlementHistory') {
      widget.onToggle();
      Navigator.of(context).pushNamed(Routes.settlementHistoryScreen);
    } else if (name == 'withdrawalRequest') {
      widget.onToggle();
      Navigator.of(context).pushNamed(Routes.withdrawalRequests);
    } else if (name == 'bookingPaymentManagement') {
      widget.onToggle();
      Navigator.of(context).pushNamed(Routes.bookingPaymentDataScreen);
    } else if (name == 'reviewsTitleLbl') {
      widget.onToggle();
      if (widget.role == AppUserRole.handyman) {
        Navigator.pushNamed(context, Routes.handymanReviewsScreen);
      } else {
        Navigator.pushNamed(context, Routes.reviewsScreen);
      }
    } else if (name == 'subscriptions') {
      widget.onToggle();
      Navigator.of(context)
          .pushNamed(Routes.subscriptionScreen, arguments: {"from": "drawer"})
          .then((value) {
            if (mounted && value == 'subscription') {
              context.read<FetchHomeDataCubit>().getHomeData();
            }
          });
    } else if (name == 'languageLbl') {
      widget.onToggle();
      Navigator.pushNamed(
        context,
        Routes.languageSelectionScreen,
        arguments: {"title": "selectLanguage"},
      );
    } else if (name == 'darkThemeLbl') {
      context.read<AppThemeCubit>().toggleTheme();
    } else if (name == 'contactUs') {
      widget.onToggle();
      Navigator.pushNamed(context, Routes.contactUsRoute);
    } else if (name == 'aboutUs') {
      widget.onToggle();
      Navigator.pushNamed(
        context,
        Routes.customPageDetailsRoute,
        arguments: {'title': 'aboutUs', 'pageKey': 'about_us'},
      );
    } else if (name == 'customPagesLbl') {
      widget.onToggle();
      Navigator.pushNamed(context, Routes.customPages);
    } else if (name == 'changePassword') {
      widget.onToggle();
      Navigator.pushNamed(context, Routes.changePassword);
    } else if (name == 'shareApp') {
      UiUtils.share(
        context: context,
        context.read<FetchSystemSettingsCubit>().getProviderAppURL,
      );
    } else if (name == 'logoutLbl') {
      widget.onToggle();
      UiUtils.showAnimatedDialog(
        context: context,
        child: const LogoutAccountDialog(),
      );
    } else if (name == 'deleteAccount') {
      widget.onToggle();
      UiUtils.showAnimatedDialog(
        context: context,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<DeleteProviderAccountCubit>(
              create: (BuildContext context) => DeleteProviderAccountCubit(),
            ),
            BlocProvider<SignInCubit>(
              create: (BuildContext context) => SignInCubit(),
            ),
          ],
          child: DeleteProviderAccountDialog(),
        ),
      );
    } else if (name == 'seo') {
      widget.onToggle();
      Navigator.of(context).pushNamed(Routes.seoSettings);
    } else if (name == _supportItemName) {
      widget.onToggle();
      Navigator.pushNamed(
        context,
        Routes.chatMessages,
        arguments: {
          "chatUser": ChatUser(
            customerId: '0',
            customerName: "customerSupport".translate(context: context),
            unReadChats: 0,
            bookingId: null,
            chatUserType: ChatUserType.adminSupport,
            image: '',
          ),
        },
      ).then((_) {
        widget.onSupportChatRead?.call();
      });
    }
  }
}

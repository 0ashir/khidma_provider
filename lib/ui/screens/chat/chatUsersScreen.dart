import 'package:edemand_partner/app/generalImports.dart';
import 'package:edemand_partner/ui/widgets/customTooltipContainer.dart';
import 'package:edemand_partner/ui/widgets/unreadChatCounterBadgeContainer.dart';

import 'package:flutter/material.dart';

class ChatUsersScreen extends StatelessWidget {
  const ChatUsersScreen({super.key, required this.scrollController});
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ChatUsersScreenWidget(scrollController: scrollController);
  }
}

class ChatUsersScreenWidget extends StatefulWidget {
  const ChatUsersScreenWidget({super.key, required this.scrollController});
  final ScrollController scrollController;

  @override
  _ChatUsersScreenWidgetState createState() => _ChatUsersScreenWidgetState();
}

class _ChatUsersScreenWidgetState extends State<ChatUsersScreenWidget>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
  );
  late Animation<double> fontAnimation = Tween<double>(begin: 22.0, end: 20.0)
      .animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
          reverseCurve: Curves.easeInOut,
        ),
      );
  late Animation<double> fontAnimation2 = Tween<double>(begin: 16.0, end: 8.0)
      .animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
          reverseCurve: Curves.easeInOut,
        ),
      );

  late final List<ChatUsersCubit> _chatUserCubitList =
      HiveRepository.isHandymanSession
      ? [context.read<BookingChatUserCubit>()]
      : [
          context.read<EnquiryChatUserCubit>(),
          context.read<BookingChatUserCubit>(),
        ];

  late TabController _typeTabController;

  late ValueNotifier<ChatUsersCubit> selectedCubit = ValueNotifier(
    _chatUserCubitList.first,
  );

  void scrollListener() {
    _animationController.value = UiUtils.inRange(
      currentValue: widget.scrollController.offset,
      minValue: widget.scrollController.position.minScrollExtent,
      maxValue: widget.scrollController.position.maxScrollExtent,
      newMaxValue: 1.0,
      newMinValue: 0.0,
    );
  }

  @override
  void initState() {
    _typeTabController = TabController(
      length: _chatUserCubitList.length,
      vsync: this,
    );
    _typeTabController.addListener(() {
      if (!_typeTabController.indexIsChanging) {
        selectedCubit.value = _chatUserCubitList[_typeTabController.index];
      }
    });
    widget.scrollController.addListener(scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _typeTabController.dispose();
    _animationController.dispose();
    widget.scrollController.removeListener(scrollListener);
    widget.scrollController.dispose();
    super.dispose();
  }

  Widget _buildTabBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 70),
      child: CustomContainer(
        height: 55,
        borderRadius: UiUtils.borderRadiusOf50,
        border: Border.all(
          color: context.colorScheme.lightGreyColor,
          width: 0.2,
        ),
        color: context.colorScheme.secondaryColor,
        child: TabBar(
          indicatorColor: Colors.transparent,
          labelPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          indicatorPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          dividerColor: Colors.transparent,
          indicator: BoxDecoration(
            color: context.colorScheme.accentColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(UiUtils.borderRadiusOf50),
            ),
          ),
          controller: _typeTabController,
          labelColor: context.colorScheme.secondaryColor,
          unselectedLabelColor: context.colorScheme.blackColor,
          tabs: _chatUserCubitList.map((status) {
            return Tab(
              child: CustomContainer(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        status.filterType.translate(context: context),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    BlocBuilder<ChatUsersCubit, ChatUsersState>(
                      bloc: status,
                      builder: (context, state) {
                        if (state is ChatUsersFetchSuccess &&
                            state.totalUnreadUsers > 0) {
                          return UnreadChatCounterBadgeContainer(
                            count: state.totalUnreadUsers,
                            margin: const EdgeInsetsDirectional.only(start: 4),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          isScrollable: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: UiUtils.getSystemUiOverlayStyle(context: context),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primaryColor,
          body: Stack(
            children: [
              NestedScrollView(
                controller: widget.scrollController,
                headerSliverBuilder: (context, _) {
                  return [
                    SliverPersistentHeader(
                      delegate: AppBarPersistentHeaderDelegate(
                        child: Center(
                          child: AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, _) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          CustomText(
                                            'chats'.translate(context: context),
                                            fontSize: fontAnimation.value,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.blackColor,
                                          ),
                                          ValueListenableBuilder<
                                            ChatUsersCubit
                                          >(
                                            valueListenable: selectedCubit,
                                            builder: (context, cubit, _) {
                                              return BlocBuilder<
                                                ChatUsersCubit,
                                                ChatUsersState
                                              >(
                                                bloc: cubit,
                                                builder: (context, state) {
                                                  if (state
                                                      is ChatUsersFetchSuccess) {
                                                    return HeadingAmountAnimation(
                                                      key: ValueKey(
                                                        state.totalOffset,
                                                      ),
                                                      text:
                                                          '${state.totalOffset.toString()} ${'chats'.translate(context: context)}',
                                                      textStyle: TextStyle(
                                                        color: context
                                                            .colorScheme
                                                            .lightGreyColor,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: fontAnimation2
                                                            .value,
                                                      ),
                                                    );
                                                  } else {
                                                    return SizedBox(
                                                      width:
                                                          MediaQuery.of(
                                                            context,
                                                          ).size.width *
                                                          0.7,
                                                      height:
                                                          fontAnimation2.value,
                                                    );
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      if (!HiveRepository.isHandymanSession)
                                        PositionedDirectional(
                                          end: 15,
                                          child: CustomToolTip(
                                            toolTipMessage: "blockedByUsers"
                                                .translate(context: context),
                                            child: CustomInkWellContainer(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  Routes.blockUserScreen,
                                                );
                                              },
                                              child: CustomSvgPicture(
                                                height: 20,
                                                width: 20,
                                                svgImage:
                                                    AppAssets.drBlockedUsers,
                                                color: context
                                                    .colorScheme
                                                    .blackColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  const CustomShadowLineForDevider(
                                    direction: ShadowDirection.centerToSides,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      pinned: true,
                    ),
                  ];
                },
                body: TabBarView(
                  controller: _typeTabController,
                  children: _chatUserCubitList.map((e) {
                    return _ChatUserListContainer(chatUsersCubit: e);
                  }).toList(),
                ),
              ),
              if (!HiveRepository.isHandymanSession)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildTabBar(context),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _ChatUserListContainer extends StatefulWidget {
  final ChatUsersCubit chatUsersCubit;
  const _ChatUserListContainer({required this.chatUsersCubit});

  @override
  State<_ChatUserListContainer> createState() => __ChatUserListContainerState();
}

class __ChatUserListContainerState extends State<_ChatUserListContainer>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final state = widget.chatUsersCubit.state;
    if (state is ChatUsersInitial || state is ChatUsersFetchFailure) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        fetchChatUsers();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildShimmerLoader() {
    return LayoutBuilder(
      builder: (context, boxConstraints) {
        return SizedBox(
          height: double.maxFinite,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context, index) {
              return _buildOneChatUserShimmerLoader();
            },
          ),
        );
      },
    );
  }

  Widget _buildOneChatUserShimmerLoader() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: ShimmerLoadingContainer(
        child: CustomShimmerContainer(height: 80, borderRadius: 0),
      ),
    );
  }

  void fetchChatUsers() {
    widget.chatUsersCubit.fetchChatUsers();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<ChatUsersCubit, ChatUsersState>(
      bloc: widget.chatUsersCubit,
      builder: (context, state) {
        if (state is ChatUsersFetchSuccess) {
          return state.chatUsers.isEmpty
              ? SizedBox(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(
                        child: NoDataContainer(
                          title: "noChatsFound".translate(context: context),
                          subTitle: "noChatsFoundSubTitle".translate(
                            context: context,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : CustomRefreshIndicator(
                  onRefresh: () async {
                    fetchChatUsers();
                  },
                  child: SizedBox(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    child: NotificationListener<ScrollUpdateNotification>(
                      onNotification: (ScrollUpdateNotification notification) {
                        if (notification.metrics.pixels >=
                            notification.metrics.maxScrollExtent) {
                          if (widget.chatUsersCubit.hasMore()) {
                            widget.chatUsersCubit.fetchMoreChatUsers();
                          }
                        }
                        return false;
                      },
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ).add(const EdgeInsets.only(bottom: 140)),
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            ...List.generate(state.chatUsers.length, (index) {
                              final currentChatUser = state.chatUsers[index];

                              return ChatUserItemWidget(
                                chatUser: currentChatUser,
                                chatUsersCubit: widget.chatUsersCubit,
                              );
                            }),
                            if (state.moreChatUserFetchProgress)
                              _buildOneChatUserShimmerLoader(),
                            if (state.moreChatUserFetchError &&
                                !state.moreChatUserFetchProgress)
                              CustomLoadingMoreContainer(
                                isError: true,
                                onErrorButtonPressed: () {
                                  widget.chatUsersCubit.fetchMoreChatUsers();
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
        }
        if (state is ChatUsersFetchFailure) {
          return Center(
            child: ErrorContainer(
              errorMessage: state.errorMessage,
              onTapRetry: () {
                fetchChatUsers();
              },
            ),
          );
        }
        return _buildShimmerLoader();
      },
    );
  }
}

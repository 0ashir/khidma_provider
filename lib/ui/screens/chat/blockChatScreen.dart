import 'package:edemand_partner/app/generalImports.dart';
import 'package:edemand_partner/cubits/chat/getBlockUserList.dart';
import 'package:edemand_partner/cubits/chat/unblockUserCubit.dart';
import 'package:edemand_partner/ui/widgets/customWarningBottomSheet.dart';
import 'package:flutter/material.dart';

class BlockChatScreen extends StatefulWidget {
  const BlockChatScreen({super.key});

  static Route route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => GetBlockedUsersCubit(ChatRepository()),
          ),
          BlocProvider(create: (context) => UnblockUserCubit(ChatRepository())),
        ],
        child: const BlockChatScreen(),
      ),
    );
  }

  @override
  State<BlockChatScreen> createState() => _BlockChatScreenState();
}

class _BlockChatScreenState extends State<BlockChatScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GetBlockedUsersCubit>().getBlockedUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiUtils.getSimpleAppBar(
        statusBarColor: context.colorScheme.secondaryColor,
        context: context,
        title: 'blockedByUsers'.translate(context: context),
        elevation: 1,
      ),
      body: BlocBuilder<GetBlockedUsersCubit, GetBlockedUsersState>(
        builder: (context, state) {
          if (state is GetBlockedUsersInProgress) {
            return const Center(child: CustomCircularProgressIndicator());
          }
          if (state is GetBlockedUsersFailure) {
            return ErrorContainer(
              errorMessage: state.errorMessage,
              showRetryButton: true,
              onTapRetry: () {
                context.read<GetBlockedUsersCubit>().getBlockedUsers();
              },
            );
          }
          if (state is GetBlockedUsersSuccess) {
            if (state.blockedUsers.isEmpty) {
              return Center(
                child: NoDataContainer(
                  title: "noBlockedUsers".translate(context: context),
                  subTitle: 'noBlockedUsersSubTitle'.translate(
                    context: context,
                  ),
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<GetBlockedUsersCubit>().getBlockedUsers();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.blockedUsers.length,
                itemBuilder: (context, index) {
                  final user = state.blockedUsers[index];
                  return CustomContainer(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    borderRadius: UiUtils.borderRadiusOf10,
                    color: Theme.of(context).colorScheme.secondaryColor,
                    child: Row(
                      children: [
                        CustomContainer(
                          height: 50,
                          width: 50,
                          borderRadius: UiUtils.borderRadiusOf50,
                          image: user.image != null
                              ? DecorationImage(
                                  image: NetworkImage(user.image!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                          child: user.image == null
                              ? Icon(
                                  Icons.person,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.accentColor,
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                user.username ?? 'Unknown User',
                                color: Theme.of(context).colorScheme.blackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              if (user.reason != null) ...[
                                const SizedBox(height: 4),
                                CustomText(
                                  user.reason!,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.lightGreyColor,
                                  fontSize: 14,
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        CustomRoundedButton(
                          buttonTitle: 'unblock'.translate(context: context),
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.accentColor,
                          showBorder: false,
                          widthPercentage: 0.25,
                          onTap: () {
                            UiUtils.showModelBottomSheets(
                              context: context,
                              child: MultiBlocProvider(
                                providers: [
                                  BlocProvider.value(
                                    value: context.read<GetBlockedUsersCubit>(),
                                  ),
                                  BlocProvider<UnblockUserCubit>(
                                    create: (context) =>
                                        UnblockUserCubit(ChatRepository()),
                                  ),
                                ],
                                child:
                                    BlocConsumer<
                                      UnblockUserCubit,
                                      UnblockUserState
                                    >(
                                      listener: (context, state) {
                                        if (state is UnblockUserSuccess) {
                                          // Remove user from the list locally
                                          context
                                              .read<GetBlockedUsersCubit>()
                                              .unblockUser(state.userId);
                                          UiUtils.showMessage(
                                            context,
                                            'unblockedSuccessfully'.translate(
                                              context: context,
                                            ),
                                            ToastificationType.success,
                                          );
                                          Navigator.pop(context);
                                        }
                                        if (state is UnblockUserFailure) {
                                          UiUtils.showMessage(
                                            context,
                                            state.errorMessage,
                                            ToastificationType.error,
                                          );
                                          Navigator.pop(context);
                                        }
                                      },
                                      builder: (context, state) {
                                        return CustomWarningBottomSheet(
                                          closeText: 'close'.translate(
                                            context: context,
                                          ),
                                          conformButtonColor:
                                              state is UnblockUserInProgress
                                              ? context
                                                    .colorScheme
                                                    .lightGreyColor
                                              : null,
                                          conformText: 'unblock'.translate(
                                            context: context,
                                          ),
                                          onTapCloseText: () {
                                            Navigator.pop(context);
                                          },
                                          detailsWarningMessage:
                                              'unblockUserWarning'.translate(
                                                context: context,
                                              ),
                                          onTapConformText: () async {
                                            if (state
                                                is UnblockUserInProgress) {
                                              return;
                                            }
                                            await context
                                                .read<UnblockUserCubit>()
                                                .unblockUser(user.id!);
                                          },
                                        );
                                      },
                                    ),
                              ),
                            );
                          },
                          textSize: 14,
                          height: 36,
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

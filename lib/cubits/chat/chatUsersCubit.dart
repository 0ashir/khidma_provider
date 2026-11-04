import 'dart:async';

import 'package:edemand_partner/data/model/chat/chatNotificationData.dart';
import 'package:edemand_partner/data/model/chat/chatUser.dart';
import 'package:edemand_partner/data/repository/chat/chatRepository.dart';
import 'package:edemand_partner/utils/notification/chatNotificationsUtils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ChatUsersState {}

class ChatUsersInitial extends ChatUsersState {}

class ChatUsersFetchInProgress extends ChatUsersState {}

class ChatUsersFetchFailure extends ChatUsersState {
  final String errorMessage;

  ChatUsersFetchFailure({required this.errorMessage});
}

class ChatUsersFetchSuccess extends ChatUsersState {
  final List<ChatUser> chatUsers;
  final int totalOffset;
  final bool moreChatUserFetchError;
  final bool moreChatUserFetchProgress;
  final int totalUnreadUsers;

  ChatUsersFetchSuccess({
    required this.chatUsers,
    required this.totalOffset,
    required this.moreChatUserFetchError,
    required this.moreChatUserFetchProgress,
    required this.totalUnreadUsers,
  });

  ChatUsersFetchSuccess copyWith({
    List<ChatUser>? newChatUsers,
    int? newTotalOffset,
    bool? newFetchMorechatUsersInProgress,
    bool? newFetchMorechatUsersError,
    int? newTotalUnreadUsers,
  }) {
    return ChatUsersFetchSuccess(
      chatUsers: newChatUsers ?? chatUsers,
      totalOffset: newTotalOffset ?? totalOffset,
      moreChatUserFetchProgress:
          newFetchMorechatUsersInProgress ?? moreChatUserFetchProgress,
      moreChatUserFetchError:
          newFetchMorechatUsersError ?? moreChatUserFetchError,
      totalUnreadUsers: newTotalUnreadUsers ?? totalUnreadUsers,
    );
  }
}

abstract class ChatUsersCubit extends Cubit<ChatUsersState> {
  final ChatRepository _chatRepository;

  ChatUsersCubit(this._chatRepository) : super(ChatUsersInitial());
  StreamSubscription<ChatNotificationData>? _streamSubscription;

  String get filterType;

  void registerNotificationListener() {
    if (_streamSubscription != null) {
      _streamSubscription!.cancel();
      _streamSubscription = null;
    }
    _streamSubscription = ChatNotificationsUtils
        .notificationStreamController
        ?.stream
        .listen((event) {
          if (event.fromUser.chatUserType != ChatUserType.adminSupport) {
            makeUserFirstOrAddFirst(event.fromUser);
          }
        });
  }

  void makeUserFirstOrAddFirst(
    ChatUser chatUser, {
    bool isFromSendingMessage = false,
  }) {
    if (state is ChatUsersFetchSuccess) {
      final stateAs = state as ChatUsersFetchSuccess;
      int? index;
      try {
        index = stateAs.chatUsers.indexWhere((element) {
          return element == chatUser;
        });
      } catch (_) {}
      //if already has that user, replace it and make it first as the latest message is from them
      if (index != null && index >= 0) {
        final tempList = List<ChatUser>.from(stateAs.chatUsers);
        //if we have 0 count, but a new message came, increase count by 1
        final bool increaseUserCount =
            tempList[index].unreadNotificationsCount == 0;
        if (chatUser.hashCode ==
            ChatNotificationsUtils.currentChattingUserHashCode) {
          //we're actively viewing this chat, so it's read as it arrives -
          //don't let the raw server unread count leak into the list item.
          chatUser.unReadChats = 0;
        } else if (!isFromSendingMessage) {
          chatUser.unReadChats = tempList[index].unreadNotificationsCount + 1;
        }
        // final mergedUser = (chatUser.image?.isEmpty ?? true)
        //     ? chatUser.copyWith(image: tempList[index].image)
        //     : chatUser;
        // tempList.removeAt(index);
        // tempList.insert(0, mergedUser);
        tempList.removeAt(index);
        tempList.insert(0, chatUser);
        emit(
          stateAs.copyWith(
            newChatUsers: tempList,
            newTotalUnreadUsers:
                increaseUserCount &&
                    chatUser.hashCode !=
                        ChatNotificationsUtils.currentChattingUserHashCode
                ? stateAs.totalUnreadUsers + 1
                : null,
          ),
        );
      } else {
        //if not already there, check whether the new user matches the active filters
        //before inserting them into the list.
        final bool isEnquiry =
            chatUser.chatUserType == ChatUserType.providerEnquiry;
        final bool matchesFilterType =
            (filterType == 'enquiryChats' && isEnquiry) ||
            (filterType == 'bookingChats' && !isEnquiry);
        if (!matchesFilterType) {
          return;
        }
        //if not already there, add it first and increase the total unread notification count
        final tempList = List<ChatUser>.from(stateAs.chatUsers);
        tempList.insert(0, chatUser);
        emit(
          stateAs.copyWith(
            newChatUsers: tempList,
            newTotalOffset: stateAs.totalOffset + 1,
            newTotalUnreadUsers:
                chatUser.unReadChats == 1 &&
                    chatUser.hashCode !=
                        ChatNotificationsUtils.currentChattingUserHashCode
                ? stateAs.totalUnreadUsers + 1
                : null,
          ),
        ); //if it's more then 1, it's already counted in the API, also if they're talking don't increase it
      }
    }
  }

  void makeUserUnreadCountZero({required ChatUser chatUser}) {
    if (state is ChatUsersFetchSuccess) {
      final List<ChatUser> oldChatUsers =
          (state as ChatUsersFetchSuccess).chatUsers;
      bool didWeChangeIt =
          false; //if we remove count, decrease the unread count as well
      for (int i = 0; i < oldChatUsers.length; i++) {
        if (oldChatUsers[i] == chatUser) {
          if (oldChatUsers[i].unreadNotificationsCount != 0) {
            oldChatUsers.insert(i, oldChatUsers[i].copyWith(unReadChats: 0));
            oldChatUsers.removeAt(i + 1);
            didWeChangeIt = true;
          }
        }
      }
      if (didWeChangeIt) {
        emit(
          (state as ChatUsersFetchSuccess).copyWith(
            newChatUsers: oldChatUsers,
            newTotalUnreadUsers:
                (state as ChatUsersFetchSuccess).totalUnreadUsers != 0
                ? (state as ChatUsersFetchSuccess).totalUnreadUsers - 1
                : null,
          ),
        );
      }
    }
  }

  bool isLoading() {
    if (state is ChatUsersFetchInProgress) {
      return true;
    }
    return false;
  }

  Future<void> fetchChatUsers() async {
    emit(ChatUsersFetchInProgress());
    try {
      final Map<String, dynamic> data = await _chatRepository.fetchChatUsers(
        offset: 0,
        filterType: filterType,
      );

      //registration of notification listener if the chat messages were fetched successfully
      registerNotificationListener();
      emit(
        ChatUsersFetchSuccess(
          chatUsers: data['chatUsers'],
          totalOffset: data['totalItems'],
          totalUnreadUsers: data['totalUnreadUsers'],
          moreChatUserFetchError: false,
          moreChatUserFetchProgress: false,
        ),
      );
    } catch (e) {
      emit(ChatUsersFetchFailure(errorMessage: e.toString()));
    }
  }

  Future<void> fetchMoreChatUsers() async {
    if (state is ChatUsersFetchSuccess) {
      final stateAs = state as ChatUsersFetchSuccess;
      if (stateAs.moreChatUserFetchProgress) {
        return;
      }
      try {
        emit(stateAs.copyWith(newFetchMorechatUsersInProgress: true));

        final Map moreTransactionResult = await _chatRepository.fetchChatUsers(
          offset: stateAs.chatUsers.length,
          filterType: filterType,
        );

        final List<ChatUser> chatUsers = stateAs.chatUsers;

        chatUsers.addAll(moreTransactionResult['chatUsers']);

        emit(
          ChatUsersFetchSuccess(
            chatUsers: chatUsers,
            totalOffset: moreTransactionResult['totalItems'],
            totalUnreadUsers: moreTransactionResult['totalUnreadUsers'],
            moreChatUserFetchError: false,
            moreChatUserFetchProgress: false,
          ),
        );
      } catch (e) {
        emit(
          (state as ChatUsersFetchSuccess).copyWith(
            newFetchMorechatUsersInProgress: false,
            newFetchMorechatUsersError: true,
          ),
        );
      }
    }
  }

  bool hasMore() {
    if (state is ChatUsersFetchSuccess) {
      return (state as ChatUsersFetchSuccess).chatUsers.length <
          (state as ChatUsersFetchSuccess).totalOffset;
    }
    return false;
  }

  void disposeNotificationListener() {
    if (_streamSubscription != null) {
      _streamSubscription!.cancel();
    }
  }

  void removeUserFromList(ChatUser userToRemove) {
    if (state is ChatUsersFetchSuccess) {
      final stateAs = state as ChatUsersFetchSuccess;
      final updatedList = List<ChatUser>.from(stateAs.chatUsers)
        ..removeWhere((user) => user == userToRemove);

      emit(
        stateAs.copyWith(
          newChatUsers: updatedList,
          newTotalOffset: stateAs.totalOffset - 1,
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    disposeNotificationListener();
    super.close();
  }
}

class EnquiryChatUserCubit extends ChatUsersCubit {
  EnquiryChatUserCubit(super.chatRepository);

  @override
  String get filterType => 'enquiryChats';
}

class BookingChatUserCubit extends ChatUsersCubit {
  BookingChatUserCubit(super.chatRepository);

  @override
  String get filterType => 'bookingChats';
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iseey/AfterLoginFlow/chat/model/chat_message.dart';
import 'package:iseey/AfterLoginFlow/chat/model/chat_model.dart';
import 'package:iseey/AuthFlow/domain/user_model/user_model.dart';
import 'package:iseey/Models/ChatUserModel.dart';
import 'package:iseey/Models/TableListModel.dart' as TableListModel;

import 'package:iseey/Services/ApiService.dart';

class ChatController with ChangeNotifier {
  final List<ChatModel> _chatDataList = [];
  List<ChatModel> get chatDataList => _chatDataList;

  final List<ChatUserResult> _chatUserListResult = [];
  List<ChatUserResult> get chatUserListResult => _chatUserListResult;

  bool get hasAnyData => _chatUserListResult.isNotEmpty;
  bool get isEmpty => _chatUserListResult.isEmpty && !isFriendsLoading;
  bool get shouldShowEmptyState =>
      _chatUserListResult.isEmpty && !isFriendsLoading;

  bool isLoading = false;
  bool isFriendsLoading = false;
  bool isFriendsLoadingHasError = false;

  bool isDeletingFriendLoading = false;
  bool isDeletingFriendLoadingHasError = false;

  String chatId = '';
  String currentChatUserId = ''; // Track the current chat user ID

  // set chat id
  void setChatId(String id) {
    chatId = id;
    debugPrint("🔄 [CHAT] Set chat ID to: $id");
    notifyListeners();
  }

  // set current chat user id
  void setCurrentChatUserId(String userId) {
    currentChatUserId = userId;
    debugPrint("🔄 [CHAT] Set current chat user ID to: $userId");
    notifyListeners();
  }

  // clear current chat when leaving
  void clearCurrentChat() {
    chatId = '';
    currentChatUserId = '';
    debugPrint("🔄 [CHAT] Cleared current chat info");
    notifyListeners();
  }

  // Update chat user list with new message data
  void updateChatUserListWithMessage({
    required String messageId,
    required String message,
  }) {
    debugPrint(
        "🔄 [CHAT] Updating chat list with new message for chat: $messageId, incrementCount:");

    // Find the chat in the list and update its last message
    int chatIndex =
        _chatUserListResult.indexWhere((chat) => chat.chatId == messageId);

    if (chatIndex != -1) {
      // Update existing chat
      ChatUserResult existingChat = _chatUserListResult[chatIndex];

      // Create updated last message
      LastMessage updatedLastMessage = LastMessage(
        sId: DateTime.now().millisecondsSinceEpoch.toString(),
        sequenceNo: (existingChat.lastMessage?.sequenceNo ?? 0) + 1,
        type: "message",
        deleted: "",
        message: message,
        chatId: messageId,
        sender: existingChat.lastMessage?.sender ?? '',
        created: DateTime.now().millisecondsSinceEpoch,
        updated: DateTime.now().millisecondsSinceEpoch,
        iV: 0,
      );

      // Create updated chat with new last message
      ChatUserResult updatedChat = ChatUserResult(
        userId: existingChat.userId,
        secondUserId: existingChat.secondUserId,
        lastMessageIndex: existingChat.lastMessageIndex + 1,
        userDetail: existingChat.userDetail,
        messagesCount: chatId != messageId
            ? existingChat.messagesCount + 1 
            : existingChat.messagesCount,
        chatId: existingChat.chatId,
        lastMessage: updatedLastMessage,
        restaurant: existingChat.restaurant,
      );

      // Replace the chat at the same index
      _chatUserListResult[chatIndex] = updatedChat;

      // Move the updated chat to the top of the list (most recent first)
      _chatUserListResult.removeAt(chatIndex);
      _chatUserListResult.insert(0, updatedChat);

      debugPrint(
          "🔄 [CHAT] Updated existing chat, moved to top. New count: ${updatedChat.messagesCount}");
    } else {
      debugPrint("🔴 [CHAT] Chat with ID $chatId not found in list");
    }

    notifyListeners();
  }

  // Set/replace the entire chat user list
  void setChatUserListResult(List<ChatUserResult> newList) {
    debugPrint("🔄 [CHAT] Setting chat user list with ${newList.length} items");
    _chatUserListResult.clear();
    _chatUserListResult.addAll(newList);
    notifyListeners();
  }

  // Add a single chat to the list
  void addChatUserResult(ChatUserResult newChat) {
    debugPrint("🔄 [CHAT] Adding new chat: ${newChat.chatId}");
    _chatUserListResult.insert(0, newChat); // Add to top
    notifyListeners();
  }

  // Remove a chat from the list
  void removeChatUserResult(String chatId) {
    debugPrint("🔄 [CHAT] Removing chat: $chatId");
    _chatUserListResult.removeWhere((chat) => chat.chatId == chatId);
    notifyListeners();
  }

  // Handle incoming message notification and update chat list
  void handleIncomingMessageNotification(Map<String, dynamic> messageData) {
    debugPrint(
        "🔄 [CHAT] Handling incoming message notification: $messageData");

    String? type = messageData['type'];
    String? chatId = messageData['chat_id'];
    String? message = messageData['message'];

    if (type == "message" && chatId != null && message != null) {
      // Only increment count if it's not the current user's message
      // and not currently in that specific chat
      bool shouldIncrement = !isCurrentlyInChat(chatId);

      updateChatUserListWithMessage(
        messageId: chatId,
        message: message,
      );

      debugPrint(
          "🔄 [CHAT] Successfully updated chat list with new message, increment: $shouldIncrement");
    } else {
      debugPrint("🔴 [CHAT] Invalid message notification format: $messageData");
    }
  }

  // Reset message count for a specific chat (when user enters the chat)
  void resetMessageCount(String chatId) {
    debugPrint("🔄 [CHAT] Resetting message count for chat: $chatId");

    int chatIndex =
        _chatUserListResult.indexWhere((chat) => chat.chatId == chatId);

    if (chatIndex != -1) {
      ChatUserResult existingChat = _chatUserListResult[chatIndex];

      if (existingChat.messagesCount > 0) {
        // Create updated chat with reset message count
        ChatUserResult updatedChat = ChatUserResult(
          userId: existingChat.userId,
          secondUserId: existingChat.secondUserId,
          lastMessageIndex: existingChat.lastMessageIndex,
          userDetail: existingChat.userDetail,
          messagesCount: 0, // Reset to 0
          chatId: existingChat.chatId,
          lastMessage: existingChat.lastMessage,
          restaurant: existingChat.restaurant,
        );

        _chatUserListResult[chatIndex] = updatedChat;
        debugPrint("🔄 [CHAT] Message count reset to 0 for chat: $chatId");
        notifyListeners();
      }
    }
  }

  // Helper method to check if currently in chat with specific user
  bool isCurrentlyChatting(String userId) {
    bool isChatting =
        currentChatUserId.isNotEmpty && currentChatUserId == userId;
    debugPrint(
        "🔄 [CHAT] Is currently chatting with user $userId? $isChatting (current: $currentChatUserId)");
    return isChatting;
  }

  // Helper method to check if currently in a specific chat by chat ID
  bool isCurrentlyInChat(String chatIdToCheck) {
    bool inChat = chatId.isNotEmpty && chatId == chatIdToCheck;
    debugPrint(
        "🔄 [CHAT] Is currently in chat $chatIdToCheck? $inChat (current: $chatId)");
    return inChat;
  }

  // Get friend list / chat list API
  Future<void> callGetFriendListApi({
    required GlobalKey<ScaffoldState> scaffoldKey,
  }) async {
    isFriendsLoading = true;
    notifyListeners(); // Always notify listeners when loading starts

    debugPrint("🔄 [CHAT] Loading friend list...");

    HttpRequestModel req = HttpRequestModel(
      url: 'socket/getChats',
      method: RequestMethodType.GET,
      body: '',
      params: '',
      headerType: "json",
      authMethod: true,
    );

    try {
      var response = await HttpService().init(req, scaffoldKey);

      if (response is String && response != '') {
        var jsonRes = jsonDecode(response);
        debugPrint("🔄 [CHAT] Friend list response: $jsonRes");

        if (jsonRes["success"] == true) {
          List<dynamic> data = jsonRes["data"] ?? [];
          debugPrint("🔄 [CHAT] Raw data length: ${data.length}");

          List<ChatUserResult> results =
              data.map((item) => ChatUserResult.fromJson(item)).toList();

          _chatUserListResult.clear();
          _chatUserListResult.addAll(results);

          debugPrint("🔄 [CHAT] Loaded ${results.length} friends");
          debugPrint(
              "🔄 [CHAT] Current list length: ${_chatUserListResult.length}");
          isFriendsLoading = false;

          // Force UI rebuild by notifying listeners multiple times if needed
          notifyListeners();

          // Additional debug info
          debugPrint(
              "🔄 [CHAT] Friends loaded successfully, triggering UI update");
          debugPrint(
              "🔄 [CHAT] hasAnyData: $hasAnyData, isEmpty: $isEmpty, shouldShowEmptyState: $shouldShowEmptyState");
        }
      }
      throw Exception("Failed to load friends");
    } catch (e) {
      debugPrint("🔴 [CHAT] Exception in friend list API: $e");
      isFriendsLoading = false;
      isFriendsLoadingHasError = true;
      notifyListeners();
    }
  }

  // Delete chat API
  Future<void> sendDeleteChat({
    required GlobalKey<ScaffoldState> scaffoldKey,
    required String? chatID,
  }) async {
    isDeletingFriendLoading = true;
    notifyListeners();
    if (chatID == null || chatID.isEmpty) {
      debugPrint("🔴 [CHAT] Invalid chat ID for deletion");
      isDeletingFriendLoading = false;
      isDeletingFriendLoadingHasError = true;
      notifyListeners();
      return;
    }

    debugPrint("🔄 [CHAT] Deleting chat: $chatID");

    try {
      HttpRequestModel req = HttpRequestModel(
        url: 'socket/deleteChat/$chatID',
        method: RequestMethodType.DELETE,
        body: '',
        params: '',
        headerType: "json",
        authMethod: true,
      );

      var response = await HttpService().init(req, scaffoldKey);

      if (response is String && response.isNotEmpty) {
        var jsonRes = jsonDecode(response);

        if (jsonRes["success"] == true) {
          debugPrint("🔄 [CHAT] Chat deleted successfully");
          // remove from local list
          _chatUserListResult.removeWhere((chat) => chat.chatId == chatID);
          isDeletingFriendLoading = false;
          isDeletingFriendLoadingHasError = false;
          notifyListeners();
          return;
        }
      }
      debugPrint("🔴 [CHAT] Failed to delete chat: ${response.toString()}");
      throw Exception("Failed to delete chat");
    } catch (e) {
      debugPrint("🔴 [CHAT] Exception in delete chat API: $e");
      isDeletingFriendLoading = false;
      isDeletingFriendLoadingHasError = true;
      notifyListeners();
      return;
    }
  }

  Future<void> callGetAllMessageApi({
    required BuildContext context,
    required GlobalKey<ScaffoldState> scaffoldKey,
    required String chatId,
    required TableListModel.UserDetail toUser,
    required UserResult fromUser,
    UserResult? localUser,
  }) async {
    isLoading = true;
    _chatDataList.clear();

    // Set current chat user when starting a chat
    setCurrentChatUserId(toUser.sId);
    setChatId(chatId);

    notifyListeners();
    HttpRequestModel req = HttpRequestModel(
      url: 'socket/getMessages/${chatId}?limit=1000',
      method: RequestMethodType.GET,
      body: '',
      params: '',
      headerType: "json",
      authMethod: true,
    );
    var response;
    try {
      response = await HttpService().init(req, scaffoldKey);

      if (response is String && response != '') {
        var jsonRes = jsonDecode(response);

        bool success = jsonRes["success"] ?? false;
        if (success) {
          List<dynamic> list = jsonRes["data"] ?? [];
          List<ChatMessage> chatMessages =
              (list).map((item) => ChatMessage.fromJson(item)).toList();
          chatMessages.reversed.forEach((element) {
            // Check if the message is deleted for the current user
            if (element.deletedForUser.contains(localUser?.userId ?? '')) {
              return; // Skip this message if it's deleted for the user
            }
            if (fromUser.userId != element.sender) {
              final chatModel = ChatModel(
                id: element.id,
                nameText: toUser.firstName,
                timeText: element.created,
                chatText: element.message,
                imgPath: toUser.image,
                isRight: false,
              );
              _chatDataList.add(chatModel);
            } else {
              final chatModel = ChatModel(
                id: element.id,
                nameText: fromUser.firstName,
                timeText: element.created,
                chatText: element.message,
                imgPath: fromUser.image,
                isRight: true,
              );
              _chatDataList.add(chatModel);
            }
          });
          isLoading = false;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint("EXCEPTION $e");
      notifyListeners();
    }
  }

  // save chat message
  Future<void> saveChatMessage({
    required ChatModel chat,
  }) async {
    _chatDataList.add(chat);
    notifyListeners();
  }

  // clear chat data
  void clearChatData() {
    _chatDataList.clear();
    clearCurrentChat(); // Clear current chat info when clearing data
    notifyListeners();
  }

  void toggleShowTime(String id) {
    // Find the chat message by id and toggle its showTime property
    if (_chatDataList.isEmpty) return;
    // Use map to create a new list with the updated showTime value
    final updatedChats = _chatDataList.map((chat) {
      if (chat.id == id) {
        return chat.copyWith(showTime: !chat.showTime);
      }
      return chat;
    }).toList();

    _chatDataList
      ..clear()
      ..addAll(updatedChats);

    notifyListeners();
  }

  // remove chat message by id
  void removeChatMessage(String id) {
    _chatDataList.removeWhere((chat) => chat.id == id);
    notifyListeners();
  }
}

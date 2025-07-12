import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iseey/AfterLoginFlow/chat/model/chat_message.dart';
import 'package:iseey/AfterLoginFlow/chat/model/chat_model.dart';
import 'package:iseey/AuthFlow/domain/user_model/user_model.dart';
import 'package:iseey/Models/TableListModel.dart' as TableListModel;

import 'package:iseey/Services/ApiService.dart';

class ChatController with ChangeNotifier {
  final List<ChatModel> _chatDataList = [];
  List<ChatModel> get chatDataList => _chatDataList;
  bool isLoading = false;

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
}

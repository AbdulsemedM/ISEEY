import 'package:iseey/Models/TableListModel.dart';

class ChatUserModel {
  late bool success;
  late String message;
  List<ChatUserResult> result = [];

  ChatUserModel({required this.success, required this.message, required this.result});

  ChatUserModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? 0;
    message = json['message'] ?? '';
    if (json['result'] != null) {
      result = [];
      json['result'].forEach((v) {
        result.add(new ChatUserResult.fromJson(v as Map<String, dynamic>));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['result'] = this.result.map((v) => v.toJson()).toList();
    return data;
  }
}

class ChatUserResult {
  late String userId;
  late String secondUserId;
  late int lastMessageIndex;
  late UserDetail userDetail;
  late int messagesCount;
  late String chatId;
  LastMessage? lastMessage;
  Restaurant? restaurant;

  ChatUserResult(
      {required this.userId,
      required this.secondUserId,
      required this.lastMessageIndex,
      required this.userDetail,
      required this.messagesCount,
      required this.chatId,
      this.lastMessage,
      this.restaurant});

  ChatUserResult.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'] ?? '';
    secondUserId = json['second_user_id'] ?? '';
    lastMessageIndex = json['lastMessageIndex'] ?? 0;
    userDetail = new UserDetail.fromJson(json['userDetail']);
    messagesCount = json['messagesCount'] ?? 0;
    chatId = json['chat_id'] ?? '';
    lastMessage =
        json['lastMessage'] != null ? new LastMessage.fromJson(json['lastMessage'] as Map<String, dynamic>) : null;
    restaurant =
        json['restaurant'] != null ? new Restaurant.fromJson(json['restaurant'] as Map<String, dynamic>) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['second_user_id'] = this.secondUserId;
    data['lastMessageIndex'] = this.lastMessageIndex;
    data['userDetail'] = this.userDetail.toJson();
    data['messagesCount'] = this.messagesCount;
    data['chat_id'] = this.chatId;
    if (this.lastMessage != null) {
      data['lastMessage'] = this.lastMessage?.toJson();
    }
    if (this.restaurant != null) {
      data['restaurant'] = this.restaurant?.toJson();
    }
    return data;
  }
}

class ChatUserCountyDetails {
  late String iso3;
  late String iso2;
  late String phoneCode;
  late String currency;
  late String capital;
  late String emoji;
  late String emojiU;
  late int id;
  late String name;

  ChatUserCountyDetails(
      {required this.iso3,
      required this.iso2,
      required this.phoneCode,
      required this.currency,
      required this.capital,
      required this.emoji,
      required this.emojiU,
      required this.id,
      required this.name});

  ChatUserCountyDetails.fromJson(Map<String, dynamic> json) {
    iso3 = json['iso3'] ?? '';
    iso2 = json['iso2'] ?? '';
    phoneCode = json['phone_code'] ?? '';
    currency = json['currency'] ?? '';
    capital = json['capital'] ?? '';
    emoji = json['emoji'] ?? '';
    emojiU = json['emojiU'] ?? '';
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['iso3'] = this.iso3;
    data['iso2'] = this.iso2;
    data['phone_code'] = this.phoneCode;
    data['currency'] = this.currency;
    data['capital'] = this.capital;
    data['emoji'] = this.emoji;
    data['emojiU'] = this.emojiU;
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class LastMessage {
  late String sId;
  late int sequenceNo;
  late String type;
  late String deleted;
  late String message;
  late String chatId;
  late String sender;
  late int created;
  late int updated;
  late int iV;

  LastMessage(
      {required this.sId,
      required this.sequenceNo,
      required this.type,
      required this.deleted,
      required this.message,
      required this.chatId,
      required this.sender,
      required this.created,
      required this.updated,
      required this.iV});

  LastMessage.fromJson(Map<String, dynamic> json) {
    sId = json['_id'] ?? '';
    sequenceNo = json['sequence_no'] ?? 0;
    type = json['type'] ?? '';
    deleted = json['deleted'] ?? '';
    message = json['message'] ?? '';
    chatId = json['chat_id'] ?? '';
    sender = json['sender'] ?? '';
    created = json['created'] ?? 0;
    updated = json['updated'] ?? 0;
    iV = json['__v'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['sequence_no'] = this.sequenceNo;
    data['type'] = this.type;
    data['deleted'] = this.deleted;
    data['message'] = this.message;
    data['chat_id'] = this.chatId;
    data['sender'] = this.sender;
    data['created'] = this.created;
    data['updated'] = this.updated;
    data['__v'] = this.iV;

    return data;
  }
}

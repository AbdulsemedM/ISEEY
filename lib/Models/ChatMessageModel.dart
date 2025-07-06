class ChatMessageModel {
  late int success;
  late String message;
  List<ChatMessageResult> result = [];

  ChatMessageModel({required this.success,required this.message,required this.result});

  ChatMessageModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? 0;
    message = json['message'] ?? '';
    if (json['result'] != null) {
      result = [];
      json['result'].forEach((v) {
        result.add(new ChatMessageResult.fromJson(v as Map<String, dynamic>));
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

class ChatMessageResult {
  late String sId;
  late int sequenceNo;
  late String type;
  late String deleted;
  late String chatId;
  late String message;
  late String sender;
  late int created;
  late int updated;
  late int iV;

  ChatMessageResult(
      {required this.sId,
        required this.sequenceNo,
        required this.type,
        required this.deleted,
        required this.chatId,
        required this.message,
        required this.sender,
        required this.created,
        required this.updated,
        required this.iV});

  ChatMessageResult.fromJson(Map<String, dynamic> json) {
    sId = json['_id'] ?? '';
    sequenceNo = json['sequence_no'] ?? 0;
    type = json['type'] ?? '';
    deleted = json['deleted'] ?? '';
    chatId = json['chat_id'] ?? '';
    message = json['message'] ?? '';
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
    data['chat_id'] = this.chatId;
    data['message'] = this.message;
    data['sender'] = this.sender;
    data['created'] = this.created;
    data['updated'] = this.updated;
    data['__v'] = this.iV;
    return data;
  }
}

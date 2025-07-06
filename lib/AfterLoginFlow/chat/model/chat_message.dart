class ChatMessage {
  final String id;
  final int sequenceNo;
  final String type;
  final List<String> deletedForUser;
  final int created;
  final int updated;
  final String chatId;
  final String message;
  final String sender;
  final int v;
  final bool isDeleted;

  ChatMessage({
    required this.id,
    required this.sequenceNo,
    required this.type,
    required this.deletedForUser,
    required this.created,
    required this.updated,
    required this.chatId,
    required this.message,
    required this.sender,
    required this.v,
    required this.isDeleted,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['_id'],
      sequenceNo: json['sequence_no'],
      type: json['type'],
      deletedForUser: List<String>.from(json['deleted_for_user']),
      created: json['created'],
      updated: json['updated'],
      chatId: json['chat_id'],
      message: json['message'],
      sender: json['sender'],
      v: json['__v'],
      isDeleted: json['is_deleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'sequence_no': sequenceNo,
      'type': type,
      'deleted_for_user': deletedForUser,
      'created': created,
      'updated': updated,
      'chat_id': chatId,
      'message': message,
      'sender': sender,
      '__v': v,
      'is_deleted': isDeleted,
    };
  }
}

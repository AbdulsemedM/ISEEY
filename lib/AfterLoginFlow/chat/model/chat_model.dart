import 'dart:convert';

class ChatModel {
  final String id;
  final String nameText;
  final int timeText;
  final String chatText;
  final String imgPath;
  final bool isRight;
  final bool showTime;

  ChatModel({
    required this.id,
    required this.nameText,
    required this.timeText,
    required this.chatText,
    required this.imgPath,
    required this.isRight,
    this.showTime = false,
  });

  ChatModel copyWith({
    String? id,
    String? nameText,
    int? timeText,
    String? chatText,
    String? imgPath,
    bool? isRight,
    bool? showTime,
  }) {
    return ChatModel(
      id: id ?? this.id,
      nameText: nameText ?? this.nameText,
      timeText: timeText ?? this.timeText,
      chatText: chatText ?? this.chatText,
      imgPath: imgPath ?? this.imgPath,
      isRight: isRight ?? this.isRight,
      showTime: showTime ?? this.showTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nameText': nameText,
      'timeText': timeText,
      'chatText': chatText,
      'imgPath': imgPath,
      'isRight': isRight,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'] as String,
      nameText: map['nameText'] as String,
      timeText: map['timeText'] as int,
      chatText: map['chatText'] as String,
      imgPath: map['imgPath'] as String,
      isRight: map['isRight'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) => ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatModel(id: $id, nameText: $nameText, timeText: $timeText, chatText: $chatText, imgPath: $imgPath, isRight: $isRight)';
  }

  @override
  bool operator ==(covariant ChatModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.nameText == nameText &&
      other.timeText == timeText &&
      other.chatText == chatText &&
      other.imgPath == imgPath &&
      other.isRight == isRight &&
      other.showTime == showTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      nameText.hashCode ^
      timeText.hashCode ^
      chatText.hashCode ^
      imgPath.hashCode ^
      isRight.hashCode^
      showTime.hashCode;
  }
}

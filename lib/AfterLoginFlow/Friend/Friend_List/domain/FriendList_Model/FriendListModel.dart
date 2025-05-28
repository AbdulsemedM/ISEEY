class FriendListModel {
  late bool success;
  late String message;
  List<FriendListResult> data = [];

  FriendListModel({required this.success, required this.message, required this.data});

  FriendListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    message = json['message'] ?? '';
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(new FriendListResult.fromJson(v as Map<String, dynamic>));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['data'] = this.data.map((v) => v.toJson()).toList();
    return data;
  }
}

class FriendListResult {
  late String sId;
  late String userId;
  late String friendId;
  late String createdAt;
  late String updatedAt;
  late int iV;
  late String currentUserId;
  FriendDetail? friendDetail;
  late int friendIndex;

  FriendListResult({
    required this.sId,
    required this.userId,
    required this.friendId,
    required this.createdAt,
    required this.updatedAt,
    required this.iV,
    required this.currentUserId,
    this.friendDetail,
    required this.friendIndex,
  });

  FriendListResult.fromJson(Map<String, dynamic> json) {
    sId = json['_id'] ?? '';
    userId = json['user_id'] ?? '';
    friendId = json['friend_id'] ?? '';
    createdAt = json['createdAt'] ?? '';
    updatedAt = json['updatedAt'] ?? '';
    iV = json['__v'] ?? 0;
    currentUserId = json['current_user_id'] ?? '';
    friendDetail = json['friendDetail'] != null 
        ? new FriendDetail.fromJson(json['friendDetail'] as Map<String, dynamic>) 
        : null;
    friendIndex = json['friendIndex'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    data['friend_id'] = this.friendId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['current_user_id'] = this.currentUserId;
    if (this.friendDetail != null) {
      data['friendDetail'] = this.friendDetail?.toJson();
    }
    data['friendIndex'] = this.friendIndex;
    return data;
  }
}

class FriendDetail {
  late String sId;
  late String lastName;
  late String firstName;
  late String email;
  late String image;
  late String gender;
  late String dob;
  late String description;
  late String facebookURL;
  late String instagramURL;
  late String countryName;
  late String blocked;
  late bool isBlocked;
  late bool isBlockedYou;

  FriendDetail({
    required this.sId,
    required this.lastName,
    required this.firstName,
    required this.email,
    required this.image,
    required this.gender,
    required this.dob,
    required this.description,
    required this.facebookURL,
    required this.instagramURL,
    required this.countryName,
    required this.blocked,
    required this.isBlocked,
    required this.isBlockedYou,
  });

  FriendDetail.fromJson(Map<String, dynamic> json) {
    sId = json['_id'] ?? '';
    lastName = json['last_name'] ?? '';
    firstName = json['first_name'] ?? '';
    email = json['email'] ?? '';
    image = json['image'] ?? '';
    gender = json['gender'] ?? '';
    dob = json['dob']?.toString() ?? '';
    description = json['description'] ?? '';
    facebookURL = json['facebookURL'] ?? '';
    instagramURL = json['instagramURL'] ?? '';
    countryName = json['country_name'] ?? '';
    blocked = json['blocked'] ?? 'N';
    isBlocked = json['is_blocked'] ?? false;
    isBlockedYou = json['is_blocked_you'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['last_name'] = this.lastName;
    data['first_name'] = this.firstName;
    data['email'] = this.email;
    data['image'] = this.image;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['description'] = this.description;
    data['facebookURL'] = this.facebookURL;
    data['instagramURL'] = this.instagramURL;
    data['country_name'] = this.countryName;
    data['blocked'] = this.blocked;
    data['is_blocked'] = this.isBlocked;
    data['is_blocked_you'] = this.isBlockedYou;
    return data;
  }
}
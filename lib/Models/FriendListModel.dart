class FriendListModel {
  late int success;
  late String message;
  List<FriendListResult> result = [];

  FriendListModel({required this.success, required this.message, required this.result});

  FriendListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? 0;
    message = json['message'] ?? '';
    if (json['result'] != null) {
      result = [];
      json['result'].forEach((v) {
        result.add(new FriendListResult.fromJson(v as Map<String, dynamic>));
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

class FriendListResult {
  late String sId;
  late String friendshipStatus;
  late String requestId;
  late String userId;
  late String friendId;
  late int created;
  late int updated;
  late int iV;
  late String currentUserId;
  late String friendDetailId;
  FriendDetail? friendDetail;
  late int friendIndex;

  FriendListResult(
      {required this.sId,
      required this.friendshipStatus,
      required this.requestId,
      required this.userId,
      required this.friendId,
      required this.created,
      required this.updated,
      required this.iV,
      required this.currentUserId,
      required this.friendDetailId,
      this.friendDetail,
      required this.friendIndex});

  FriendListResult.fromJson(Map<String, dynamic> json) {
    sId = json['_id'] ?? '';
    friendshipStatus = json['friendship_status'] ?? '';
    requestId = json['request_id'] ?? '';
    userId = json['user_id'] ?? '';
    friendId = json['friend_id'] ?? '';
    created = json['created'] ?? 0;
    updated = json['updated'] ?? 0;
    iV = json['__v'] ?? 0;
    currentUserId = json['current_user_id'] ?? '';
    friendDetailId = json['friendDetailId'] ?? '';
    friendDetail = json['friendDetail'] != null ? new FriendDetail.fromJson(json['friendDetail'] as Map<String, dynamic>) : null;
    friendIndex = json['friendIndex'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['friendship_status'] = this.friendshipStatus;
    data['request_id'] = this.requestId;
    data['user_id'] = this.userId;
    data['friend_id'] = this.friendId;
    data['created'] = this.created;
    data['updated'] = this.updated;
    data['__v'] = this.iV;
    data['current_user_id'] = this.currentUserId;
    data['friendDetailId'] = this.friendDetailId;
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
  late String email;
  late String gender;
  late String dob;
  late String city;
  late String state;
  late String country;
  late String firstName;
  late String description;
  late String image;
  late String? facebook;
  late String? instagram;
  FriendCountyDetails? countyDetails;
  late int countyExists;

  FriendDetail({
    required this.sId,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.dob,
    required this.city,
    required this.state,
    required this.country,
    required this.firstName,
    required this.image,
    required this.description,
    required this.countyExists,
    this.countyDetails,
    this.facebook,
    this.instagram,
  });

  FriendDetail.fromJson(Map<String, dynamic> json) {
    sId = json['_id'] ?? '';
    lastName = json['last_name'] ?? '';
    email = json['email'] ?? '';
    gender = json['gender'] ?? '';
    dob = json['dob'] ?? '';
    city = json['city'] ?? '';
    state = json['state'] ?? '';
    country = json['country'] ?? '';
    firstName = json['first_name'] ?? '';
    image = json['image'] ?? '';
    facebook = json['facebookURL'];
    instagram = json['instagramURL'];
    countyDetails = json['countyDetails'] != null ? new FriendCountyDetails.fromJson(json['countyDetails'] as Map<String, dynamic>) : null;
    countyExists = json['countyExists'] ?? 0;
    description = json['description'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['first_name'] = this.firstName;
    data['image'] = this.image;
    data['facebook'] = this.facebook;
    data['instagram'] = this.instagram;

    if (this.countyDetails != null) {
      data['countyDetails'] = this.countyDetails?.toJson();
    }
    data['countyExists'] = this.countyExists;
    data['description'] = this.description;
    return data;
  }
}

class FriendCountyDetails {
  late String iso3;
  late String iso2;
  late String phoneCode;
  late String currency;
  late String capital;
  late String emoji;
  late String emojiU;
  late int id;
  late String name;

  FriendCountyDetails(
      {required this.iso3,
      required this.iso2,
      required this.phoneCode,
      required this.currency,
      required this.capital,
      required this.emoji,
      required this.emojiU,
      required this.id,
      required this.name});

  FriendCountyDetails.fromJson(Map<String, dynamic> json) {
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

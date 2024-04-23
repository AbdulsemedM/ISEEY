class BlockedUserListModel {
  late int success;
  late String message;
  List<BlockedUserResult> result = [];

  BlockedUserListModel(
      {required this.success, required this.message, required this.result});

  BlockedUserListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? 0;
    message = json['message'] ?? '';
    if (json['result'] != null) {
      result = [];
      json['result'].forEach((v) {
        result.add(new BlockedUserResult.fromJson(v as Map<String, dynamic>));
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

class BlockedUserResult {
  late String sId;
  late String userId;
  late String blocked;
  late int created;
  late int updated;
  BlockedUserDetail? userDetail;
  late bool isBlockedYou;

  BlockedUserResult(
      {required this.sId,
      required this.userId,
      required this.blocked,
      required this.created,
      required this.updated,
        this.userDetail,
      required this.isBlockedYou});

  BlockedUserResult.fromJson(Map<String, dynamic> json) {
    sId = json['_id'] ?? '';
    userId = json['user_id'] ?? '';
    blocked = json['blocked'] ?? '';
    created = json['created'] ?? 0;
    updated = json['updated'] ?? 0;
    userDetail = json['userDetail'] != null
        ? new BlockedUserDetail.fromJson(json['userDetail'] as Map<String, dynamic>)
        : null;
    isBlockedYou = json['isBlockedYou'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    data['blocked'] = this.blocked;
    data['created'] = this.created;
    data['updated'] = this.updated;
    if (this.userDetail != null) {
      data['userDetail'] = this.userDetail?.toJson();
    }
    data['isBlockedYou'] = this.isBlockedYou;
    return data;
  }
}

class BlockedUserDetail {
  late String sId;
  late String lastName;
  late String email;
  late String image;
  late String gender;
  late String dob;
  late String city;
  late String state;
  late String country;
  late String firstName;

  BlockedUserDetail(
      {required this.sId,
      required this.lastName,
      required this.email,
      required this.image,
      required this.gender,
      required this.dob,
      required this.city,
      required this.state,
      required this.country,
      required this.firstName,
     });

  BlockedUserDetail.fromJson(Map<String, dynamic> json) {
    sId = json['_id'] ?? '';
    lastName = json['last_name'] ?? '';
    email = json['email'] ?? '';
    image = json['image'] ?? '';
    gender = json['gender'] ?? '';
    dob = json['dob'] ?? '';
    city = json['city'] ?? '';
    state = json['state'] ?? '';
    country = json['country'] ?? '';
    firstName = json['first_name'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['image'] = this.image;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['first_name'] = this.firstName;

    return data;
  }
}

class BlockedUserCountryDetails {
  late String iso3;
  late String iso2;
  late String phoneCode;
  late String currency;
  late String capital;
  late String emoji;
  late String emojiU;
  late int id;
  late String name;

  BlockedUserCountryDetails(
      {required this.iso3,
      required this.iso2,
      required this.phoneCode,
      required this.currency,
      required this.capital,
      required this.emoji,
      required this.emojiU,
      required this.id,
      required this.name});

  BlockedUserCountryDetails.fromJson(Map<String, dynamic> json) {
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

class BlockedUserStateDetails {
  late String sId;
  late int id;
  late String name;

  BlockedUserStateDetails(
      {required this.sId, required this.id, required this.name});

  BlockedUserStateDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'] ?? '';
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

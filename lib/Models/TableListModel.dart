class TableListModel {
  late int success;
  late String message;
  TableListResult? result;

  TableListModel({required this.success, required this.message, this.result});

  TableListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? 0;
    message = json['message'] ?? '';
    result = json['result'] != null ? new TableListResult.fromJson(json['result'] as Map<String, dynamic>) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result?.toJson();
    }
    return data;
  }
}

class TableListResult {
  List<CheckIns> checkIns = [];
  Restaurant? restaurant;

  TableListResult({required this.checkIns, this.restaurant});

  TableListResult.fromJson(Map<String, dynamic> json) {
    if (json['checkIns'] != null) {
      checkIns = [];
      json['checkIns'].forEach((v) {
        checkIns.add(new CheckIns.fromJson(v as Map<String, dynamic>));
      });
    }
    restaurant =
        json['restaurant'] != null ? new Restaurant.fromJson(json['restaurant'] as Map<String, dynamic>) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['checkIns'] = this.checkIns.map((v) => v.toJson()).toList();
    if (this.restaurant != null) {
      data['restaurant'] = this.restaurant?.toJson();
    }
    return data;
  }
}

class CheckIns {
  late int iId;
  List<TableUsers> users = [];

  CheckIns({required this.iId, required this.users});

  CheckIns.fromJson(Map<String, dynamic> json) {
    iId = json['_id'] ?? 0;
    if (json['users'] != null) {
      users = [];
      json['users'].forEach((v) {
        users.add(new TableUsers.fromJson(v as Map<String, dynamic>));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.iId;
    data['users'] = this.users.map((v) => v.toJson()).toList();
    return data;
  }
}

class TableUsers {
  UserDetail? userDetail;
  late String checkInId;
  late String restaurantId;

  TableUsers({this.userDetail, required this.checkInId, required this.restaurantId});

  TableUsers.fromJson(Map<String, dynamic> json) {
    userDetail =
        json['userDetail'] != null ? new UserDetail.fromJson(json['userDetail'] as Map<String, dynamic>) : null;
    checkInId = json['checkInId'] ?? '';
    restaurantId = json['restaurant_id'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userDetail != null) {
      data['userDetail'] = this.userDetail?.toJson();
    }
    data['checkInId'] = this.checkInId;
    data['restaurant_id'] = this.restaurantId;
    return data;
  }
}

class UserDetail {
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
  late String description;
  late String facebookUrl;
  late String instagramUrl;
  CountryDetails? countryDetails;
  late int countryDetailsIndex;
  StateDetails? stateDetails;
  late int stateExists;
  StateDetails? cityDetails;
  late int cityExists;

  // List<Null> friend;
  late bool isFriend;
  late int friendsCount;
  late bool isBlocked;
  late bool isBlockedYou;

  late String userId;
  late String address;
  late String lat;
  late String lng;
  late String postalCode;

  UserDetail(
      {required this.sId,
      required this.userId,
      required this.address,
      required this.lat,
      required this.lng,
      required this.postalCode,
      required this.lastName,
      required this.email,
      required this.image,
      required this.gender,
      required this.dob,
      required this.city,
      required this.state,
      required this.country,
      required this.firstName,
      required this.description,
      required this.facebookUrl,
      required this.instagramUrl,
      required this.countryDetails,
      required this.countryDetailsIndex,
      required this.stateDetails,
      required this.stateExists,
      required this.cityDetails,
      // this.friend,
      required this.isFriend,
      required this.friendsCount,
      required this.cityExists,
      required this.isBlocked,
      required this.isBlockedYou});

  UserDetail.fromJson(Map<String, dynamic> json) {
    sId = json['_id'] ?? '';
    userId = json['user_id'] ?? '';
    address = json['address'] ?? '';
    lat = json['lat'] ?? '';
    lng = json['lng'] ?? '';
    postalCode = json['postal_code'] ?? '';
    lastName = json['last_name'] ?? '';
    email = json['email'] ?? '';
    image = json['image'] ?? '';
    gender = json['gender'] ?? '';
    dob = json['dob'] ?? '';
    city = json['city'] ?? '';
    state = json['state'] ?? '';
    country = json['country'] ?? '';
    firstName = json['first_name'] ?? '';
    description = json['description'] ?? '';
    facebookUrl = json['facebookURL'] ?? '';
    instagramUrl = json['instagramURL'] ?? '';
    friendsCount = json['friendsCount'] ?? 0;
    countryDetails = json['countryDetails'] != null
        ? new CountryDetails.fromJson(json['countryDetails'] as Map<String, dynamic>)
        : null;
    countryDetailsIndex = json['countryDetailsIndex'] ?? 0;
    stateDetails =
        json['stateDetails'] != null ? new StateDetails.fromJson(json['stateDetails'] as Map<String, dynamic>) : null;
    stateExists = json['stateExists'] ?? 0;
    cityDetails =
        json['cityDetails'] != null ? new StateDetails.fromJson(json['cityDetails'] as Map<String, dynamic>) : null;
    cityExists = json['cityExists'] ?? 0;
    isFriend = json['isFriend'] ?? false;
    isBlocked = json['is_blocked'] ?? false;
    isBlockedYou = json['is_blocked_you'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    data['address'] = this.address;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['postal_code'] = this.postalCode;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['image'] = this.image;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['description'] = this.description;
    data['facebookURL'] = this.facebookUrl;
    data['instagramURL'] = this.instagramUrl;
    data['friendsCount'] = this.friendsCount;
    data['first_name'] = this.firstName;
    data['countryDetailsIndex'] = this.countryDetailsIndex;
    data['stateExists'] = this.stateExists;
    data['cityExists'] = this.cityExists;
    data['isFriend'] = this.isFriend;
    data['is_blocked'] = this.isBlocked;
    data['is_blocked_you'] = this.isBlockedYou;
    if (this.stateDetails != null) {
      data['stateDetails'] = this.stateDetails?.toJson();
    }
    if (this.cityDetails != null) {
      data['cityDetails'] = this.cityDetails?.toJson();
    }

    if (this.countryDetails != null) {
      data['countryDetails'] = this.countryDetails?.toJson();
    }

    return data;
  }
}

class CountryDetails {
  late String iso3;
  late String iso2;
  late String phoneCode;
  late String currency;
  late String capital;
  late String emoji;
  late String emojiU;
  late int id;
  late String name;

  CountryDetails({
    required this.iso3,
    required this.iso2,
    required this.phoneCode,
    required this.currency,
    required this.capital,
    required this.emoji,
    required this.emojiU,
    required this.id,
    required this.name,
  });

  CountryDetails.fromJson(Map<String, dynamic> json) {
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

class StateDetails {
  late String sId;
  late int id;
  late String name;

  StateDetails({required this.sId, required this.id, required this.name});

  StateDetails.fromJson(Map<String, dynamic> json) {
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

class Restaurant {
  late String sId;
  late String emailVerified;
  late String image;
  late double lat;
  late double lng;
  late String active;
  late String deleted;
  late String name;
  late String city;
  late String state;
  late String country;
  late String phoneNumber;
  late String email;
  late int updated;
  late int created;
  late int numberOfTables;
  late String address;
  late String menu;
  late String menuType;
  late String facebook;
  late String bio;
  CountryDetails? countyDetails;
  int? countyExists;
  StateDetails? stateDetails;
  late int stateExists;
  StateDetails? cityDetails;
  late int cityExists;

  Restaurant({
    required this.sId,
    required this.emailVerified,
    required this.image,
    required this.lat,
    required this.lng,
    required this.active,
    required this.deleted,
    required this.name,
    required this.city,
    required this.state,
    required this.country,
    required this.phoneNumber,
    required this.email,
    required this.updated,
    required this.created,
    required this.numberOfTables,
    required this.address,
    required this.menu,
    required this.menuType,
    required this.facebook,
    required this.bio,
    required this.countyDetails,
    this.countyExists,
    required this.stateDetails,
    required this.stateExists,
    required this.cityDetails,
    required this.cityExists,
  });

  Restaurant.fromJson(Map<String, dynamic> json) {
    sId = json['_id'] ?? '';
    emailVerified = json['email_verified'] ?? '';
    image = json['image'] ?? '';
    lat = json['lat'] ?? 0.0;
    lng = json['lng'] ?? 0.0;
    active = json['active'] ?? '';
    deleted = json['deleted'] ?? '';
    name = json['name'] ?? '';
    city = json['city'] ?? '';
    state = json['state'] ?? '';
    country = json['country'] ?? '';
    phoneNumber = json['phoneNumber'] ?? '';
    email = json['email'] ?? '';
    updated = json['updated'] ?? 0;
    created = json['created'] ?? 0;
    numberOfTables = json['number_of_tables'] ?? 0;
    address = json['address'] ?? '';
    menu = json['menu'] ?? '';
    menuType = json['menu_type'] ?? '';
    facebook = json['facebook'] ?? '';
    bio = json['bio'] ?? '';
    countyDetails = json['countyDetails'] != null
        ? new CountryDetails.fromJson(json['countyDetails'] as Map<String, dynamic>)
        : null;
    countyExists = json['countyExists'] ?? 0;
    stateDetails =
        json['stateDetails'] != null ? new StateDetails.fromJson(json['stateDetails'] as Map<String, dynamic>) : null;
    stateExists = json['stateExists'] ?? 0;
    cityDetails =
        json['cityDetails'] != null ? new StateDetails.fromJson(json['cityDetails'] as Map<String, dynamic>) : null;
    cityExists = json['cityExists'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['email_verified'] = this.emailVerified;
    data['image'] = this.image;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['active'] = this.active;
    data['deleted'] = this.deleted;
    data['name'] = this.name;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['phoneNumber'] = this.phoneNumber;
    data['email'] = this.email;
    data['updated'] = this.updated;
    data['created'] = this.created;
    data['number_of_tables'] = this.numberOfTables;
    data['address'] = this.address;
    data['menu'] = this.menu;
    data['menu_type'] = this.menuType;
    data['facebook'] = this.facebook;
    data['bio'] = this.bio;
    if (this.countyDetails != null) {
      data['countyDetails'] = this.countyDetails?.toJson();
    }
    data['countyExists'] = this.countyExists;
    if (this.stateDetails != null) {
      data['stateDetails'] = this.stateDetails?.toJson();
    }
    data['stateExists'] = this.stateExists;
    if (this.cityDetails != null) {
      data['cityDetails'] = this.cityDetails?.toJson();
    }
    data['cityExists'] = this.cityExists;
    return data;
  }
}

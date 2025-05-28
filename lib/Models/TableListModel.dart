class TableListModel {
  late bool success;
  late String message;
  TableListResult? data;

  TableListModel({required this.success, required this.message, this.data});

  TableListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    message = json['message'] ?? '';
    data = json['data'] != null ? TableListResult.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data?.toJson();
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
        checkIns.add(CheckIns.fromJson(v));
      });
    }
    restaurant =
        json['restaurant'] != null ? Restaurant.fromJson(json['restaurant']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['checkIns'] = checkIns.map((v) => v.toJson()).toList();
    if (restaurant != null) {
      data['restaurant'] = restaurant?.toJson();
    }
    return data;
  }
}

class CheckIns {
  late int iId; // Change from String to int
  List<TableUsers> users = [];

  CheckIns({required this.iId, required this.users});

  CheckIns.fromJson(Map<String, dynamic> json) {
    iId = json['_id'] ?? 0; // Parse as int
    if (json['users'] != null) {
      users = [];
      json['users'].forEach((v) {
        users.add(TableUsers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = iId;
    data['users'] = users.map((v) => v.toJson()).toList();
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
        json['userDetail'] != null ? UserDetail.fromJson(json['userDetail']) : null;
    checkInId = json['checkInId'] ?? '';
    restaurantId = json['restaurant_id'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userDetail != null) {
      data['userDetail'] = userDetail?.toJson();
    }
    data['checkInId'] = checkInId;
    data['restaurant_id'] = restaurantId;
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
  late bool isFriend;
  late int friendsCount;
  late bool isBlocked;
  late bool isBlockedYou;
  late String userId;
  late String address;
  late String lat;
  late String lng;
  late String postalCode;

  UserDetail({
    required this.sId,
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
    required this.cityExists,
    required this.isFriend,
    required this.friendsCount,
    required this.isBlocked,
    required this.isBlockedYou,
    required this.userId,
    required this.address,
    required this.lat,
    required this.lng,
    required this.postalCode,
  });

  UserDetail.fromJson(Map<String, dynamic> json) {
    sId = json['_id'] ?? '';
    userId = json['user_id'] ?? '';
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
        ? CountryDetails.fromJson(json['countryDetails'])
        : null;
    countryDetailsIndex = json['countryDetailsIndex'] ?? 0;
    stateDetails =
        json['stateDetails'] != null ? StateDetails.fromJson(json['stateDetails']) : null;
    stateExists = json['stateExists'] ?? 0;
    cityDetails =
        json['cityDetails'] != null ? StateDetails.fromJson(json['cityDetails']) : null;
    cityExists = json['cityExists'] ?? 0;
    isFriend = json['isFriend'] ?? false;
    isBlocked = json['is_blocked'] ?? false;
    isBlockedYou = json['is_blocked_you'] ?? false;
    
    address = json['address'] ?? '';
    lat = json['lat'] ?? '';
    lng = json['lng'] ?? '';
    postalCode = json['postal_code'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user_id'] = userId;
    data['last_name'] = lastName;
    data['email'] = email;
    data['image'] = image;
    data['gender'] = gender;
    data['dob'] = dob;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['first_name'] = firstName;
    data['description'] = description;
    data['facebookURL'] = facebookUrl;
    data['instagramURL'] = instagramUrl;
    data['friendsCount'] = friendsCount;
    if (countryDetails != null) {
      data['countryDetails'] = countryDetails?.toJson();
    }
    data['countryDetailsIndex'] = countryDetailsIndex;
    if (stateDetails != null) {
      data['stateDetails'] = stateDetails?.toJson();
    }
    data['stateExists'] = stateExists;
    if (cityDetails != null) {
      data['cityDetails'] = cityDetails?.toJson();
    }
    data['cityExists'] = cityExists;
    data['isFriend'] = isFriend;
    data['is_blocked'] = isBlocked;
    data['is_blocked_you'] = isBlockedYou;
    
    data['address'] = address;
    data['lat'] = lat;
    data['lng'] = lng;
    data['postal_code'] = postalCode;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['iso3'] = iso3;
    data['iso2'] = iso2;
    data['phone_code'] = phoneCode;
    data['currency'] = currency;
    data['capital'] = capital;
    data['emoji'] = emoji;
    data['emojiU'] = emojiU;
    data['id'] = id;
    data['name'] = name;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['id'] = id;
    data['name'] = name;
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
        ? CountryDetails.fromJson(json['countyDetails'])
        : null;
    countyExists = json['countyExists'] ?? 0;
    stateDetails =
        json['stateDetails'] != null ? StateDetails.fromJson(json['stateDetails']) : null;
    stateExists = json['stateExists'] ?? 0;
    cityDetails =
        json['cityDetails'] != null ? StateDetails.fromJson(json['cityDetails']) : null;
    cityExists = json['cityExists'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['email_verified'] = emailVerified;
    data['image'] = image;
    data['lat'] = lat;
    data['lng'] = lng;
    data['active'] = active;
    data['deleted'] = deleted;
    data['name'] = name;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['phoneNumber'] = phoneNumber;
    data['email'] = email;
    data['updated'] = updated;
    data['created'] = created;
    data['number_of_tables'] = numberOfTables;
    data['address'] = address;
    data['menu'] = menu;
    data['menu_type'] = menuType;
    data['facebook'] = facebook;
    data['bio'] = bio;
    if (countyDetails != null) {
      data['countyDetails'] = countyDetails?.toJson();
    }
    data['countyExists'] = countyExists;
    if (stateDetails != null) {
      data['stateDetails'] = stateDetails?.toJson();
    }
    data['stateExists'] = stateExists;
    if (cityDetails != null) {
      data['cityDetails'] = cityDetails?.toJson();
    }
    data['cityExists'] = cityExists;
    return data;
  }
}
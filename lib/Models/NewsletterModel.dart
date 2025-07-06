class NewsletterModel {
  late int success;
  late String message;
  List<NewsletterResult> result = [];

  NewsletterModel(
      {required this.success, required this.message, required this.result});

  NewsletterModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? 0;
    message = json['message'] ?? '';
    if (json['result'] != null) {
      result = [];
      json['result'].forEach((v) {
        result.add(new NewsletterResult.fromJson(v as Map<String, dynamic>));
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

class NewsletterResult {
  late String sId;
  late bool enabled;
  late String userId;
  late String restaurantId;
  late int iV;
  NewsletterRestaurantDetail? restaurantDetail;

  NewsletterResult(
      {required this.sId,
      required this.enabled,
      required this.userId,
      required this.restaurantId,
      required this.iV,
      this.restaurantDetail});

  NewsletterResult.fromJson(Map<String, dynamic> json) {
    sId = json['_id'] ?? '';
    enabled = json['enabled'] ?? false;
    userId = json['user_id'] ?? '';
    restaurantId = json['restaurant_id'] ?? '';
    iV = json['__v'] ?? 0;
    restaurantDetail = json['restaurantDetail'] != null
        ? new NewsletterRestaurantDetail.fromJson(
            json['restaurantDetail'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['enabled'] = this.enabled;
    data['user_id'] = this.userId;
    data['restaurant_id'] = this.restaurantId;
    data['__v'] = this.iV;
    if (this.restaurantDetail != null) {
      data['restaurantDetail'] = this.restaurantDetail?.toJson();
    }
    return data;
  }
}

class NewsletterRestaurantDetail {
  late String sId;
  late String emailVerified;
  late String image;
  late double lat;
  late double lng;
  late String address;
  late String active;
  late String deleted;
  late int numberOfTables;
  late String name;
  late String city;
  late String state;
  late String country;
  late String phoneNumber;
  late String email;
  late int updated;
  late int created;
  late String bio;
  StateDetails? countryDetails;
  StateDetails? stateDetails;
  late int stateExists;
  StateDetails? cityDetails;
  late int cityExists;

  NewsletterRestaurantDetail(
      {required this.sId,
      required this.emailVerified,
      required this.image,
      required this.lat,
      required this.lng,
      required this.address,
      required this.active,
      required this.deleted,
      required this.numberOfTables,
      required this.name,
      required this.city,
      required this.state,
      required this.country,
      required this.phoneNumber,
      required this.email,
      required this.updated,
      required this.created,
      required this.bio,
      this.countryDetails,
      this.stateDetails,
      required this.stateExists,
      this.cityDetails,
      required this.cityExists});

  NewsletterRestaurantDetail.fromJson(Map<String, dynamic> json) {
    sId = json['_id'] ?? '';
    emailVerified = json['email_verified'] ?? '';
    image = json['image'] ?? '';
    lat = json['lat'] ?? 0.0;
    lng = json['lng'] ?? 0.0;
    address = json['address'] ?? '';
    active = json['active'] ?? '';
    deleted = json['deleted'] ?? '';
    numberOfTables = json['number_of_tables'] ?? 0;
    name = json['name'] ?? '';
    city = json['city'] ?? '';
    state = json['state'] ?? '';
    country = json['country'] ?? '';
    phoneNumber = json['phoneNumber'] ?? '';
    email = json['email'] ?? '';
    updated = json['updated'] ?? 0;
    created = json['created'] ?? 0;
    bio = json['bio'] ?? '';
    countryDetails = json['countryDetails'] != null
        ? new StateDetails.fromJson(
            json['countryDetails'] as Map<String, dynamic>)
        : null;
    stateDetails = json['stateDetails'] != null
        ? new StateDetails.fromJson(
            json['stateDetails'] as Map<String, dynamic>)
        : null;
    stateExists = json['stateExists'] ?? 0;
    cityDetails = json['cityDetails'] != null
        ? new StateDetails.fromJson(json['cityDetails'] as Map<String, dynamic>)
        : null;
    cityExists = json['cityExists'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['email_verified'] = this.emailVerified;
    data['image'] = this.image;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['address'] = this.address;
    data['active'] = this.active;
    data['deleted'] = this.deleted;
    data['number_of_tables'] = this.numberOfTables;
    data['name'] = this.name;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['phoneNumber'] = this.phoneNumber;
    data['email'] = this.email;
    data['updated'] = this.updated;
    data['created'] = this.created;
    data['bio'] = this.bio;
    if (this.countryDetails != null) {
      data['countryDetails'] = this.countryDetails?.toJson();
    }
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

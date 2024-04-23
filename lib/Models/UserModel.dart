class UserModel {
  late int success;
  late String message;
  UserResult? result;

  UserModel({required this.success, required this.message, this.result});

  UserModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? 0;
    message = json['message'] ?? '';
    result = json['result'] != null ? new UserResult.fromJson(json['result'] as Map<String, dynamic>) : null;
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

class UserResult {
  late String userId;
  late String email;
  late String firstName;
  late String lastName;
  late String address;
  late String lat;
  late String lng;
  late String gender;
  late String dob;
  late String city;
  late String state;
  late String country;
  late String postalCode;
  late String image;
  late String token;
  late String description;
  late String facebookUrl;
  late String instagramUrl;

  UserResult({
    required this.userId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.lat,
    required this.lng,
    required this.gender,
    required this.dob,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    required this.image,
    required this.token,
    required this.description,
    required this.facebookUrl,
    required this.instagramUrl,
  });

  UserResult.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'] ?? '';
    email = json['email'] ?? '';
    firstName = json['first_name'] ?? '';
    lastName = json['last_name'] ?? '';
    address = json['address'] ?? '';
    lat = json['lat'] ?? '';
    lng = json['lng'] ?? '';
    gender = json['gender'] ?? '';
    dob = json['dob'] ?? '';
    city = json['city'] ?? '';
    state = json['state'] ?? '';
    country = json['country'] ?? '';
    postalCode = json['postal_code'] ?? '';
    image = json['image'] ?? '';
    token = json['token'] ?? '';
    description = json['description'] ?? '';
    facebookUrl = json['facebookURL'] ?? '';
    instagramUrl = json['instagramURL'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['address'] = this.address;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['postal_code'] = this.postalCode;
    data['image'] = this.image;
    data['token'] = this.token;
    data['description'] = this.description;
    data['facebookURL'] = this.facebookUrl;
    data['instagramURL'] = this.instagramUrl;
    return data;
  }
}

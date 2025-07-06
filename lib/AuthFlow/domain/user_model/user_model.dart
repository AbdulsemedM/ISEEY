class UserModel {
  late int success;
  late String message;
  UserResult? result;

  UserModel({required this.success, required this.message, this.result});

  UserModel.fromJson(Map<String, dynamic> json) {
    final statusCode = json['success'] ?? 0;
    success = statusCode is int
        ? statusCode
        : statusCode == true
            ? 200
            : 0;
    message = json['message'] ?? '';

    // Handle cases where 'data' and 'user' fields are not present
    if (json['data'] != null && json['data']['user'] != null) {
      result = UserResult.fromJson(json['data']['user'] as Map<String, dynamic>)
          .copyWith(token: json['data']['token'] ?? '');
    } else if (json['user'] != null) {
      // Handle case where 'user' is directly in the response
      result = UserResult.fromJson(json['user'] as Map<String, dynamic>)
          .copyWith(token: json['token'] ?? '');
    } else if (json['data'] != null) {
      // Handle case where 'data' contains user fields directly
      result = UserResult.fromJson(json['data'] as Map<String, dynamic>)
          .copyWith(token: json['data']['token'] ?? '');
    } else {
      result = null; // No user data in the response
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (result != null) {
      data['result'] = result?.toJson();
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
  String? facebookUrl; // Make this optional
  String? instagramUrl; // Make this optional

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
    this.facebookUrl, // Optional
    this.instagramUrl, // Optional
  });

  UserResult.fromJson(Map<String, dynamic> json) {
    userId = json['_id'] ?? '';
    email = json['email'] ?? '';
    firstName = json['first_name'] ?? '';
    lastName = json['last_name'] ?? '';
    address = json['address'] ?? '';
    lat = json['lat']?.toString() ?? '';
    lng = json['lng']?.toString() ?? '';
    gender = json['gender'] ?? '';
    dob = json['dob'] ?? '';
    city = json['city'] ?? '';
    state = json['state'] ?? '';
    country = json['country'] ?? '';
    postalCode = json['postal_code'] ?? '';
    image = json['image'] ?? '';
    token = json['token'] ?? '';
    description = json['description'] ?? '';
    facebookUrl = json['facebookURL']; // Optional (can be null)
    instagramUrl = json['instagramURL']; // Optional (can be null)
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = userId;
    data['email'] = email;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['address'] = address;
    data['lat'] = lat;
    data['lng'] = lng;
    data['gender'] = gender;
    data['dob'] = dob;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['postal_code'] = postalCode;
    data['image'] = image;
    data['token'] = token;
    data['description'] = description;
    data['facebookURL'] = facebookUrl; 
    data['instagramURL'] = instagramUrl; 
    return data;
  }

  UserResult copyWith({
    String? userId,
    String? email,
    String? firstName,
    String? lastName,
    String? address,
    String? lat,
    String? lng,
    String? gender,
    String? dob,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    String? image,
    String? token,
    String? description,
    String? facebookUrl, 
    String? instagramUrl, 
  }) {
    return UserResult(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      address: address ?? this.address,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      image: image ?? this.image,
      token: token ?? this.token,
      description: description ?? this.description,
      facebookUrl: facebookUrl ?? this.facebookUrl, 
      instagramUrl: instagramUrl ?? this.instagramUrl, 
    );
  }
}
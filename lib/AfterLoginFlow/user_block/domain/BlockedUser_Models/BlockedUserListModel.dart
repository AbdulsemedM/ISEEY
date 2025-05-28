import 'package:iseey/AfterLoginFlow/user_block/domain/BlockedUser_Models/BlockedUserResultExtension.dart';

class BlockedUserListModel {
  final bool success;
  final String message;
  final BlockedUserData data;

  BlockedUserListModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory BlockedUserListModel.fromJson(Map<String, dynamic> json) {
    return BlockedUserListModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: BlockedUserData.fromJson(json['data'] ?? {}),
    );
  }

  List<BlockedUserResult> toBlockedUserResults() {
    return data.users
        .map((user) => BlockedUserResultExtension.fromBlockedUser(user))
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
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

  BlockedUserResult({
    required this.sId,
    required this.userId,
    required this.blocked,
    required this.created,
    required this.updated,
    this.userDetail,
    required this.isBlockedYou,
  });
  
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
  late String description;

  BlockedUserDetail({
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
  });
  
}
class BlockedUserData {
  final List<BlockedUser> users;

  BlockedUserData({
    required this.users,
  });

  factory BlockedUserData.fromJson(Map<String, dynamic> json) {
    return BlockedUserData(
      users: (json['users'] as List? ?? [])
          .map((user) => BlockedUser.fromJson(user))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'users': users.map((user) => user.toJson()).toList(),
    };
  }
}

class BlockedUser {
  final String id;
  final String userId;
  final String blocked;
  final UserDetail userDetail;
  final bool isBlockedYou;
  final String countryName;

  BlockedUser({
    required this.id,
    required this.userId,
    required this.blocked,
    required this.userDetail,
    required this.isBlockedYou,
    required this.countryName,
  });

  factory BlockedUser.fromJson(Map<String, dynamic> json) {
    return BlockedUser(
      id: json['_id'] ?? '',
      userId: json['user_id'] ?? '',
      blocked: json['blocked'] ?? '',
      userDetail: UserDetail.fromJson(json['userDetail'] ?? {}),
      isBlockedYou: json['isBlockedYou'] ?? false,
      countryName: json['country_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_id': userId,
      'blocked': blocked,
      'userDetail': userDetail.toJson(),
      'isBlockedYou': isBlockedYou,
      'country_name': countryName,
    };
  }
}

class UserDetail {
  final String id;
  final String lastName;
  final String email;
  final String image;
  final String gender;
  final String dob;
  final String description;
  final String countryName;
  final String firstName;

  UserDetail({
    required this.id,
    required this.lastName,
    required this.email,
    required this.image,
    required this.gender,
    required this.dob,
    required this.description,
    required this.countryName,
    required this.firstName,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      id: json['_id'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      image: json['image'] ?? '',
      gender: json['gender'] ?? '',
      dob: json['dob'] ?? '',
      description: json['description'] ?? '',
      countryName: json['country_name'] ?? '',
      firstName: json['first_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'last_name': lastName,
      'email': email,
      'image': image,
      'gender': gender,
      'dob': dob,
      'description': description,
      'country_name': countryName,
      'first_name': firstName,
    };
  }
}
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iseey/AuthFlow/domain/user_model/user_model.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/Services/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileRepository {
  final HttpService httpService;
  final GlobalWidgets globalWidgets = GlobalWidgets();

  EditProfileRepository(this.httpService);

  Future<UserResult> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString("userdata");

    if (userDataString == null) {
      throw Exception("User data not found in SharedPreferences");
    }

    final userData = jsonDecode(userDataString);
    return UserResult.fromJson(userData);
  }

  Future<String?> _uploadfileImage(File imageFile, GlobalKey<ScaffoldState> scaffoldKey) async {
    print('[DEBUG] Starting image upload...');
    try {
      globalWidgets.showLoading(scaffoldKey.currentContext!);

      final req = HttpRequestModel(
        url: 'upload/user',
        method: RequestMethodType.MULTIPART,
        body: null,
        multipartBody: {},
        headerType: "json",
        authMethod: true,
        file: imageFile,
        fileFieldName: 'picture',
      );

      final response = await httpService.init(req, scaffoldKey);
      print('[DEBUG] Raw upload response: $response');
      dynamic responseData;
      if (response is Map<String, dynamic>) {
        responseData = jsonDecode(response['body']);
      } else if (response is String) {
        responseData = jsonDecode(response);
      } else {
        throw Exception('Unexpected response type: ${response.runtimeType}');
      }

      globalWidgets.hideLoading();
      print('[DEBUG] Parsed upload response: $responseData');
      if (responseData['success'] == true) {
        final imageUrl = responseData['data']['url'];
        print('[DEBUG] ✅ Image uploaded successfully. URL: $imageUrl');
        return imageUrl;
      } else {
        throw Exception(responseData['message'] ?? 'Upload failed (server did not return success)');
      }
    } catch (e) {
      globalWidgets.hideLoading();
      print('[DEBUG] ❌ Image upload error: $e');
      Fluttertoast.showToast(msg: "Failed to upload image: ${e.toString()}");
      rethrow;
    }
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String gender,
    required String dob,
    required String? description,
    String? facebookUrl,
    String? instagramUrl,
    required double? lat,
    required double? lng,
    required File? imageFile,
    required GlobalKey<ScaffoldState> scaffoldKey,
  }) async {
    print('[DEBUG] Starting profile update...');

    String? imageUrl;
    if (imageFile != null) {
      print('[DEBUG] New image detected, uploading...');
      try {
        imageUrl = await _uploadfileImage(imageFile, scaffoldKey);
        print('[DEBUG] Image uploaded, URL: $imageUrl');
      } catch (e) {
        print('[DEBUG] Image upload failed, aborting profile update');
        throw Exception('Image upload failed: $e');
      }
    }

    String formattedGender = gender == "Male"
        ? "M"
        : gender == "Female"
            ? "F"
            : "O";
    String? formattedLat = lat?.toStringAsFixed(6);
    String? formattedLng = lng?.toStringAsFixed(6);

    final data = <String, dynamic>{
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'gender': formattedGender,
      'dob': dob,
      'description': description,
      'facebookURL': facebookUrl,
      'instagramURL': instagramUrl,
      'lat': formattedLat,
      'lng': formattedLng,
      if (imageUrl != null) 'image': imageUrl,
    };

    data.removeWhere((key, value) => value == null);
    print('[DEBUG] Profile update data: $data');

    final req = HttpRequestModel(
      url: 'users/updateProfile',
      method: RequestMethodType.PUT,
      body: json.encode(data),
      headerType: "json",
      authMethod: true,
    );
    try {
      globalWidgets.showLoading(scaffoldKey.currentContext!);
      final response = await httpService.init(req, scaffoldKey);
      globalWidgets.hideLoading();
      print('[DEBUG] Profile update response: $response');
      final jsonRes = jsonDecode(response);
      final user = UserModel.fromJson(jsonRes);
      if (user.success == 200) {
        print('[DEBUG] Profile updated successfully');
        await _saveUserData(user.result?.token ?? '', user.result);
      } else {
        print('[DEBUG] Profile update failed: ${user.message}');
        throw Exception(user.message);
      }
    } catch (e) {
      print('[DEBUG] Profile update error: $e');
      globalWidgets.hideLoading();
      Fluttertoast.showToast(msg: "Failed to update profile: $e");
      rethrow;
    }
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required GlobalKey<ScaffoldState> scaffoldKey,
  }) async {
    final data = <String, dynamic>{
      'old_password': oldPassword,
      'password': newPassword,
    };

    final req = HttpRequestModel(
      url: 'users/changePassword',
      method: RequestMethodType.POST,
      body: json.encode(data),
      headerType: "json",
      authMethod: true,
    );

    try {
      globalWidgets.showLoading(scaffoldKey.currentContext!);
      final response = await httpService.init(req, scaffoldKey);
      globalWidgets.hideLoading();

      final jsonRes = jsonDecode(response);
      final user = UserModel.fromJson(jsonRes);

      if (user.success != 200) {
        throw Exception(user.message);
      }
    } catch (e) {
      globalWidgets.hideLoading();
      rethrow;
    }
  }

  Future<void> deleteAccount(GlobalKey<ScaffoldState> scaffoldKey) async {
    final req = HttpRequestModel(
      url: 'users/deleteUser',
      method: RequestMethodType.DELETE,
      body: '',
      headerType: "json",
      authMethod: true,
    );

    try {
      globalWidgets.showLoading(scaffoldKey.currentContext!);
      final response = await httpService.init(req, scaffoldKey);
      globalWidgets.hideLoading();

      final jsonRes = jsonDecode(response);
      final user = UserModel.fromJson(jsonRes);

      if (user.success != 200) {
        throw Exception(user.message);
      }
    } catch (e) {
      globalWidgets.hideLoading();
      rethrow;
    }
  }

  Future<void> _saveUserData(String? newToken, UserResult? userInfo) async {
    final prefs = await SharedPreferences.getInstance();
    String currentToken = prefs.getString("token") ?? "";

    if (newToken != null && newToken.isNotEmpty) {
      await prefs.setString("token", newToken);
    } else {
      await prefs.setString("token", currentToken);
    }

    await prefs.setBool("isFromLogin", true);
    await _storeMapData("userdata", userInfo);
  }

  Future<void> _storeMapData(String key, UserResult? userInfo) async {
    if (userInfo != null) {
      final userData = userInfo.toJson();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, json.encode(userData));
    }
  }
}

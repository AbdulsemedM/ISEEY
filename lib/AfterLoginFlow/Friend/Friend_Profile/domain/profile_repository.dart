import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:iseey/GlobalFiles/GlobalMethods.dart';
import 'package:iseey/Models/ChatUserModel.dart';
import 'package:iseey/Services/ApiService.dart';
import 'package:iseey/generated/l10n.dart';

class ProfileRepository {
  final GlobalKey<ScaffoldState> scaffoldKey;

  ProfileRepository(this.scaffoldKey);

  Future<List<ChatUserResult>> getFriendList() async {
    HttpRequestModel req = HttpRequestModel(
      url: 'socket/getChats',
      method: RequestMethodType.GET,
      body: '',
      params: '',
      headerType: "json",
      authMethod: true,
    );
    
    try {
      var response = await HttpService().init(req, scaffoldKey);
      
      if (response is String && response != '') {
        var jsonRes = jsonDecode(response);
        ChatUserModel modelData = ChatUserModel.fromJson(jsonRes);

        if (modelData.success == 200) {
          return modelData.result;
        } else {
          showSuccessOrFail(modelData.message, false, scaffoldKey.currentContext!);
        }
      } else {
        showSuccessOrFail(L10n.current.something_went_wrong, false, scaffoldKey.currentContext!);
      }
    } catch (e) {
      showSuccessOrFail(L10n.current.something_went_wrong, false, scaffoldKey.currentContext!);
      debugPrint("EXCEPTION $e");
    }
    return [];
  }

  Future<bool> blockUser(String userId) async {
    return _performUserBlockAction(userId, 'users/block');
  }

  Future<bool> unblockUser(String userId) async {
    return _performUserBlockAction(userId, 'users/unblock');
  }

  Future<bool> _performUserBlockAction(String userId, String endpoint) async {
    var data = {'user_id': userId};
    var body = json.encode(data);

    HttpRequestModel req = HttpRequestModel(
      url: endpoint,
      method: RequestMethodType.PUT,
      body: body,
      params: '',
      headerType: "json",
      authMethod: true,
    );

    try {
      var response = await HttpService().init(req, scaffoldKey);
      
      if (response is String && response != '') {
        var jsonRes = jsonDecode(response);
        if (jsonRes["success"] == 200) {
          showSuccessOrFail(
            jsonRes["message"],
            true,
            scaffoldKey.currentContext!,
            isTitleEnable: false,
          );
          return true;
        } else {
          showSuccessOrFail(jsonRes["message"], false, scaffoldKey.currentContext!);
          return false;
        }
      }
    } catch (e) {
      debugPrint("EXCEPTION $e");
    }
    return false;
  }

  Future<String?> createOrGetChat(String userId) async {
    var data = {'user_id': userId};
    var body = json.encode(data);

    HttpRequestModel req = HttpRequestModel(
      url: 'socket/createOrGetChat',
      method: RequestMethodType.POST,
      body: body,
      params: '',
      headerType: "json",
      authMethod: true,
    );

    try {
      var response = await HttpService().init(req, scaffoldKey);
      
      if (response is String && response != '') {
        var jsonRes = jsonDecode(response);
        if (jsonRes["success"] == 200) {
          return jsonRes["result"];
        } else {
          showSuccessOrFail(jsonRes["message"], false, scaffoldKey.currentContext!);
        }
      }
    } catch (e) {
      debugPrint("EXCEPTION $e");
    }
    return null;
  }

  String formatUserDob(String dob) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(
      int.parse(dob.isEmpty ? "898108200000" : dob),
    );
    return convertStringFromDate(date: date, dateWantInFormat: "dd-MM-yyyy");
  }
}
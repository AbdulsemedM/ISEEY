import 'dart:convert';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:iseey/GlobalFiles/GlobalVariables.dart';
import 'package:iseey/AfterLoginFlow/Friend/Friend_List/domain/FriendList_Model/FriendListModel.dart';
import 'package:iseey/Models/TableListModel.dart';
import 'package:iseey/Services/ApiService.dart';

class FriendsRepository {
  Future<FriendListModel?> getFriendList() async {
    HttpRequestModel req = HttpRequestModel(
      url: 'friends/friendsList',
      method: RequestMethodType.GET,
      body: '',
      params: '',
      headerType: "json",
      authMethod: true,
    );
    
    try {
      var response = await HttpService().init(req, mainTabsScaffoldKey);
      
      if (response is String && response != '') {
        var jsonRes = jsonDecode(response);
        return FriendListModel.fromJson(jsonRes);
      }
      return null;
    } catch (e) {
      debugPrint("EXCEPTION in getFriendList: $e");
      return null;
    }
  }

  Future<bool> unfriendUser(String friendId) async {
    HttpRequestModel req = HttpRequestModel(
      url: 'friends/unfriend/$friendId',
      method: RequestMethodType.DELETE,
      body: '',
      params: '',
      headerType: "json",
      authMethod: true,
    );
    
    try {
      var response = await HttpService().init(req, mainTabsScaffoldKey);
      
      if (response is String && response != '') {
        var jsonRes = jsonDecode(response);
        return jsonRes["success"] ?? false;
      }
      return false;
    } catch (e) {
      debugPrint("EXCEPTION in unfriendUser: $e");
      return false;
    }
  }

  Future<UserDetail?> getUserDetail(String userId) async {
    HttpRequestModel req = HttpRequestModel(
      url: 'users/getUserDetail/$userId',
      method: RequestMethodType.GET,
      body: '',
      params: '',
      headerType: "json",
      authMethod: true,
    );
    
    try {
      var response = await HttpService().init(req, mainTabsScaffoldKey);
      
      if (response is String && response.isNotEmpty) {
        var jsonRes = jsonDecode(response);
        if (jsonRes["success"] ?? false) {
          return UserDetail.fromJson(jsonRes["result"]);
        }
      }
      return null;
    } catch (e) {
      debugPrint("EXCEPTION in getUserDetail: $e");
      return null;
    }
  }
}
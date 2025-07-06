import 'dart:convert';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:iseey/Services/ApiService.dart';

class TableUserRepository {
  final GlobalKey<ScaffoldState> scaffoldKey;

  TableUserRepository(this.scaffoldKey);

  Future<Map<String, dynamic>> createOrGetChat(
      String userId, String restaurantId) async {
    var data = Map<String, dynamic>();
    data['user_id'] = userId;
    data['restaurant_id'] = restaurantId;

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
      if (response is String) {
        try {
          response = json.decode(response);
        } catch (e) {
          debugPrint("JSON parsing error: $e");
          throw Exception("Invalid response format");
        }
      }

      debugPrint("API Response for createOrGetChat: $response");

      if (response is Map<String, dynamic>) {
        bool success = response["success"] ?? false;
        String message = response["message"] ?? "Unknown error";

        if (success) {
          var chatData = response["data"];
          if (chatData is Map<String, dynamic>) {
            return {
              'success': true,
              'chatId': chatData["_id"] ?? "",
            };
          } else {
            throw Exception("Invalid chat data format");
          }
        } else {
          throw Exception(message);
        }
      } else {
        throw Exception("Unexpected response format");
      }
    } catch (e) {
      debugPrint("Exception: $e");
      rethrow;
    }
  }
}
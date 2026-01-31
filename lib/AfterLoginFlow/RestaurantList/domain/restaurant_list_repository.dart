import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:iseey/Models/restaurant_list_model.dart';
import 'package:iseey/Models/restaurant_list_result.dart';
import 'package:iseey/Services/ApiService.dart';
import 'package:iseey/GlobalFiles/GlobalMethods.dart';

class RestaurantListRepository {
  static const String _restaurantListEndpoint = 'restaurants/list';

  /// Fetches the restaurant list from [restaurants/list].
  /// Sends the auth token in the Authorization header (Bearer) via [authMethod: true].
  Future<List<RestaurantListResult>> getRestaurants(
    BuildContext context,
    GlobalKey<ScaffoldState> scaffoldKey,
  ) async {
    log("Fetching restaurants...");

    HttpRequestModel req = HttpRequestModel(
      url: _restaurantListEndpoint,
      method: RequestMethodType.GET,
      headerType: "json",
      authMethod: true, // sends token from SharedPreferences in Authorization: Bearer <token>
      body: '',
      params: '',
    );

    try {
      final response = await HttpService().init(req, scaffoldKey);
      if (response != '') {
        final decodedResponse = jsonDecode(response);
        RestaurantListModel modelData =
            RestaurantListModel.fromJson(decodedResponse);
        if (modelData.success) {
          return modelData.data.restaurants;
        } else {
          showSuccessOrFail(modelData.message, false, context);
          return [];
        }
      }
      return [];
    } catch (error) {
      log("EXCEPTION $error");
      return [];
    }
  }

  Future<Map<String, dynamic>> checkIfUserCheckInTable(
      BuildContext context,
      GlobalKey<ScaffoldState> scaffoldKey,
      String restaurantId,
      String currentUserId) async {
    HttpRequestModel req = HttpRequestModel(
      url: 'checkIn/getTables/$restaurantId',
      method: RequestMethodType.GET,
      body: '',
      params: '',
      headerType: "json",
      authMethod: true,
    );

    try {
      final response = await HttpService().init(req, scaffoldKey);
      if (response != '') {
        return jsonDecode(response);
      }
      return {'success': false, 'message': 'Empty response'};
    } catch (error) {
      debugPrint("EXCEPTION $error");
      return {'success': false, 'message': error.toString()};
    }
  }

  Future<Map<String, dynamic>> checkIntoTable(
      BuildContext context,
      GlobalKey<ScaffoldState> scaffoldKey,
      String restaurantId,
      String tableNumber,
      bool newsLetter) async {
    var data = {
      'table_number': tableNumber,
      'newsLetter': newsLetter,
    };
    var body = json.encode(data);

    HttpRequestModel req = HttpRequestModel(
      url: 'checkIn/checkInToTable/$restaurantId',
      method: RequestMethodType.POST,
      body: body,
      params: '',
      headerType: "json",
      authMethod: true,
    );

    try {
      final response = await HttpService().init(req, scaffoldKey);
      if (response != '') {
        return jsonDecode(response);
      }
      return {'success': false, 'message': 'Empty response'};
    } catch (error) {
      debugPrint("EXCEPTION $error");
      return {'success': false, 'message': error.toString()};
    }
  }
}

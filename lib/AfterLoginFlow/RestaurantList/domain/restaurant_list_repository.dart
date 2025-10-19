import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iseey/Models/restaurant_list_model.dart';
import 'package:iseey/Models/restaurant_list_result.dart';
import 'package:iseey/Services/ApiService.dart';
import 'package:iseey/GlobalFiles/GlobalMethods.dart';

class RestaurantListRepository {
  Future<List<RestaurantListResult>> getRestaurants(
    BuildContext context,
    GlobalKey<ScaffoldState> scaffoldKey,
  ) async {
    log("Fetching restaurants...");
    Position _currentPosition = await determinePosition();
    final latitude = _currentPosition.latitude;
    final longitude = _currentPosition.longitude;

    log("Latitude: $latitude, Longitude: $longitude");

    HttpRequestModel req = HttpRequestModel(
      url: 'restaurants/list?lat=48.868503765829935&lng=8.089284476540819',
      method: RequestMethodType.GET,
      headerType: "json",
      authMethod: true,
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

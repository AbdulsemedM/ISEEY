import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:iseey/Models/OfferModel.dart';
import 'package:iseey/Services/ApiService.dart';
import 'package:iseey/GlobalFiles/GlobalMethods.dart';

class RestaurantRepository {
  Future<List<OfferListResult>> getOffers(
    BuildContext context,
    GlobalKey<ScaffoldState> scaffoldKey,
    String? restaurantId,
  ) async {
    if (restaurantId == null) {
      showSuccessOrFail(
        'Invalid restaurant ID',
        false,
        context,
      );
      return [];
    }

    HttpRequestModel req = HttpRequestModel(
      url: 'offers/list/$restaurantId',
      method: RequestMethodType.GET,
      body: '',
      headerType: "json",
      authMethod: true,
    );

    try {
      final response = await HttpService().init(req, scaffoldKey);
      if (response is String && response.isNotEmpty) {
        final jsonRes = jsonDecode(response);
        if (jsonRes['success'] == true) {
          final List<dynamic> data = jsonRes['data'] ?? [];
          return data.map((item) => OfferListResult.fromJson(item)).toList();
        } else {
          showSuccessOrFail(
            jsonRes['message'] ?? 'Failed to load offers',
            false,
            context,
          );
          return [];
        }
      }
      return [];
    } catch (e) {
      showSuccessOrFail(
        'Failed to load offers',
        false,
        context,
      );
      return [];
    }
  }
}
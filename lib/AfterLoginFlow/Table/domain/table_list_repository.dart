import 'dart:convert';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:iseey/Models/TableListModel.dart';
import 'package:iseey/Services/ApiService.dart';

class TableRepository {
  final GlobalKey<ScaffoldState> scaffoldKey;

  TableRepository(this.scaffoldKey);

  Future<TableListModel?> getTables(String restaurantId) async {
    HttpRequestModel req = HttpRequestModel(
      url: 'checkIn/getTables/$restaurantId',
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
        return TableListModel.fromJson(jsonRes);
      }
    } catch (e) {
      debugPrint("EXCEPTION $e");
    }
    return null;
  }

 Future<bool> checkoutFromRestaurant(String restaurantId) async {
  HttpRequestModel req = HttpRequestModel(
    url: 'checkIn/checkOutFromRestaurant/$restaurantId',
    method: RequestMethodType.DELETE,
    body: '',
    params: '',
    headerType: "json",
    authMethod: true,
  );
  
  try {
    var response = await HttpService().init(req, scaffoldKey);
    if (response is String && response != '') {
      var jsonRes = jsonDecode(response);
      // Check both possible success indicators
      return jsonRes["success"] == true || jsonRes["success"] == 200;
    }
  } catch (e) {
    debugPrint("EXCEPTION $e");
  }
  return false;
}
}
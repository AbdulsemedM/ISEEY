import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:iseey/Models/restaurant_list_result.dart';

class StateManagement extends ChangeNotifier {
  RestaurantListResult? selectedRestaurant;

  bool? isReload = false;
  bool? isRestaurantReload = false;

  String? strPdfPath = "";
  getStrPdfPath() {
    return strPdfPath;
  }

  getSelectedRestaurant() => selectedRestaurant;

  setSelectedRestaurant(RestaurantListResult restaurant) async {
    selectedRestaurant = restaurant;
    var restaurantMenu = selectedRestaurant?.menu ?? '';
    if (restaurantMenu.contains('.pdf')) {
      await _openPdf(restaurantMenu);
    }

    notifyListeners();
  }

  reloadRestaurantBuild() {
    isRestaurantReload = true;
    notifyListeners();
  }

  reloadBuild() {
    isReload = true;
    notifyListeners();
  }

  _openPdf(String url) async {
    final file = await DefaultCacheManager().getSingleFile(url);

    strPdfPath = file.path;

    return true;
  }
}

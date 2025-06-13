import 'package:flutter/material.dart';
import 'package:iseey/AfterLoginFlow/RestaurantList/domain/restaurant_list_repository.dart';
import 'package:iseey/Models/restaurant_list_result.dart';

class RestaurantListController extends ChangeNotifier {
  final RestaurantListRepository _restaurantRepository;
  RestaurantListController({
    required RestaurantListRepository restaurantRepository,
  }) : _restaurantRepository = restaurantRepository;

  List<RestaurantListResult> restaurants = [];
  List<RestaurantListResult> filteredRestaurants = [];

// load restaurant list
  Future<void> loadRestaurantList({
    required BuildContext context,
    required GlobalKey<ScaffoldState> scaffoldKey,
  }) async {
    try {
      final results =
          await _restaurantRepository.getRestaurants(context, scaffoldKey);
      restaurants = results;
      filteredRestaurants = List.from(restaurants);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading restaurant list: $e');
      rethrow;
    }
  }

  void searchRestaurants(String query) {
    filteredRestaurants = restaurants.where((restaurant) {
      return restaurant.name.toLowerCase().contains(query.toLowerCase()) ||
          restaurant.address.toLowerCase().contains(query.toLowerCase());
    }).toList();
    notifyListeners();
  }

  void onCheckedInReceived(data) {
    int index = restaurants.indexWhere(
      (restaurant) => restaurant.sId == data['restaurant_id'],
    );

    if (index != -1) {
      final restaurant = restaurants[index];
      int count = restaurant.checkedInCount;
      final updatedRestaurants = List.of(restaurants);
      updatedRestaurants[index] = updatedRestaurants[index].copyWith(
        checkedInCount: count + 1,
      );
      restaurants = updatedRestaurants;
      notifyListeners();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:iseey/Models/restaurant_list_result.dart';
import 'package:iseey/generated/l10n.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';

class MenuTabs extends StatelessWidget {
  final RestaurantListResult? restaurant;
  final int selectedIndex;
  final Function(int) onTabSelected;

  const MenuTabs({
    required this.restaurant,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
      color: Colors.transparent,
      child: Row(
        children: [
          if (restaurant?.menu?.isNotEmpty ?? false) _buildTab(0, L10n.current.restaurant_page_menu),
          if (restaurant?.drinkMenu?.isNotEmpty ?? false) _buildTab(1, L10n.current.restaurant_page_drink_menu),
          _buildTab(2, L10n.current.restaurant_page_offers),
        ],
      ),
    );
  }

  Widget _buildTab(int index, String title) {
    return IntrinsicWidth(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => onTabSelected(index),
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: GlobalWidgets.setText(
                title,
                strTextColor: AppColors.strMainTextColorWhite,
                fontSize: 16,
                fontWeight: index == 0 || index == 1 ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
          if (selectedIndex == index || 
              (index == 2 && (restaurant?.menu?.isEmpty ?? true) && (restaurant?.drinkMenu?.isEmpty ?? true)))
            index == 2 
              ? Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Divider(
                    thickness: 2,
                    color: AppColors.mainBackgroundColorOrange,
                    height: 0,
                  ),
                )
              : Divider(
                  thickness: 2,
                  color: AppColors.mainBackgroundColorOrange,
                  height: 0,
                ),
        ],
      ),
    );
  }
}
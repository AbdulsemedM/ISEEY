import 'package:flutter/material.dart';
import 'package:iseey/AfterLoginFlow/Restaurant/domain/restaurant_repository.dart';
import 'package:iseey/AfterLoginFlow/Restaurant/view/widgets/offer_list_item.dart';
import 'package:iseey/Models/OfferModel.dart';
import 'package:iseey/generated/l10n.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:progress_indicators/progress_indicators.dart';

class OfferListSection extends StatefulWidget {
  final String restaurantId;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const OfferListSection({
    required this.restaurantId,
    required this.scaffoldKey,
  });

  @override
  _OfferListSectionState createState() => _OfferListSectionState();
}

class _OfferListSectionState extends State<OfferListSection> {
  final RestaurantRepository _repository = RestaurantRepository();
  List<OfferListResult> offers = [];
  bool isLoading = false;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    _loadOffers();
  }

  Future<void> _loadOffers() async {
    setState(() => isLoading = true);
    final result = await _repository.getOffers(
      context, 
      widget.scaffoldKey, 
      widget.restaurantId,
    );
    setState(() {
      offers = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return _buildLoadingIndicator();
    if (offers.isEmpty) return _buildEmptyState();
    return _buildOfferList();
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GlobalWidgets.setText(
            L10n.current.loading_title,
            strTextColor: AppColors.strMainTextColorWhite,
          ),
          CollectionSlideTransition(
            children: List.generate(4, (index) => Icon(
              Icons.circle,
              color: AppColors.mainBackgroundColorOrange,
              size: 15,
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: GlobalWidgets.setText(
        L10n.current.restaurant_page_no_offers_message,
        strTextColor: AppColors.strMainTextColorWhite,
      ),
    );
  }

  Widget _buildOfferList() {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
      itemCount: offers.length,
      itemBuilder: (context, index) {
        return OfferListItem(
          offer: offers[index],
          isExpanded: selectedIndex == index,
          onTap: () => setState(() {
            selectedIndex = selectedIndex == index ? null : index;
          }),
        );
      },
    );
  }
}
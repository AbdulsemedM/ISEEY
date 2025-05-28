import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:iseey/GlobalFiles/ImageNetwork.dart';
import 'package:iseey/Models/OfferModel.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/Services/assets_constant.dart';
import 'package:iseey/generated/l10n.dart';

class OfferListItem extends StatefulWidget {
  final OfferListResult offer;
  final bool isExpanded;
  final Function() onTap;

  const OfferListItem({
    required this.offer,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  _OfferListItemState createState() => _OfferListItemState();
}

class _OfferListItemState extends State<OfferListItem> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      height: widget.isExpanded ? 250 : 110,
      margin: EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Stack(
          children: [
            Neumorphic(
              style: NeumorphicStyle(
                shape: NeumorphicShape.flat,
                color: AppColors.listBoxBackgroundColor,
                border: NeumorphicBorder(width: 1),
              ),
              child: Column(
                children: [
                  _buildHeader(),
                  if (widget.isExpanded) _buildDescription(),
                ],
              ),
            ),
            _buildExpandIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          margin: EdgeInsets.all(15),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: ImageNetwork(
              url: widget.offer.image,
              fit: BoxFit.cover,
              placeHolder: Icon(Icons.image, size: 45),
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GlobalWidgets.setText(
                widget.offer.name,
                maxLine: 3,
                fontSize: 18,
                strTextColor: AppColors.strMainTextColorWhite,
              ),
              Neumorphic(
                style: NeumorphicStyle(
                  color: AppColors.mainBackgroundColorOrange,
                  shape: NeumorphicShape.flat,
                ),
                child: GlobalWidgets.setText(
                  widget.offer.offerType == 'flat'
                      ? '${widget.offer.discount}${widget.offer.currencyDetails?.symbol}'
                      : "${widget.offer.discount}% Off",
                  fontSize: 12,
                  strTextColor: AppColors.strMainTextColorWhite,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            GlobalWidgets.setText(
              L10n.current.edit_profile_description_text_field,
              strTextColor: AppColors.mainTextColorWhite,
              fontSize: 14,
            ),
            GlobalWidgets.setText(
              widget.offer.description,
              strTextColor: AppColors.mainTextColorWhite,
              fontSize: 12,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandIcon() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Neumorphic(
        style: NeumorphicStyle(
          color: widget.isExpanded
              ? AppColors.mainBackgroundColorOrange
              : AppColors.screensBackgroundsColor,
          shape: NeumorphicShape.flat,
        ),
        child: Image.asset(
          widget.isExpanded 
              ? AssetsConstant.upArrowIcon 
              : AssetsConstant.downArrowIcon,
          width: 30,
          height: 30,
        ),
      ),
    );
  }
}
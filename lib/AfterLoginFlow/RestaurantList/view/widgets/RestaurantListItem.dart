import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:iseey/AfterLoginFlow/RestaurantList/view/widgets/StarRating.dart';
import 'package:iseey/Models/restaurant_list_result.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:iseey/Services/assets_constant.dart';

class RestaurantListItem extends StatelessWidget {
  final RestaurantListResult restaurant;
  final VoidCallback onTap;

  const RestaurantListItem({
    super.key,
    required this.restaurant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    restaurant.address.substring(
      restaurant.address.indexOf(',') + 2,
      restaurant.address.length,
    );

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        child: Neumorphic(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          padding: EdgeInsets.zero,
          style: NeumorphicStyle(
            shape: NeumorphicShape.flat,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(5)),
            depth: 0,
            lightSource: LightSource.top,
            color: AppColors.listBoxBackgroundColor,
            border: NeumorphicBorder(
              color: AppColors.fieldShadow,
              width: 1,
            ),
            shadowDarkColor: AppColors.innerShadowColor,
            shadowLightColorEmboss: Colors.transparent,
            shadowDarkColorEmboss: AppColors.innerShadowColor,
          ),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  restaurant.restaurantImage?.location ?? restaurant.logo ?? '',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            decoration: NeumorphicDecoration(
                              splitBackgroundForeground: true,
                              isForeground: false,
                              renderingByPath: true,
                              shape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.all(Radius.circular(4))),
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.concave,
                                boxShape: NeumorphicBoxShape.circle(),
                                depth: 1,
                                lightSource: LightSource.topLeft,
                                border: NeumorphicBorder(
                                  color: AppColors.innerShadowColor,
                                  width: 1.5,
                                ),
                                shadowLightColorEmboss:
                                    AppColors.innerShadowColor,
                                shadowDarkColorEmboss:
                                    AppColors.innerShadowColor,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: GlobalWidgets.setText(
                                "${restaurant.checkedInCount}",
                                fontSize: 18.0,
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.w600,
                                strTextColor: AppColors.strMainTextColorWhite,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(8, 20, 2, 5),
                                child: GlobalWidgets.setText(
                                  restaurant.name,
                                  fontSize: 12,
                                  maxLine: 2,
                                  fontWeight: FontWeight.w500,
                                  strTextColor: AppColors.strMainTextColorWhite,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8, right: 3),
                                child: NeumorphicButton(
                                  onPressed: () => launchUrl(
                                    Uri.parse(restaurant.googlePageUrl ??
                                        'www.iseey.app'),
                                    mode: LaunchMode.inAppWebView,
                                  ),
                                  padding: EdgeInsets.only(
                                      left: 8, bottom: 8, top: 5),
                                  style: NeumorphicStyle(
                                    shape: NeumorphicShape.convex,
                                    boxShape: NeumorphicBoxShape.beveled(
                                        BorderRadius.circular(4)),
                                    depth: 2,
                                    lightSource: LightSource.bottomLeft,
                                    color: AppColors.listBoxBackgroundColor,
                                    border: NeumorphicBorder(
                                      color: AppColors.innerShadowColor,
                                      width: 0.3,
                                    ),
                                    shadowDarkColor: AppColors.innerShadowColor,
                                    shadowLightColorEmboss:
                                        AppColors.innerShadowColor,
                                    shadowDarkColorEmboss:
                                        AppColors.innerShadowColor,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      StarRating(
                                        rating: restaurant.ratings,
                                      ),
                                      Flexible(
                                              child: GlobalWidgets.setText(
                                                ' ${restaurant.ratings}' +
                                                    ' Reviews (${restaurant.reviewsCount ?? '0'})',
                                                fontSize: 10,
                                                fontHeight: 1,
                                                strTextColor: AppColors
                                                    .strMainTextColorWhite,
                                                maxLine: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (restaurant.facebook != '') ...[
                            _buildSocialButton(
                              AssetsConstant.facebook,
                              () => launchURL(restaurant.facebook ??
                                  'https://www.facebook.com'),
                            ),
                            if (restaurant.instagram != '') _buildDivider(),
                          ],
                          if (restaurant.instagram != '') ...[
                            _buildSocialButton(
                              AssetsConstant.instagram,
                              () => launchURL(restaurant.instagram ??
                                  'https://www.instagram.com'),
                            ),
                            if (restaurant.website != '') _buildDivider(),
                          ],
                          if (restaurant.website != '') ...[
                            _buildSocialButton(
                              AssetsConstant.website,
                              () => launchURL(
                                  restaurant.website ?? 'https://iseey.app/'),
                              isWebsite: true,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String asset, VoidCallback onPressed,
      {bool isWebsite = false}) {
    return Container(
      width: 35,
      height: 35,
      child: NeumorphicButton(
        padding: EdgeInsets.zero,
        child: Center(
          child: Image.asset(
            asset,
            fit: BoxFit.contain,
            color: isWebsite ? Colors.white : null,
            height: isWebsite ? 20 : null,
          ),
        ),
        onPressed: onPressed,
        style: NeumorphicStyle(
          shape: NeumorphicShape.flat,
          boxShape: NeumorphicBoxShape.circle(),
          depth: -5,
          lightSource: LightSource.top,
          color: AppColors.listBoxBackgroundColor,
          border: NeumorphicBorder(
            color: AppColors.innerShadowColor,
            width: 0.3,
          ),
          shadowDarkColor: AppColors.innerShadowColor,
          shadowLightColorEmboss: AppColors.innerShadowColor,
          shadowDarkColorEmboss: AppColors.innerShadowColor,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const SizedBox(
      height: 1,
      width: 5,
    );
  }

  Future<void> launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}

import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:iseey/GlobalFiles/GlobalFiles.dart';
import 'package:iseey/Models/restaurant_list_result.dart';
import 'package:iseey/Services/StateManagement.dart';
import 'package:iseey/Services/assets_constant.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'widgets/menu_tabs.dart';
import 'widgets/menu_content.dart';
import 'widgets/offer_list_section.dart';

class RestaurantScreen extends StatefulWidget {
  @override
  _RestaurantScreenState createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late RestaurantListResult? selectedRestaurant;
  late WebViewController foodMenuController;
  late WebViewController drinkMenuController;
  int selectedScreenIndex = 0;
  bool isMenuUrl = false;
  bool isDrinkMenuUrl = false;
  String foodMenu = "";
  String drinkMenu = "";

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  @override
  void didChangeDependencies() {
    selectedRestaurant = Provider.of<StateManagement>(context).getSelectedRestaurant();
    final isReload = Provider.of<StateManagement>(context).isRestaurantReload ?? false;
    if (isReload) _handleReload();
    super.didChangeDependencies();
  }

  void _initControllers() {
    foodMenuController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent);

    drinkMenuController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent);
  }

  void _handleReload() {
    Provider.of<StateManagement>(context).isRestaurantReload = false;
    if (selectedRestaurant != null) {
      setState(() {
        foodMenu = selectedRestaurant!.menu ?? '';
        drinkMenu = selectedRestaurant!.drinkMenu ?? '';
        isMenuUrl = selectedRestaurant!.menuType == "url";
        isDrinkMenuUrl = selectedRestaurant!.drinkMenuType == "url";
        selectedScreenIndex = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.screensBackgroundsColor,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          padding: EdgeInsets.only(top: 15),
          child: Column(
            children: [
              _buildAppBar(),
              MenuTabs(
                restaurant: selectedRestaurant,
                selectedIndex: selectedScreenIndex,
                onTabSelected: (index) {
                  setState(() {
                    selectedScreenIndex = index;
                    FocusScope.of(context).unfocus();
                  });
                },
              ),
              _buildContentSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      children: [
        Container(
          width: 45,
          height: 45,
          alignment: Alignment.center,
          child: NeumorphicButton(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Center(
              child: Image.asset(
                AssetsConstant.bars,
                fit: BoxFit.contain,
              ),
            ),
            onPressed: () => mainTabsScaffoldKey.currentState?.openDrawer(),
            style: NeumorphicStyle(
              shape: NeumorphicShape.flat,
              depth: -2,
              color: AppColors.listBoxBackgroundColor,
              border: NeumorphicBorder(
                color: AppColors.innerShadowColor,
                width: 0.1,
              ),
              intensity: 0.6,
              shadowDarkColor: AppColors.innerShadowColor,
              shadowLightColorEmboss: AppColors.innerShadowColor,
              shadowDarkColorEmboss: AppColors.innerShadowColor,
            ),
          ),
        ),
        Flexible(
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: 20, left: 10),
            width: double.infinity,
            child: Center(
              child: GlobalWidgets.setText(
                selectedRestaurant?.name ?? '',
                fontSize: 22,
                maxLine: 2,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w500,
                strTextColor: AppColors.strMainTextColorWhite,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentSection() {
    if (selectedRestaurant == null) return SizedBox();

    return Expanded(
      child: Builder(
        builder: (context) {
          switch (selectedScreenIndex) {
            case 0:
              return foodMenu.isNotEmpty
                  ? MenuContent(
                      menuUrl: foodMenu,
                      isUrl: isMenuUrl,
                      controller: foodMenuController,
                    )
                  : _buildNoContent();
            case 1:
              return drinkMenu.isNotEmpty
                  ? MenuContent(
                      menuUrl: drinkMenu,
                      isUrl: isDrinkMenuUrl,
                      controller: drinkMenuController,
                    )
                  : _buildNoContent();
            case 2:
            default:
              return OfferListSection(
                restaurantId: selectedRestaurant!.sId,
                scaffoldKey: scaffoldKey,
              );
          }
        },
      ),
    );
  }

  Widget _buildNoContent() {
    return Center(
      child: GlobalWidgets.setText(
        'No content available',
        fontSize: 18,
        strTextColor: AppColors.strMainTextColorWhite,
      ),
    );
  }
}
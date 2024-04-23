import 'dart:convert';

import 'package:ISEEY/GlobalFiles/GlobalFiles.dart';
import 'package:ISEEY/Models/OfferModel.dart';
import 'package:ISEEY/Models/restaurant_list_result.dart';
import 'package:ISEEY/Services/ApiService.dart';
import 'package:ISEEY/Services/StateManagement.dart';
import 'package:ISEEY/Services/assets_constant.dart';
import 'package:ISEEY/generated/l10n.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum MenuType { url, file, none }

class RestaurantScreen extends StatefulWidget {
  @override
  _RestaurantScreenState createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late WebViewController foodMenuController;
  late WebViewController drinkMenuController;
  late RestaurantListResult? selectedRestaurant;
  late MenuType foodMenuType;
  late MenuType drinkMenuType;

  int? selectedIndex = -1;
  bool isMenuUrl = false;
  bool isDrinkMenuUrl = false;
  String foodMenu = "";
  String drinkMenu = "";
  bool load = false;
  WebViewController? webViewController;
  List<OfferListResult> offerListResult = [];
  int selectedScreenIndex = 0;

  @override
  void initState() {
    super.initState();

    initWebView();
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => callGetOfferApi(scaffoldKey));
    selectedRestaurant =
        Provider.of<StateManagement>(context).getSelectedRestaurant();
    bool isReload =
        Provider.of<StateManagement>(context).isRestaurantReload ?? false;
    if (isReload) {
      callRebuild();
    }
    loadDrinkMenu();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = selectedRestaurant;
    foodMenu = restaurant != null ? restaurant.menu ?? '' : '';
    drinkMenu = restaurant != null ? restaurant.drinkMenu ?? '' : '';
    final drinkMenuUri = Uri.tryParse(
      drinkMenu.toString().isEmpty
          ? selectedRestaurant?.drinkMenu ?? ''
          : drinkMenu,
    );

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.screensBackgroundsColor,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          padding: EdgeInsets.only(top: 15),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    alignment: Alignment.center,
                    child: NeumorphicButton(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Center(
                        child: Image.asset(
                          AssetsConstant.instance.bars,
                          fit: BoxFit.contain,
                        ),
                      ),
                      onPressed: () {
                        mainTabsScaffoldKey.currentState?.openDrawer();
                      },
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
                          selectedRestaurant != null
                              ? selectedRestaurant?.name
                              : '',
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
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                color: Colors.transparent,
                child: Row(
                  children: [
                    foodMenu == ""
                        ? SizedBox()
                        : IntrinsicWidth(
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (!mounted) return;
                                    setState(() {
                                      FocusScope.of(context).unfocus();
                                      selectedScreenIndex = 0;
                                      foodMenu = restaurant != null
                                          ? restaurant.menu.toString()
                                          : '';
                                      if (restaurant != null &&
                                          restaurant.menuType == "url") {
                                        isMenuUrl = true;
                                      } else {
                                        isMenuUrl = false;
                                      }
                                    });
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    padding:
                                        EdgeInsets.fromLTRB(10, 20, 10, 10),
                                    child: GlobalWidgets.setText(
                                      L10n.current.restaurant_page_menu,
                                      strTextColor:
                                          AppColors.strMainTextColorWhite,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                selectedScreenIndex == 0
                                    ? Divider(
                                        thickness: 2,
                                        color:
                                            AppColors.mainBackgroundColorOrange,
                                        height: 0,
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                    drinkMenu == ""
                        ? SizedBox()
                        : IntrinsicWidth(
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      FocusScope.of(context).unfocus();
                                      selectedScreenIndex = 1;
                                      drinkMenu = restaurant != null
                                          ? restaurant.drinkMenu.toString()
                                          : '';
                                      if (restaurant != null &&
                                          restaurant.drinkMenuType == "url") {
                                        isDrinkMenuUrl = true;
                                      } else {
                                        isDrinkMenuUrl = false;
                                      }
                                    });
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    padding:
                                        EdgeInsets.fromLTRB(10, 20, 10, 10),
                                    child: GlobalWidgets.setText(
                                      L10n.current.restaurant_page_drink_menu,
                                      strTextColor:
                                          AppColors.strMainTextColorWhite,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                selectedScreenIndex == 1
                                    ? Divider(
                                        thickness: 2,
                                        color:
                                            AppColors.mainBackgroundColorOrange,
                                        height: 0,
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                    IntrinsicWidth(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedScreenIndex = 2;
                                FocusScope.of(context).unfocus();
                                callGetOfferApi(scaffoldKey);
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(10, 20, 13, 10),
                              margin: EdgeInsets.only(left: 20),
                              child: GlobalWidgets.setText(
                                L10n.current.restaurant_page_offers,
                                strTextColor: AppColors.strMainTextColorWhite,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          selectedScreenIndex == 2 ||
                                  noFoodAndDrinkMenu(foodMenu, drinkMenu)
                              ? Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Divider(
                                    thickness: 2,
                                    color: AppColors.mainBackgroundColorOrange,
                                    height: 0,
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              selectedScreenIndex == 0 && foodMenu != ""
                  ? Flexible(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                        width: double.infinity,
                        child: Neumorphic(
                          style: NeumorphicStyle(
                            shape: NeumorphicShape.flat,
                            depth: 0,
                            lightSource: LightSource.top,
                            color: AppColors.listBoxBackgroundColor,
                            border: NeumorphicBorder(
                              color: AppColors.innerShadowColor,
                              width: 1,
                            ),
                            shadowDarkColor: AppColors.innerShadowColor,
                            shadowLightColorEmboss: Colors.transparent,
                            shadowDarkColorEmboss: AppColors.innerShadowColor,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              if (isMenuUrl) {
                                FocusScope.of(context).unfocus();
                                launchURL(foodMenu);
                              }
                            },
                            child: foodMenu.contains('.pdf')
                                ? Center(
                                    child: WebViewWidget(
                                      controller: foodMenuController
                                        ..loadRequest(Uri.parse(
                                            'https://docs.google.com/gview?embedded=true&url=$foodMenu')),
                                    ),
                                  )
                                : isMenuUrl
                                    ? Center(
                                        child: WebViewWidget(
                                          controller: foodMenuController
                                            ..loadRequest(Uri.parse(foodMenu
                                                    .toString()
                                                    .isEmpty
                                                ? selectedRestaurant?.menu ?? ''
                                                : foodMenu)),
                                        ),
                                      )
                                    : PDF(swipeHorizontal: true).cachedFromUrl(
                                        foodMenu,
                                        placeholder: (progress) =>
                                            Center(child: Text('$progress %')),
                                        errorWidget: (error) => Center(
                                            child: Text(error.toString())),
                                      ),
                          ),
                        ),
                      ),
                    )
                  : selectedScreenIndex == 1 && drinkMenu != ""
                      ? Flexible(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                            width: double.infinity,
                            child: Neumorphic(
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.flat,
                                depth: 0,
                                lightSource: LightSource.top,
                                color: AppColors.listBoxBackgroundColor,
                                border: NeumorphicBorder(
                                  color: AppColors.innerShadowColor,
                                  width: 1,
                                ),
                                shadowDarkColor: AppColors.innerShadowColor,
                                shadowLightColorEmboss: Colors.transparent,
                                shadowDarkColorEmboss:
                                    AppColors.innerShadowColor,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  if (isDrinkMenuUrl) {
                                    FocusScope.of(context).unfocus();
                                    launchURL(drinkMenu);
                                  }
                                },
                                child: drinkMenu.contains('.pdf')
                                    ? Center(
                                        child: WebViewWidget(
                                          controller: drinkMenuController
                                            ..loadRequest(Uri.parse(
                                                'https://docs.google.com/gview?embedded=true&url=$drinkMenu')),
                                        ),
                                      )
                                    : isDrinkMenuUrl && drinkMenuUri != null
                                        ? Center(
                                            child: WebViewWidget(
                                              controller: drinkMenuController
                                                ..loadRequest(drinkMenuUri),
                                            ),
                                          )
                                        : PDF(swipeHorizontal: true)
                                            .cachedFromUrl(
                                            drinkMenu,
                                            placeholder: (progress) => Center(
                                                child: Text('$progress %')),
                                            errorWidget: (error) => Center(
                                                child: Text(error.toString())),
                                          ),
                              ),
                            ),
                          ),
                        )
                      : Flexible(
                          child: offerListResult.length == 0
                              ? Container(
                                  margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                                  width: double.infinity,
                                  child: Neumorphic(
                                    style: NeumorphicStyle(
                                      shape: NeumorphicShape.flat,
                                      depth: 0,
                                      lightSource: LightSource.top,
                                      color: AppColors.listBoxBackgroundColor,
                                      border: NeumorphicBorder(
                                        color: AppColors.innerShadowColor,
                                        width: 1,
                                      ),
                                      shadowDarkColor:
                                          AppColors.innerShadowColor,
                                      shadowLightColorEmboss:
                                          Colors.transparent,
                                      shadowDarkColorEmboss:
                                          AppColors.innerShadowColor,
                                    ),
                                    child: Center(
                                      child: GlobalWidgets.setText(
                                        L10n.current
                                            .restaurant_page_no_offers_message,
                                        fontSize: 18,
                                        strTextColor:
                                            AppColors.strMainTextColorWhite,
                                      ),
                                    ),
                                  ),
                                )
                              : load
                                  ? Container(
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 25),
                                              child: GlobalWidgets.setText(
                                                  L10n.current.loading_title,
                                                  strTextColor: AppColors
                                                      .strMainTextColorWhite,
                                                  fontSize: 16),
                                            ),
                                            CollectionSlideTransition(
                                              children: <Widget>[
                                                Container(),
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 5, 8, 0),
                                                  child: Icon(
                                                    Icons.circle,
                                                    color: AppColors
                                                        .mainBackgroundColorOrange,
                                                    size: 15,
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 5, 8, 0),
                                                  child: Icon(
                                                    Icons.circle,
                                                    color: AppColors
                                                        .mainBackgroundColorOrange,
                                                    size: 15,
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 5, 8, 0),
                                                  child: Icon(
                                                    Icons.circle,
                                                    color: AppColors
                                                        .mainBackgroundColorOrange,
                                                    size: 15,
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 5, 0, 0),
                                                  child: Icon(
                                                    Icons.circle,
                                                    color: AppColors
                                                        .mainBackgroundColorOrange,
                                                    size: 15,
                                                  ),
                                                ),
                                                SizedBox(),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(
                                      child: ListView.builder(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 30, 0, 30),
                                        itemCount: offerListResult.length,
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext? context, int index) {
                                          return setListItem(index);
                                        },
                                      ),
                                    ),
                        )
            ],
          ),
        ),
      ),
    );
  }

  noFoodAndDrinkMenu(String foodMenu, String drinkMenu) =>
      foodMenu == '' && drinkMenu == '';

  callGetOfferApi(GlobalKey<ScaffoldState> scaffoldKey) async {
    HttpRequestModel req = new HttpRequestModel(
      url: 'offers/list/$selectedRestaurantId',
      method: RequestMethodType.GET,
      body: '',
      params: '',
      headerType: "json",
      authMethod: true,
    );

    var response;
    var x = GlobalWidgets();

    try {
      setState(() {
        load = true;
      });
      response = await HttpService().init(req, scaffoldKey);
      setState(() {
        load = false;
      });
      if (response is String && response != '') {
        final jsonRes = jsonDecode(response);
        final modelData = OfferModel.fromJson(jsonRes);

        if (modelData.success == 200) {
          if (offerListResult.isEmpty && modelData.result.isNotEmpty) //
            setState(() => offerListResult = modelData.result);
        }
      } else {
        showSuccessOrFail(
          L10n.current.something_went_wrong,
          000,
          context,
        );
      }
    } catch (e) {
      debugPrint("EXCEPTION $e");
    }
    x.hideLoading();
  }

  static MenuType getMenuTypeFromString(String? typeString) {
    switch (typeString) {
      case "url":
        return MenuType.url;
      case "file":
        return MenuType.file;
      default:
        return MenuType.none;
    }
  }

  void callRebuild() async {
    Provider.of<StateManagement>(context).isRestaurantReload = false;
    Future.delayed(
      Duration(milliseconds: 1),
      () {
        final restaurant = selectedRestaurant;
        if (restaurant != null)
          setState(() {
            foodMenu = restaurant.menu ?? '';
            drinkMenu = restaurant.drinkMenu ?? '';
            isMenuUrl =
                getMenuTypeFromString(restaurant.menuType) == MenuType.url;
            isDrinkMenuUrl =
                getMenuTypeFromString(restaurant.drinkMenuType) == MenuType.url;
          });
      },
    );
  }

  setListItem(int index) {
    OfferListResult? offer = offerListResult[index];

    SizedText textSize = SizedText(
      text: offer.description,
      textWidth: screenSize.width - 100,
      context: context,
      fontSize: 12,
    );
    double height = textSize.getSize().height;

    return AnimatedContainer(
      constraints: BoxConstraints(
        maxHeight: 350,
      ),
      height: selectedIndex == index ? (height + 180) : 110,
      margin: EdgeInsets.only(bottom: 20),
      duration: Duration(milliseconds: 400),
      child: GestureDetector(
        onTap: () {
          setState(() {
            FocusScope.of(context).unfocus();
            if (selectedIndex == index) {
              selectedIndex = -1;
            } else {
              selectedIndex = index;
            }
          });
        },
        child: Stack(
          children: [
            Neumorphic(
              style: NeumorphicStyle(
                shape: NeumorphicShape.flat,
                boxShape: NeumorphicBoxShape.roundRect(
                  BorderRadius.circular(5),
                ),
                depth: -3,
                lightSource: LightSource.top,
                color: AppColors.listBoxBackgroundColor,
                border: NeumorphicBorder(
                  color: AppColors.innerShadowColor,
                  width: 1,
                ),
                shadowDarkColor: AppColors.innerShadowColor,
                shadowLightColorEmboss: Colors.transparent,
                shadowDarkColorEmboss: AppColors.innerShadowColor,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        margin: EdgeInsets.only(left: 15, top: 15, bottom: 15),
                        decoration: BoxDecoration(),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: ImageNetwork(
                            url: offer.image.toString(),
                            fit: BoxFit.cover,
                            placeHolder: Center(
                              child: Container(
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: Icon(
                                    Icons.image,
                                    size: 45,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(20, 10, 10, 5),
                            child: GlobalWidgets.setText(
                              offer.name,
                              maxLine: 3,
                              fontSize: 18,
                              strTextColor: AppColors.strMainTextColorWhite,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(20, 10, 0, 5),
                            child: Neumorphic(
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.flat,
                                color: AppColors.mainBackgroundColorOrange,
                                depth: -3,
                                lightSource: LightSource.top,
                                shadowDarkColor: AppColors.innerShadowColor,
                                shadowLightColor: Colors.transparent,
                                shadowLightColorEmboss: Colors.transparent,
                                shadowDarkColorEmboss:
                                    AppColors.innerShadowColor,
                                border: NeumorphicBorder(
                                  color: Color(0x33000000),
                                  width: 1,
                                ),
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(10)),
                              ),
                              padding: EdgeInsets.fromLTRB(10, 6, 10, 5),
                              child: GlobalWidgets.setText(
                                  offer.offerType == 'flat'
                                      ? '${offer.discount}${offer.currencyDetails?.symbol}'
                                      : "${offer.discount}% Off",
                                  fontSize: 12,
                                  strTextColor: AppColors.strMainTextColorWhite,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 15),
                            alignment: Alignment.topLeft,
                            child: GlobalWidgets.setText(
                              L10n.current.edit_profile_description_text_field,
                              strTextColor: AppColors.mainTextColorWhite,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Flexible(
                            child: SingleChildScrollView(
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 15, top: 10, right: 30),
                                alignment: Alignment.topLeft,
                                child: GlobalWidgets.setText(offer.description,
                                    strTextColor: AppColors.mainTextColorWhite,
                                    fontSize: 12,
                                    fontHeight: 1.5,
                                    fontWeight: FontWeight.normal,
                                    maxLine: 5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 30,
                height: 30,
                child: Neumorphic(
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.flat,
                    boxShape: NeumorphicBoxShape.roundRect(
                      BorderRadius.only(
                        bottomRight: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(5),
                      ),
                    ),
                    depth: -3,
                    lightSource: LightSource.top,
                    color: selectedIndex == index
                        ? AppColors.mainBackgroundColorOrange
                        : AppColors.screensBackgroundsColor,
                    border: NeumorphicBorder(
                      color: AppColors.innerShadowColor,
                      width: 1,
                    ),
                    shadowDarkColor: AppColors.innerShadowColor,
                    shadowLightColorEmboss: Colors.transparent,
                    shadowDarkColorEmboss: AppColors.innerShadowColor,
                  ),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 5, 7),
                    child: Image.asset(
                      selectedIndex == index
                          ? AssetsConstant.instance.upArrowIcon
                          : AssetsConstant.instance.downArrowIcon,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void loadDrinkMenu() {
    Future.delayed(Duration(seconds: 1), () {
      if (foodMenu.contains('.pdf')) {
        foodMenuController
          ..loadRequest(Uri.parse(
            'https://docs.google.com/gview?embedded=true&url=$foodMenu',
          ));
      }
      if (isMenuUrl) {
        foodMenuController
          ..loadRequest(Uri.parse(
            foodMenu.toString().isEmpty
                ? selectedRestaurant?.menu ?? ''
                : foodMenu,
          ));
      }

      if (drinkMenu.contains('.pdf')) {
        drinkMenuController
          ..loadRequest(Uri.parse(
            'https://docs.google.com/gview?embedded=true&url=$drinkMenu',
          ));
      }
      if (isDrinkMenuUrl) {
        drinkMenuController
          ..loadRequest(Uri.parse(
            drinkMenu.toString().isEmpty
                ? selectedRestaurant?.drinkMenu ?? ''
                : drinkMenu,
          ));
      }
    });
  }

  void initWebView() {
    foodMenuController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('Food WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Food Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Food Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('Food Page error loading: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url
                .startsWith('https://www.youtube.com/watch?v=_oM_AD3OSbk')) {
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      );

    drinkMenuController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('Drink WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Drink Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Drink Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('Food Page error loading: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url
                .startsWith('https://www.youtube.com/watch?v=_oM_AD3OSbk')) {
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      );
  }
}

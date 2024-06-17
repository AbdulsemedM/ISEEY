import 'dart:convert';

import 'package:ISEEY/GlobalFiles/AppColors.dart';
import 'package:ISEEY/GlobalFiles/GlobalMethods.dart';
import 'package:ISEEY/GlobalFiles/GlobalVariables.dart';
import 'package:ISEEY/GlobalFiles/GlobalWidgets.dart';
import 'package:ISEEY/GlobalFiles/transitions/slide_route.dart';
import 'package:ISEEY/Models/restaurant_list_model.dart';
import 'package:ISEEY/Models/restaurant_list_result.dart';
import 'package:ISEEY/Services/ApiService.dart';
import 'package:ISEEY/Services/ChatController.dart';
import 'package:ISEEY/Services/StateManagement.dart';
import 'package:ISEEY/Services/assets_constant.dart';
import 'package:ISEEY/generated/l10n.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'TableList.dart';

class RestaurantList extends StatefulWidget {
  @override
  _RestaurantListState createState() => _RestaurantListState();
}

class _RestaurantListState extends State<RestaurantList> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchTextController = TextEditingController();
  TextEditingController tableNumberController = TextEditingController();
  ChatListController _chatListController = Get.put(ChatListController());
  List<RestaurantListResult> restaurantListResult = [];

  OverlayEntry? overlayEntry;
  bool isAgree = false;
  bool isNewLetterSelected = false;
  String restaurantId = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      callGetRestaurantApi(scaffoldKey);
      _onConnect();
    });
  }

  _onConnect() async {
    await GlobalWidgets.initSocket();
    await GlobalWidgets.socketUtils.initSocket(null, '');

    GlobalWidgets.socketUtils.connectToSocket();
    GlobalWidgets.socketUtils.setOnCheckedInListener(onCheckedInReceived);
  }

  onCheckedInReceived(data) {
    printInfo(info: "Checked in received $data");
    int index = restaurantListResult.indexWhere((restaurant) => restaurant.sId == data['restaurant_id']);
    printInfo(info: "Index: $index");
    if (index != -1) {
      printInfo(info: "lao");
      final resturant = restaurantListResult[index];
      int count = resturant.checkedInCount;
      final resturants = List.of(restaurantListResult);
      resturants[index] = resturants[index].copyWith(
        checkedInCount: count + 1,
      );
      restaurantListResult = resturants;
      setState(() {});
    }
  }

  callGetRestaurantApi(GlobalKey<ScaffoldState> scaffoldKey) async {
    Position _currentPosition = await determinePosition();
    final latitude = _currentPosition.latitude;
    final longitude = _currentPosition.longitude;

    HttpRequestModel req = new HttpRequestModel(
        url: 'restaurants/list?lat=$latitude&lng=$longitude',
        method: RequestMethodType.GET,
        body: '',
        params: '',
        headerType: "json",
        authMethod: true);
    var response;
    var x = GlobalWidgets();

    try {
      response = await HttpService().init(req, scaffoldKey);

      if (response is String && response != '') {
        var jsonRes = jsonDecode(response);

        RestaurantListModel modelData = RestaurantListModel.fromJson(jsonRes);

        if (modelData.success == 200) {
          setState(() {
            restaurantListResult = modelData.result;
          });
        } else {
          showSuccessOrFail(modelData.message, modelData.success, context);
        }
      } else {
        showSuccessOrFail(L10n.current.something_went_wrong, 000, context);
      }
    } catch (e) {
      debugPrint("EXCEPTION $e");
    }
    x.hideLoading();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        key: scaffoldKey,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Row(
            children: [
              SizedBox(width: 12),
              Container(
                width: 40,
                height: 40,
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
                    shape: NeumorphicShape.concave,
                    depth: 1,
                    lightSource: LightSource.top,
                    color: AppColors.mainTextColorBlack.withOpacity(0.7),
                    border: NeumorphicBorder(
                      color: AppColors.innerShadowColor,
                      width: 2,
                    ),
                    shadowDarkColor: AppColors.mainBackgroundColorOrange,
                    shadowLightColorEmboss: Colors.transparent,
                    shadowDarkColorEmboss: AppColors.innerShadowColor,
                  ),
                ),
              ),
            ],
          ),
          title: Container(
            height: 45,
            width: double.infinity,
            child: Neumorphic(
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.all(0),
              style: NeumorphicStyle(
                shape: NeumorphicShape.flat,
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
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 0, 5, 1),
                child: TextField(
                  keyboardAppearance: Brightness.dark,
                  style: TextStyle(
                    color: AppColors.mainTextColorWhite,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                  controller: searchTextController,
                  onChanged: (value) => searchList(value),
                  onEditingComplete: () {
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    searchList(searchTextController.text);
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    suffixIcon: Container(
                        child: IconButton(
                      alignment: Alignment.centerRight,
                      onPressed: () {
                        searchList(searchTextController.text);
                      },
                      icon: Icon(
                        Icons.search,
                        color: AppColors.mainTextColorWhite,
                      ),
                    )),
                    hintStyle: TextStyle(
                      color: AppColors.fieldShadow,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                    hintText: L10n.current.restaurant_list_seach_bar_hint_text,
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              child: Image.asset(
                AssetsConstant.chatBackground2,
                fit: BoxFit.cover,
              ),
            ),
            Container(color: Colors.black87),
            SafeArea(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 30),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: GlobalWidgets.setText(
                          L10n.current.restaurant_list_title,
                          fontSize: 20,
                          strTextColor: AppColors.strMainTextColorWhite,
                        ),
                      ),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        backgroundColor: AppColors.fieldsBackgroundColor,
                        onRefresh: _pullRefresh,
                        child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            alignment: restaurantListResult.length == 0 ? Alignment.center : Alignment.topCenter,
                            child: SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              child: restaurantListResult.length == 0
                                  ? Container(
                                      height: MediaQuery.of(context).size.height * 0.7,
                                      child: Center(
                                        child: Text(
                                          L10n.current.restaurant_list_empty_state_text,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    )
                                  : GridView.builder(
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 6.0,
                                        mainAxisSpacing: 3.0,
                                      ),
                                      padding: EdgeInsets.zero,
                                      itemCount: searchTextController.text.isEmpty
                                          ? restaurantListResult.length
                                          : _searchResult.length == 0
                                              ? 0
                                              : _searchResult.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () {
                                            FocusScope.of(context).unfocus();
                                            RestaurantListResult result = searchTextController.text.isEmpty
                                                ? restaurantListResult[index]
                                                : _searchResult.length == 0
                                                    ? restaurantListResult[index]
                                                    : _searchResult[index];
                                            restaurantId = result.sId;
                                            Provider.of<StateManagement>(context, listen: false).setSelectedRestaurant(result);
                                            isNewLetterSelected = result.newsletter;
                                            isAgree = false;
                                            callCheckIfUserCheckInTableApi(scaffoldKey);
                                          },
                                          child: setListItem(index),
                                        );
                                      },
                                    ),
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pullRefresh() async {
    await callGetRestaurantApi(scaffoldKey);
  }

  List<RestaurantListResult> _searchResult = [];

  searchList(String text) {
    if (text.isEmpty) {
      setState(() {
        _searchResult.clear();
      });
    } else {
      List<RestaurantListResult> tempSearchResult = [];
      restaurantListResult.forEach((restaurantItem) {
        if (restaurantItem.name.toLowerCase().contains(text.toLowerCase()) ||
            restaurantItem.address.toLowerCase().contains(text.toLowerCase())) {
          tempSearchResult.add(restaurantItem);
        }
      });
      setState(() {
        _searchResult.clear();
        _searchResult = tempSearchResult;
      });
    }
  }

  Widget setListItem(int index) {
    RestaurantListResult restaurantDetails = searchTextController.text.isEmpty
        ? restaurantListResult[index]
        : _searchResult.length == 0
            ? restaurantListResult[index]
            : _searchResult[index];

    final address = restaurantDetails.address.substring(
      restaurantDetails.address.indexOf(',') + 2,
      restaurantDetails.address.length,
    );

    return Container(
      child: Neumorphic(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
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
                restaurantListResult[index].restaurantImage?.location ?? restaurantListResult[index].logo,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            color: Colors.black.withOpacity(0.5),
            width: double.infinity,
            height: double.infinity,
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
                            shape: NeumorphicBoxShape.roundRect(BorderRadius.all(Radius.circular(4))),
                            style: NeumorphicStyle(
                              shape: NeumorphicShape.concave,
                              boxShape: NeumorphicBoxShape.circle(),
                              depth: 1,
                              lightSource: LightSource.topLeft,
                              border: NeumorphicBorder(
                                color: AppColors.innerShadowColor,
                                width: 1.5,
                              ),
                              shadowLightColorEmboss: AppColors.innerShadowColor,
                              shadowDarkColorEmboss: AppColors.innerShadowColor,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: GlobalWidgets.setText(
                              "${restaurantDetails.checkedInCount}",
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
                                restaurantDetails.name,
                                fontSize: 12,
                                maxLine: 2,
                                fontWeight: FontWeight.w500,
                                strTextColor: AppColors.strMainTextColorWhite,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            restaurantDetails.ratings == 0.0 //
                                ? SizedBox.shrink()
                                : Padding(
                                    padding: EdgeInsets.only(top: 8, right: 3),
                                    child: NeumorphicButton(
                                      onPressed: () => launchUrl(
                                        Uri.parse(restaurantDetails.googlePageUrl ?? 'www.iseey.app'),
                                        mode: LaunchMode.inAppWebView,
                                      ),
                                      padding: EdgeInsets.only(left: 8, bottom: 8, top: 5),
                                      style: NeumorphicStyle(
                                        shape: NeumorphicShape.convex,
                                        boxShape: NeumorphicBoxShape.beveled(BorderRadius.circular(4)),
                                        depth: 2,
                                        lightSource: LightSource.bottomLeft,
                                        color: AppColors.listBoxBackgroundColor,
                                        border: NeumorphicBorder(
                                          color: AppColors.innerShadowColor,
                                          width: 0.3,
                                        ),
                                        shadowDarkColor: AppColors.innerShadowColor,
                                        shadowLightColorEmboss: AppColors.innerShadowColor,
                                        shadowDarkColorEmboss: AppColors.innerShadowColor,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          buildStarRow(restaurantDetails.ratings),
                                          restaurantDetails.reviews.length == 0
                                              ? SizedBox.shrink()
                                              : Flexible(
                                                  child: GlobalWidgets.setText(
                                                    ' ${restaurantDetails.ratings}' + ' Reviews (${restaurantDetails.reviewsCount ?? '-'})',
                                                    fontSize: 10,
                                                    fontHeight: 1,
                                                    strTextColor: AppColors.strMainTextColorWhite,
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
                    padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (restaurantDetails.facebook != '') ...[
                          Container(
                            width: 40,
                            height: 40,
                            child: NeumorphicButton(
                              padding: EdgeInsets.zero,
                              child: Center(
                                child: Image.asset(AssetsConstant.facebook, fit: BoxFit.contain),
                              ),
                              onPressed: () => launchURL(
                                restaurantDetails.facebook ??
                                    'https://www.facebook.com/people/Iseey-App/pfbid0ACzG98uK5B6YQb5ZaCcv6VZxH2Nebk7TvRujCjh1VgN8XVw7LykSqVRhyYcZx5qJl/',
                              ),
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
                          ),
                          if (restaurantDetails.instagram != '') ...[
                            _buildDivider(),
                          ],
                        ],
                        if (restaurantDetails.instagram != '') ...[
                          Container(
                            width: 40,
                            height: 40,
                            child: NeumorphicButton(
                              padding: EdgeInsets.zero,
                              child: Center(
                                child: Image.asset(
                                  AssetsConstant.instagram,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              onPressed: () => launchURL(
                                restaurantDetails.instagram ?? 'https://www.instagram.com/iseey.app?igshid=YmMyMTA2M2Y%3D',
                              ),
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
                          ),
                          if (restaurantDetails.website != '') ...[
                            _buildDivider(),
                          ],
                        ],
                        if (restaurantDetails.website != '') ...[
                          Container(
                            width: 40,
                            height: 40,
                            child: NeumorphicButton(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Center(
                                child: Image.asset(
                                  AssetsConstant.website,
                                  fit: BoxFit.contain,
                                  color: Colors.white,
                                  height: 25,
                                ),
                              ),
                              onPressed: () => launchURL(restaurantDetails.website ?? 'https://iseey.app/'),
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.flat,
                                boxShape: NeumorphicBoxShape.circle(),
                                depth: -5,
                                lightSource: LightSource.top,
                                color: AppColors.listBoxBackgroundColor,
                                border: NeumorphicBorder(
                                  color: AppColors.innerShadowColor,
                                  width: 0.1,
                                ),
                                shadowDarkColor: AppColors.innerShadowColor,
                                shadowLightColorEmboss: AppColors.innerShadowColor,
                                shadowDarkColorEmboss: AppColors.innerShadowColor,
                              ),
                            ),
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
    );
  }

  Widget _buildDivider() {
    return SizedBox(
      height: 1,
      width: 5,
    );
  }

  buildStarRow(double rating) {
    int fullStars = rating.floor();
    bool hasHalfStar = rating - fullStars > 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(
        5,
        (index) {
          if (index < fullStars) {
            return Icon(
              Icons.star,
              color: Colors.amber,
              size: 10.0,
            );
          } else if (index == fullStars && hasHalfStar) {
            return Icon(
              Icons.star_half,
              color: Colors.amber,
              size: 10.0,
            );
          } else {
            return Icon(
              Icons.star_border,
              color: Colors.white,
              size: 10.0,
            );
          }
        },
      ),
    );
  }

  showTablePopup({required BuildContext context, bool showNewsLetter = false}) {
    OverlayState? overlayState = Overlay.of(context);

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        child: GestureDetector(
          onTap: () {},
          child: Material(
            child: Container(
              width: screenSize.width,
              height: screenSize.height,
              color: AppColors.screensBackgroundsColor,
              child: Center(
                  child: Container(
                width: screenSize.width - 40,
                height: showNewsLetter ? 200 : 250,
                child: Neumorphic(
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.flat,
                    boxShape: NeumorphicBoxShape.roundRect(
                      BorderRadius.circular(5),
                    ),
                    depth: -3,
                    color: AppColors.tabBarBoxBackgroundColor,
                    border: NeumorphicBorder(
                      color: AppColors.innerShadowColor,
                      width: 0.1,
                    ),
                    intensity: 0.5,
                    shadowDarkColor: AppColors.innerShadowColor,
                    shadowLightColorEmboss: AppColors.innerShadowColor,
                    shadowDarkColorEmboss: AppColors.innerShadowColor,
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(left: 20, top: 30),
                              child: GlobalWidgets.setText(
                                L10n.current.table_pop_up_subtitile,
                                fontSize: 18,
                                strTextColor: AppColors.strMainTextColorWhite,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20, top: 15, right: 20),
                              height: 45,
                              width: double.infinity,
                              child: Neumorphic(
                                padding: EdgeInsets.all(0),
                                margin: EdgeInsets.all(0),
                                style: NeumorphicStyle(
                                  shape: NeumorphicShape.flat,
                                  depth: -2,
                                  lightSource: LightSource.top,
                                  color: AppColors.screensBackgroundsColor,
                                  border: NeumorphicBorder(
                                    color: AppColors.innerShadowColor,
                                    width: 0.1,
                                  ),
                                  intensity: 0.5,
                                  shadowDarkColor: AppColors.innerShadowColor,
                                  shadowLightColorEmboss: Colors.transparent,
                                  shadowDarkColorEmboss: AppColors.innerShadowColor,
                                ),
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(10, 0, 5, 1),
                                  child: TextField(
                                    keyboardAppearance: Brightness.dark,
                                    controller: tableNumberController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                    style: TextStyle(
                                      color: AppColors.mainTextColorWhite,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                    ),
                                    decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.mainBackgroundColorOrange,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            isNewLetterSelected
                                ? Container(
                                    margin: EdgeInsets.only(left: 20, top: 15, right: 20),
                                  )
                                : Container(
                                    margin: EdgeInsets.only(left: 20, top: 15, right: 20),
                                    child: Row(
                                      children: [
                                        isAgree
                                            ? InkWell(
                                                onTap: () {
                                                  setState(
                                                    () {
                                                      isAgree = !isAgree;
                                                      overlayEntry?.remove();
                                                      overlayEntry = null;
                                                      showTablePopup(
                                                        context: mainTabsScaffoldKey.currentContext ?? context,
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                  width: 20,
                                                  height: 20,
                                                  child: Image.asset(
                                                    AssetsConstant.selectedCheckbox,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              )
                                            : InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    isAgree = !isAgree;
                                                    overlayEntry?.remove();
                                                    overlayEntry = null;
                                                    showTablePopup(context: mainTabsScaffoldKey.currentContext ?? context);
                                                  });
                                                },
                                                child: Container(
                                                  width: 20,
                                                  height: 20,
                                                  child: Image.asset(
                                                    AssetsConstant.unselectedCheckbox,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                        MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              final agreed = isAgree;
                                              isAgree = !agreed;
                                              overlayEntry?.remove();
                                              overlayEntry = null;
                                              showTablePopup(context: mainTabsScaffoldKey.currentContext ?? context);
                                            });
                                          },
                                          child: GlobalWidgets.setText(
                                            L10n.current.table_pop_up_newsletter_checkbox_text,
                                            textAlign: TextAlign.left,
                                            strTextColor: AppColors.strMainTextColorWhite,
                                            fontSize: 15,
                                            maxLine: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Row(
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    margin: EdgeInsets.fromLTRB(0, 10, 20, 0),
                                    child: Container(
                                      height: 45,
                                      width: 120,
                                      child: GlobalWidgets.setButton(
                                        onPressButton: () async {
                                          if (tableNumberController.text.isEmpty) {
                                            showSuccessOrFail(L10n.current.table_pop_up_error_message, 000, context);
                                            return null;
                                          } else {
                                            overlayEntry?.remove();
                                            overlayEntry = null;

                                            callCheckIntoTableApi();
                                            Map las = await callUpdateLatLong(scaffoldKey);

                                            _chatListController.loc.value = las;
                                          }
                                        },
                                        textWidget: Container(
                                          padding: EdgeInsets.only(top: 3),
                                          alignment: Alignment.center,
                                          child: GlobalWidgets.setText(
                                            L10n.current.done_title,
                                            textAlign: TextAlign.center,
                                            fontSize: 16,
                                            strTextColor: AppColors.strMainTextColorWhite,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Container(
                                      height: 45,
                                      width: 120,
                                      child: GlobalWidgets.setButton(
                                        strButtonColor: "c8c8c8",
                                        onPressButton: () {
                                          overlayEntry?.remove();
                                          overlayEntry = null;
                                        },
                                        textWidget: Container(
                                          padding: EdgeInsets.only(top: 3),
                                          alignment: Alignment.center,
                                          child: GlobalWidgets.setText(
                                            L10n.current.cancel_button_title,
                                            textAlign: TextAlign.center,
                                            fontSize: 16,
                                            strTextColor: "1c1c1c",
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          width: 45,
                          height: 45,
                          alignment: Alignment.center,
                          child: NeumorphicButton(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Center(
                              child: Icon(
                                Icons.close,
                                color: AppColors.mainTextColorWhite,
                                size: 30,
                              ),
                            ),
                            onPressed: () {
                              overlayEntry?.remove();
                              overlayEntry = null;
                            },
                            style: NeumorphicStyle(
                              shape: NeumorphicShape.flat,
                              depth: -3,
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
                      ),
                    ],
                  ),
                ),
              )),
            ),
          ),
        ),
      ),
    );

    overlayState.insert(overlayEntry!);
  }

  void callCheckIfUserCheckInTableApi(GlobalKey<ScaffoldState> scaffoldKey) async {
    HttpRequestModel req = new HttpRequestModel(
        url: 'restaurants/$restaurantId/tables/checkIfUserAlreadyCheckInToRestaurant',
        method: RequestMethodType.GET,
        body: '',
        params: '',
        headerType: "json",
        authMethod: true);
    var response;
    var x = GlobalWidgets();
    try {
      x.showLoading(scaffoldKey.currentContext ?? context);
      response = await HttpService().init(req, scaffoldKey);
      x.hideLoading();

      if (response is String && response != '') {
        var jsonRes = jsonDecode(response);

        int success = jsonRes["success"];
        String message = jsonRes["message"];

        if (success == 200) {
          Map<String, dynamic> result = jsonRes["result"];
          bool exists = result["exists"];
          bool newsLetter = result["newsletter"];
          if (exists) {
            navigateToTableList(restaurantId);
          } else {
            tableNumberController.clear();
            showTablePopup(
              context: mainTabsScaffoldKey.currentContext ?? context,
              showNewsLetter: newsLetter,
            );
          }

          try {
            isNewLetterSelected = newsLetter;
          } catch (_) {}
        } else {
          showSuccessOrFail(message, success, context);
        }
      } else {
        showSuccessOrFail(L10n.current.something_went_wrong, 000, context);
      }
    } catch (e) {
      debugPrint("EXCEPTION $e");
    }
    x.hideLoading();
  }

  callCheckIntoTableApi() async {
    var data = new Map<String, dynamic>();
    data['table_number'] = tableNumberController.text;
    data['newsletter'] = isAgree;
    var body = json.encode(data);

    HttpRequestModel req = new HttpRequestModel(
        url: 'restaurants/$restaurantId/tables/checkInToTable',
        method: RequestMethodType.POST,
        body: body,
        params: '',
        headerType: "json",
        authMethod: true);
    var response;
    var x = GlobalWidgets();
    try {
      final currentContext = scaffoldKey.currentContext;
      if (currentContext != null) x.showLoading(currentContext);
      response = await HttpService().init(req, scaffoldKey);
      x.hideLoading();

      if (response is String && response != '') {
        var jsonRes = jsonDecode(response);

        int success = jsonRes["success"];
        String message = jsonRes["message"];

        if (success == 200) {
          setState(() {
            navigateToTableList(restaurantId);
          });
        } else {
          showSuccessOrFail(message, success, context);
        }
      } else {
        showSuccessOrFail(L10n.current.something_went_wrong, 000, context);
      }
    } catch (e) {
      debugPrint("EXCEPTION $e");
    }
    x.hideLoading();
  }

  navigateToTableList(String restaurantId) {
    selectedRestaurantId = restaurantId;
    return Navigator.push(
      context,
      SlideLeftRoute(
        routeName: "/tableList",
        page: TableList(
          restaurantId: restaurantId,
        ),
      ),
    ).then((value) {
      restaurantId = "";
    });
  }
}

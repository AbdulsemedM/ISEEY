import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getwidget/getwidget.dart';
import 'package:iseey/AfterLoginFlow/TableUserList.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/GlobalFiles/GlobalMethods.dart';
import 'package:iseey/GlobalFiles/GlobalVariables.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/GlobalFiles/transitions/slide_route.dart';
import 'package:iseey/Models/TableListModel.dart';
import 'package:iseey/Models/UserModel.dart';
import 'package:iseey/Services/ApiService.dart';
import 'package:iseey/Services/assets_constant.dart';
import 'package:iseey/generated/l10n.dart';

class TableList extends StatefulWidget {
  final String? restaurantId;

  TableList({Key? key, this.restaurantId}) : super(key: key);

  @override
  _TableListState createState() => _TableListState();
}

class _TableListState extends State<TableList> with WidgetsBindingObserver {
  bool stL = true;
  String lat = '';
  String lng = '';
  bool? isCheckOutAble = false;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    LocationSettings? locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 50,
    );
    Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) {
      lat = position.latitude.toString();
      lng = position.longitude.toString();

      if (mounted) {
        setState(() {});
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      callGetTableApi(scaffoldKey, true);
    });
    Future.delayed(Duration(seconds: 4), () {
      runTimeLock(true);
      _connectSocket();
    });

    firebaseNotificationListen();
    timer = Timer(Duration(minutes: 1), () => _pullRefresh());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    timer.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        checkUserExistInTableList();
        break;

      case AppLifecycleState.inactive:
        // widget is inactive
        break;
      case AppLifecycleState.paused:
        // widget is paused
        break;
      case AppLifecycleState.detached:
        // widget is detached
        break;

      default:
        break;
    }
  }

  cX() async {
    GlobalWidgets.socketUtils.updateLatLng(lat, lng, widget.restaurantId ?? '');
  }

  _connectSocket() async {
    await GlobalWidgets.initSocket();
    await GlobalWidgets.socketUtils.onConnect();
    GlobalWidgets.socketUtils.connectToSocket();
    GlobalWidgets.socketUtils.setConnectListener(onConnect);
    GlobalWidgets.socketUtils.setOnDisconnectListener(onDisconnect);
  }

  onConnect(data) {
    debugPrint('Connected $data');
    if (!mounted) return;
    setState(() {});
  }

  onDisconnect(data) {
    debugPrint('onDisconnect $data');
    if (!mounted) return;
    setState(() {});
  }

  runTimeLock(bool state) {
    if (stL) {
      Timer.periodic(Duration(seconds: 15), (timer) {
        cX();
      });
    }
    return true;
  }

  Restaurant? restaurant;
  List<CheckIns> tableListResult = [];

  callGetTableApi(GlobalKey<ScaffoldState> scaffoldKey, bool showLoader) async {
    HttpRequestModel req = new HttpRequestModel(
      url: 'restaurants/${widget.restaurantId}/tables/getTables',
      method: RequestMethodType.GET,
      body: '',
      params: '',
      headerType: "json",
      authMethod: true,
    );
    var response;
    var x = GlobalWidgets();

    try {
      if (showLoader) x.showLoading(scaffoldKey.currentContext ?? context);
      response = await HttpService().init(req, scaffoldKey);
      x.hideLoading();

      if (response is String && response != '') {
        var jsonRes = jsonDecode(response);
        TableListModel modelData = TableListModel.fromJson(jsonRes);

        if (modelData.success == 200) {
          setState(() {
            tableListResult = modelData.result != null ? modelData.result?.checkIns ?? [] : [];
            restaurant = modelData.result != null
                ? modelData.result?.restaurant != null
                    ? modelData.result?.restaurant
                    : null
                : null;
          });
        } else {
          showSuccessOrFail(modelData.message, false, context);
        }
      } else {
        showSuccessOrFail(L10n.current.something_went_wrong, false, context);
      }
    } catch (e) {
      debugPrint("EXCEPTION $e");
    }
    x.hideLoading();
  }

  TextEditingController searchTextController = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _pullRefresh() async {
    await callGetTableApi(scaffoldKey, false);
  }

  Future<bool> callCheckoutFromRestaurant(
    GlobalKey<ScaffoldState> scaffoldKey,
    String restaurantId,
  ) async {
    HttpRequestModel req = new HttpRequestModel(
      url: 'restaurants/$restaurantId/tables/checkOutFromRestaurant',
      method: RequestMethodType.DELETE,
      body: '',
      params: '',
      headerType: "json",
      authMethod: true,
    );
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
          selectedRestaurantId = "";
          Navigator.pop(context);
          return true;
        } else {
          showSuccessOrFail(message, false, context);
          return false;
        }
      } else {
        showSuccessOrFail(L10n.current.something_went_wrong, false, context);
        return false;
      }
    } catch (e) {
      debugPrint("EXCEPTION $e");
    }
    x.hideLoading();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.screensBackgroundsColor,
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
                              AssetsConstant.leftArrowIcon,
                              fit: BoxFit.contain,
                            ),
                          ),
                          onPressed: () async {
                            await callCheckoutFromRestaurant(scaffoldKey, restaurant?.sId ?? '');
                          },
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
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.only(left: 15),
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
                                  FocusScope.of(context).unfocus();
                                  searchList(searchTextController.text);
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  suffixIcon: Container(
                                      child: IconButton(
                                    alignment: Alignment.centerRight,
                                    onPressed: () {},
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
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        stL = false;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(2, 30, 0, 0),
                      alignment: Alignment.centerLeft,
                      child: GlobalWidgets.setText(
                        L10n.current.table_list_title,
                        fontSize: 20,
                        strTextColor: AppColors.strMainTextColorWhite,
                      ),
                    ),
                  ),
                  Flexible(
                    child: RefreshIndicator(
                      onRefresh: _pullRefresh,
                      child: Container(
                        height: double.infinity,
                        child: ListView.separated(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          itemCount: searchTextController.text.isEmpty
                              ? tableListResult.length
                              : _searchResult.length == 0
                                  ? 0
                                  : _searchResult.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                CheckIns result = searchTextController.text.isEmpty
                                    ? tableListResult[index]
                                    : _searchResult.length == 0
                                        ? tableListResult[index]
                                        : _searchResult[index];
                                Navigator.push(
                                  context,
                                  SlideLeftRoute(
                                    page: TableUserList(
                                      userList: result.users,
                                      tableId: result.iId,
                                      restaurant: restaurant,
                                    ),
                                    routeName: "tableUserList",
                                  ),
                                );
                              },
                              child: setListItemNew(index),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<CheckIns> _searchResult = [];

  searchList(String text) {
    if (text.isEmpty) {
      setState(() {
        _searchResult.clear();
      });
    } else {
      List<CheckIns> tempSearchResult = [];
      tableListResult.forEach((tableItem) {
        tableItem.users.forEach((tableUser) {
          var firstName = tableUser.userDetail?.firstName ?? '';
          var lastName = tableUser.userDetail?.lastName ?? '';
          var countryDetails = tableUser.userDetail?.countryDetails?.name ?? '';
          if (firstName.toLowerCase().contains(text.toLowerCase()) ||
              lastName.toLowerCase().contains(text.toLowerCase()) ||
              (countryDetails.toString().toLowerCase().contains(text.toLowerCase()))) {
            tempSearchResult.add(tableItem);
          }
        });
      });
      setState(() {
        _searchResult.clear();
        _searchResult = tempSearchResult;
      });
    }
  }

  setListItemNew(int index) {
    CheckIns? result = searchTextController.text.isEmpty
        ? tableListResult[index]
        : _searchResult.length == 0
            ? tableListResult[index]
            : _searchResult[index];

    return Neumorphic(
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
      child: Container(
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 80,
                child: GlobalWidgets.setText(
                  L10n.current.table_list_table_number('\n', result.iId),
                  textAlign: TextAlign.center,
                  fontSize: 20,
                  maxLine: 2,
                  strTextColor: AppColors.strMainTextColorWhite,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      AppColors.listBoxBackgroundColor,
                      AppColors.mainTextColorWhite,
                      AppColors.listBoxBackgroundColor,
                    ],
                  ),
                ),
                width: 1,
              ),
              Flexible(
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Column(
                    children: List<Widget>.generate(result.users.length, (int index) {
                      return _createInTableUser(index, result.users[index]);
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  setListItem(int index) {
    return Container(
      child: Neumorphic(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
        padding: EdgeInsets.all(0),
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
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: EdgeInsets.only(right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 5),
                      child: GlobalWidgets.setText(
                        L10n.current.table_title,
                        fontSize: 20,
                        strTextColor: AppColors.strMainTextColorWhite,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: GlobalWidgets.setText(
                        "${index + 1}",
                        fontSize: 22,
                        strTextColor: AppColors.strMainTextColorWhite,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    AppColors.listBoxBackgroundColor,
                    AppColors.mainTextColorWhite,
                    AppColors.listBoxBackgroundColor,
                  ],
                )),
                width: 1,
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.fromLTRB(30, 0, 10, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List<Widget>.generate(someList[index], (int index) {
                      return _createChildren(index);
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _createInTableUser(int index, TableUsers user) {
    return Column(
      children: [
        index == 0
            ? SizedBox()
            : Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                decoration: BoxDecoration(
                    color: Colors.red,
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        AppColors.listBoxBackgroundColor,
                        AppColors.mainTextColorWhite,
                        AppColors.listBoxBackgroundColor,
                      ],
                    )),
                height: 1,
              ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Container(
                margin: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                      child: GlobalWidgets.setText(
                        "${user.userDetail?.firstName ?? ''} ${user.userDetail?.lastName ?? ''}",
                        fontSize: 18,
                        maxLine: 2,
                        strTextColor: AppColors.strMainTextColorWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    user.userDetail?.description != null && user.userDetail?.description != ''
                        ? Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: GlobalWidgets.setText(
                              "${user.userDetail?.description ?? ''}",
                              fontSize: 15,
                              maxLine: 2,
                              strTextColor: AppColors.fieldShadow,
                            ),
                          )
                        : SizedBox(),
                    if (user.userDetail?.countryDetails?.name != null && user.userDetail?.countryDetails?.name != '')
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: GlobalWidgets.setText(
                          "${user.userDetail?.countryDetails?.name ?? ''}",
                          fontSize: 14,
                          strTextColor: AppColors.fieldShadow,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Container(
              width: 50,
              margin: EdgeInsets.only(left: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  child: CachedNetworkImage(
                    imageUrl: user.userDetail?.image ?? '',
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: HexColor("F3F3F3"),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      );
                    },
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) {
                      return Container(
                        height: 50,
                        width: 50,
                        child: GFAvatar(
                          backgroundColor: Colors.white.withOpacity(0.5),
                          maxRadius: 20,
                          backgroundImage: AssetImage(
                            AssetsConstant.manPlaceholder,
                          ),
                          shape: GFAvatarShape.square,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<int> someList = [2, 3, 4];

  Widget _createChildren(int index) {
    return Flexible(
      fit: FlexFit.loose,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          index == 0
              ? Flexible(
                  child: Container(
                    height: 1,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  ),
                )
              : Flexible(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        AppColors.listBoxBackgroundColor,
                        AppColors.mainTextColorWhite,
                        AppColors.listBoxBackgroundColor,
                      ],
                    )),
                    height: 1,
                  ),
                ),
          Flexible(
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: GlobalWidgets.setText(
                              "LARA SMITH",
                              fontSize: 18,
                              strTextColor: AppColors.strMainTextColorWhite,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: GlobalWidgets.setText(
                              "Germany",
                              fontSize: 14,
                              strTextColor: AppColors.fieldShadow,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Container(
                      width: 50,
                      height: 50,
                      margin: EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        image: DecorationImage(
                          image: AssetImage("assets/tempImage1.png"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void firebaseNotificationListen() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        debugPrint('Message also contained a notification: ${message.notification}');
      }
      var jsonData = jsonDecode(jsonEncode(message.data));
      try {
        if (jsonData["notification_type"] == "checkout") {
          callCheckoutFromRestaurant(scaffoldKey, restaurant?.sId ?? '');
        }
      } catch (error) {
        debugPrint(error.toString());
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then((value) {
      try {
        final result = value?.data;
        if (result != null) {
          var jsonData = jsonDecode(jsonEncode(result));
          if (jsonData["notification_type"] == "checkout") {
            callCheckoutFromRestaurant(scaffoldKey, restaurant?.sId ?? '');
          }
        }
      } catch (error) {
        debugPrint(error.toString());
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        debugPrint('Message also contained a notification: ${message.notification}');
      }

      var jsonData = jsonDecode(jsonEncode(message.data));
      try {
        if (jsonData["notification_type"] == "checkout") {
          callCheckoutFromRestaurant(scaffoldKey, restaurant?.sId ?? '');
        }
      } catch (error) {
        debugPrint(error.toString());
      }
    });
  }

  Future<void> checkUserExistInTableList() async {
    await callGetTableApi(scaffoldKey, false);

    Map<String, dynamic> data = await getMapData("userdata");
    UserResult userInfo = UserResult.fromJson(data);
    var userId = userInfo.userId;

    bool isUserContain = false;
    if (tableListResult.isNotEmpty) {
      for (var i = 0; i < tableListResult.length; i++) {
        for (var j = 0; j < tableListResult[i].users.length; j++) {
          if (tableListResult[i].users[j].userDetail?.sId == userId) {
            isUserContain = true;
            break;
          }
        }
      }
    }

    if (!isUserContain) {
      callCheckoutFromRestaurant(scaffoldKey, restaurant?.sId ?? '');
    }
  }
}

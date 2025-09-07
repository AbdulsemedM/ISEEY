import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iseey/AfterLoginFlow/Table/domain/table_list_repository.dart';
import 'package:iseey/AfterLoginFlow/Table/view/table_user_list.dart';
import 'package:iseey/AfterLoginFlow/Table/view/widgets/table_app_bar.dart';
import 'package:iseey/AfterLoginFlow/Table/view/widgets/table_list_content.dart';
import 'package:iseey/AuthFlow/domain/user_model/user_model.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/GlobalFiles/GlobalMethods.dart';
import 'package:iseey/GlobalFiles/GlobalVariables.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/GlobalFiles/transitions/slide_route.dart';
import 'package:iseey/Models/TableListModel.dart';
import 'package:iseey/Services/SocketUtils.dart';
import 'package:iseey/generated/l10n.dart';

class TableList extends StatefulWidget {
  final String? restaurantId;

  const TableList({Key? key, this.restaurantId}) : super(key: key);

  @override
  _TableListState createState() => _TableListState();
}

class _TableListState extends State<TableList> with WidgetsBindingObserver {
  bool stL = true;
  String lat = '';
  String lng = '';
  late Timer timer;
  Restaurant? restaurant;
  List<CheckIns> tableListResult = [];
  List<CheckIns> _searchResult = [];
  TextEditingController searchTextController = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late TableRepository _tableRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.screensBackgroundsColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: AppColors.screensBackgroundsColor),
          SafeArea(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              padding: EdgeInsets.only(top: 15),
              child: Column(
                children: [
                  TableAppBar(
                    onBackPressed: _callCheckoutFromRestaurant,
                    searchController: searchTextController,
                    onSearchChanged: searchList,
                  ),
                  InkWell(
                    onTap: () => setState(() => stL = false),
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
                  Expanded(
                    child: TableListContent(
                      tableListResult: tableListResult,
                      searchResult: _searchResult,
                      searchTextController: searchTextController,
                      restaurant: restaurant,
                      onRefresh: _pullRefresh,
                      onItemTap: (CheckIns result) {
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // NotificationUtils().initFirebaseActions(context); // REMOVED: This was causing duplicate listeners
    WidgetsBinding.instance.addObserver(this);
    _tableRepository = TableRepository(scaffoldKey);

    _initLocation();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _callGetTableApi(true);
    });

    Future.delayed(const Duration(seconds: 4), () {
      _runTimeLock(true);
      // _connectSocket();
    });

    // _firebaseNotificationListen(); // REMOVED: This was causing duplicate listeners
    timer = Timer(const Duration(minutes: 1), () => _pullRefresh());
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
    if (state == AppLifecycleState.resumed) {
      _checkUserExistInTableList();
    }
  }

  void _initLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 50,
    );
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      lat = position.latitude.toString();
      lng = position.longitude.toString();
      if (mounted) setState(() {});
    });
  }

  bool _runTimeLock(bool state) {
    if (stL) {
      Timer.periodic(const Duration(seconds: 15), (timer) {
        _updateLocation();
      });
    }
    return true;
  }

  Future<void> _updateLocation() async {
    SocketUtils.instance.updateLatLng(lat, lng, widget.restaurantId ?? '');
  }

  // Future<void> _connectSocket() async {
  //   await GlobalWidgets.initSocket();
  //   await GlobalWidgets.socketUtils.onConnect();
  //   GlobalWidgets.socketUtils.connectToSocket();
  //   GlobalWidgets.socketUtils.setConnectListener(_onConnect);
  //   GlobalWidgets.socketUtils.setOnDisconnectListener(_onDisconnect);
  // }

  Future<void> _callGetTableApi(bool showLoader) async {
    var x = GlobalWidgets();
    try {
      if (showLoader) x.showLoading(scaffoldKey.currentContext ?? context);
      final modelData =
          await _tableRepository.getTables(widget.restaurantId ?? '');
      x.hideLoading();

      if (modelData != null && modelData.success) {
        setState(() {
          tableListResult = modelData.data?.checkIns ?? [];
          restaurant = modelData.data?.restaurant;
        });
      } else {
        showSuccessOrFail(
            modelData?.message ?? L10n.current.something_went_wrong,
            false,
            context);
      }
    } catch (e) {
      x.hideLoading();
    }
  }

  Future<bool> _callCheckoutFromRestaurant() async {
    var x = GlobalWidgets();
    try {
      x.showLoading(scaffoldKey.currentContext ?? context);
      final success =
          await _tableRepository.checkoutFromRestaurant(restaurant?.sId ?? '');
      x.hideLoading();

      if (success) {
        // Clear the selected restaurant
        selectedRestaurantId = "";

        // Show success message
        showSuccessOrFail(
            "Checkout completed successfully! Hope you enjoyed your time.",
            true,
            context);

        // Navigate back after a short delay
        Future.delayed(const Duration(milliseconds: 1500), () {
          Navigator.pop(context); // Close the current screen
        });

        return true;
      } else {
        showSuccessOrFail(L10n.current.something_went_wrong, false, context);
        return false;
      }
    } catch (e) {
      x.hideLoading();
      showSuccessOrFail(L10n.current.something_went_wrong, false, context);
      return false;
    }
  }

  Future<void> _pullRefresh() async => await _callGetTableApi(false);

  void searchList(String text) {
    if (text.isEmpty) {
      setState(() => _searchResult.clear());
    } else {
      List<CheckIns> tempSearchResult = [];
      tableListResult.forEach((tableItem) {
        tableItem.users.forEach((tableUser) {
          var firstName = tableUser.userDetail?.firstName ?? '';
          var lastName = tableUser.userDetail?.lastName ?? '';
          var countryDetails = tableUser.userDetail?.countryDetails?.name ?? '';
          if (firstName.toLowerCase().contains(text.toLowerCase()) ||
              lastName.toLowerCase().contains(text.toLowerCase()) ||
              (countryDetails
                  .toString()
                  .toLowerCase()
                  .contains(text.toLowerCase()))) {
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

  Future<void> _checkUserExistInTableList() async {
    await _callGetTableApi(false);
    Map<String, dynamic> data = await getMapData("userdata");
    UserResult userInfo = UserResult.fromJson(data);
    var userId = userInfo.userId;

    bool isUserContain = tableListResult.any(
        (table) => table.users.any((user) => user.userDetail?.sId == userId));

    if (!isUserContain) await _callCheckoutFromRestaurant();
  }
}

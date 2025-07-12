
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:iseey/AfterLoginFlow/RestaurantList/controller/restaurant_list_controller.dart';
import 'package:iseey/AfterLoginFlow/RestaurantList/domain/restaurant_list_repository.dart';
import 'package:iseey/AfterLoginFlow/RestaurantList/view/widgets/RestaurantListItem.dart';
import 'package:iseey/AfterLoginFlow/RestaurantList/view/widgets/SearchBar.dart';
import 'package:iseey/AfterLoginFlow/RestaurantList/view/widgets/TableNumberPopup.dart';
import 'package:iseey/AfterLoginFlow/Table/view/table_list.dart';
import 'package:iseey/AuthFlow/domain/user_model/user_model.dart';
import 'package:iseey/GlobalFiles/GlobalMethods.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:provider/provider.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/GlobalFiles/GlobalVariables.dart';
import 'package:iseey/Models/restaurant_list_result.dart';
import 'package:iseey/Services/StateManagement.dart';
import 'package:iseey/GlobalFiles/transitions/slide_route.dart';
import 'package:iseey/Services/assets_constant.dart';
import 'package:iseey/generated/l10n.dart';

class RestaurantList extends StatefulWidget {
  @override
  _RestaurantListState createState() => _RestaurantListState();
}

class _RestaurantListState extends State<RestaurantList> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController tableNumberController = TextEditingController();
  final RestaurantListRepository _repository = RestaurantListRepository();
  List<RestaurantListResult> restaurants = [];
  List<RestaurantListResult> filteredRestaurants = [];
  OverlayEntry? overlayEntry;
  bool isAgree = false;
  bool isNewLetterSelected = false;
  String restaurantId = "";
  UserResult? userInfo;
  @override
  void initState() {
    super.initState();
    _getUserDetail();
    // _loadRestaurants();
    // _onConnect();
  }

  // Future<void> _loadRestaurants() async {
  //   final results = await _repository.getRestaurants(context, scaffoldKey);
  //   // log("Restaurant List: ${results} restaurants loaded");
  //   setState(() {
  //     restaurants = results;
  //     filteredRestaurants = results;
  //   });
  // }

  // void _searchRestaurants(String query) {
  //   setState(() {
  //     filteredRestaurants = restaurants.where((restaurant) {
  //       return restaurant.name.toLowerCase().contains(query.toLowerCase()) ||
  //           restaurant.address.toLowerCase().contains(query.toLowerCase());
  //     }).toList();
  //   });
  // }

  // _onConnect() async {
  //   // await GlobalWidgets.initSocket();
  //   // await GlobalWidgets.socketUtils.initSocket(null, '');
  //   // GlobalWidgets.socketUtils.connectToSocket();
  //   // SocketUtils.instance.setOnCheckedInListener(onCheckedInReceived);
  // }


  Future<void> _getUserDetail() async {
    Map<String, dynamic> data = await getMapData("userdata");
    setState(() {
      userInfo = UserResult.fromJson(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(
              color: AppColors.tabBarBoxBackgroundColor,
            ),
            SafeArea(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row with Drawer Button and Avatar
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            child: NeumorphicButton(
                              padding: EdgeInsets.zero,
                              child: Center(
                                child: Image.asset(
                                  AssetsConstant.bars,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              onPressed: () => mainTabsScaffoldKey.currentState
                                  ?.openDrawer(),
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.concave,
                                depth: 1,
                                lightSource: LightSource.top,
                                color: AppColors.mainTextColorBlack
                                    .withOpacity(0.7),
                                border: NeumorphicBorder(
                                  color: AppColors.innerShadowColor,
                                  width: 2,
                                ),
                                shadowDarkColor:
                                    AppColors.mainBackgroundColorOrange,
                                shadowLightColorEmboss: Colors.transparent,
                                shadowDarkColorEmboss:
                                    AppColors.innerShadowColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          GlobalWidgets.setText(
                            " Hey ,${userInfo?.firstName ?? ''}  👋🏼",
                            strTextColor: AppColors.strMainTextColorWhite,
                            fontSize: 22,
                          ),
                          Spacer(),
                          userInfo?.image != null
                              ? Container(
                                  width: 37,
                                  height: 37,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: CachedNetworkImage(
                                      imageUrl: userInfo!.image,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          color: HexColor("F3F3F3"),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        color: Colors.white.withOpacity(
                                            0.5), // Same as FriendAvatar
                                        child: Image.asset(
                                          AssetsConstant.manPlaceholder,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 40,
                                  height: 40,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      AssetsConstant.manPlaceholder,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),

                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Searchbar(
                        controller: searchController,
                        onSearch: context
                            .read<RestaurantListController>()
                            .searchRestaurants,
                      ),
                    ),

                    // Restaurant List Title
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: GlobalWidgets.setText(
                        L10n.current.restaurant_list_title,
                        fontSize: 20,
                        strTextColor: AppColors.strMainTextColorWhite,
                      ),
                    ),

                    // Restaurant List
                    Expanded(
                      child: RefreshIndicator(
                        backgroundColor: AppColors.fieldsBackgroundColor,
                        onRefresh: () async {
                         await context
                              .read<RestaurantListController>()
                              .loadRestaurantList(
                                context: context,
                                scaffoldKey: scaffoldKey,
                              );
                        },
                        child: Consumer<RestaurantListController>(
                          builder: (context, controller, child) {
                            return Container(
                              margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                              alignment: controller.restaurants.isEmpty
                                  ? Alignment.center
                                  : Alignment.topCenter,
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: controller.restaurants.isEmpty
                                    ? Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.7,
                                        child: Center(
                                          child: Text(
                                            L10n.current
                                                .restaurant_list_empty_state_text,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      )
                                    : GridView.builder(
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 6.0,
                                          mainAxisSpacing: 3.0,
                                        ),
                                        padding: EdgeInsets.zero,
                                        itemCount: searchController.text.isEmpty
                                            ? controller.restaurants.length
                                            : controller
                                                    .filteredRestaurants.isEmpty
                                                ? 0
                                                : controller
                                                    .filteredRestaurants.length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final restaurant = searchController
                                                  .text.isEmpty
                                              ? controller.restaurants[index]
                                              : controller.filteredRestaurants
                                                      .isEmpty
                                                  ? controller
                                                      .restaurants[index]
                                                  : controller
                                                          .filteredRestaurants[
                                                      index];
                                          return RestaurantListItem(
                                            restaurant: restaurant,
                                            onTap: () {
                                              _handleRestaurantTap(restaurant);
                                            },
                                          );
                                        },
                                      ),
                              ),
                            );
                          },
                        ),
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

  // ... (rest of the methods remain unchanged)
  void _handleRestaurantTap(RestaurantListResult restaurant) {
    FocusScope.of(context).unfocus();
    restaurantId = restaurant.sId;
    Provider.of<StateManagement>(context, listen: false)
        .setSelectedRestaurant(restaurant);
    isNewLetterSelected = restaurant.newsletter;
    isAgree = false;
    _checkIfUserCheckInTable();
  }

  void _checkIfUserCheckInTable() async {
    final currentUserId =
        Provider.of<StateManagement>(context, listen: false).currentUserId;
    if (currentUserId == null || restaurantId.isEmpty) {
      showSuccessOrFail('User not logged in', false, context);
      return;
    }

    try {
      final response = await _repository.checkIfUserCheckInTable(
        context,
        scaffoldKey,
        restaurantId,
        currentUserId,
      );

      if (response['success'] == true) {
        final data = response['data'];
        final checkIns = data['checkIns'] as List;
        final restaurant = data['restaurant'] as Map<String, dynamic>;

        bool exists = checkIns.any((checkIn) => (checkIn['users'] as List)
            .any((user) => user['userDetail']['_id'] == currentUserId));

        isNewLetterSelected = restaurant['newsletter'] ?? false;

        if (exists) {
          _navigateToTableList(restaurantId);
        } else {
          _showTablePopup();
        }
      } else {
        showSuccessOrFail(
            response['message'] ?? 'Check-in failed', false, context);
      }
    } catch (e) {
      showSuccessOrFail('Network error', false, context);
    }
  }

  void _showTablePopup() {
    OverlayState? overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
      builder: (context) => TableNumberPopup(
        showNewsLetter: isNewLetterSelected,
        onConfirm: () {
          overlayEntry?.remove();
          _checkIntoTable();
        },
        onCancel: () {
          overlayEntry?.remove();
        },
        tableNumberController: tableNumberController,
        initialAgreeValue: isAgree,
      ),
    );
    overlayState.insert(overlayEntry!);
  }

  void _checkIntoTable() async {
    if (tableNumberController.text.isEmpty) {
      showSuccessOrFail('Please enter table number', false, context);
      return;
    }

    try {
      final response = await _repository.checkIntoTable(
        context,
        scaffoldKey,
        restaurantId,
        tableNumberController.text,
        isAgree,
      );

      if (response['success'] == true) {
        _navigateToTableList(restaurantId);
      } else {
        showSuccessOrFail(
            response['message'] ?? 'Check-in failed', false, context);
      }
    } catch (e) {
      showSuccessOrFail('Network error', false, context);
    }
  }

  void _navigateToTableList(String restaurantId) {
    selectedRestaurantId = restaurantId;
    Navigator.push(
      context,
      SlideLeftRoute(
        routeName: "/tableList",
        page: TableList(restaurantId: restaurantId),
      ),
    ).then((_) {
      setState(() {
        restaurantId = "";
        tableNumberController.clear();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    tableNumberController.dispose();
    overlayEntry?.remove();
    super.dispose();
  }
}

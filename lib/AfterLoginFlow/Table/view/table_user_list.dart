import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:iseey/AfterLoginFlow/Table/domain/table_user_repository.dart';
import 'package:iseey/AfterLoginFlow/Table/view/widgets/table_user_list_item.dart';
import 'package:iseey/AfterLoginFlow/chat/view/chat_screen.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/GlobalFiles/GlobalMethods.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/GlobalFiles/transitions/slide_route.dart';
import 'package:iseey/Models/TableListModel.dart';
import 'package:iseey/AuthFlow/domain/user_model/user_model.dart';
import 'package:iseey/Services/assets_constant.dart';
import 'package:iseey/generated/l10n.dart';

class TableUserList extends StatefulWidget {
  final List<TableUsers> userList;
  final Restaurant? restaurant;
  final int tableId;

  const TableUserList({
    Key? key,
    required this.userList,
    required this.tableId,
    required this.restaurant,
  }) : super(key: key);

  @override
  _TableUserListState createState() => _TableUserListState();
}

class _TableUserListState extends State<TableUserList> {
  String? chatId = "";
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late TableUserRepository _tableUserRepository;

  @override
  void initState() {
    super.initState();
    _tableUserRepository = TableUserRepository(scaffoldKey);
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
                      onPressed: () {
                        Navigator.pop(context);
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
                      margin: EdgeInsets.only(right: 45),
                      height: 45,
                      width: double.infinity,
                      child: GlobalWidgets.setText(
                        L10n.current.table_list_table_number(' ', widget.tableId),
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        strTextColor: AppColors.strMainTextColorWhite,
                      ),
                    ),
                  ),
                ],
              ),
              Flexible(
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
                  itemCount: widget.userList.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () async {
                        debugPrint("User card tapped");
                        
                        FocusScope.of(context).unfocus();
                        Map<String, dynamic> data = await getMapData("userdata");
                        UserResult userInfo = UserResult.fromJson(data);
                        TableUsers user = widget.userList[index];
                        if (userInfo.userId == user.userDetail?.sId.toString()) {
                          showSuccessOrFail(
                            L10n.current.table_user_list_chat_with_yourself_error_message,
                            false,
                            context,
                          );
                          return;
                        }
                        
                        try {
                          final response = await _tableUserRepository.createOrGetChat(
                              user.userDetail?.sId ?? '', widget.restaurant?.sId ?? '');
                          
                          if (response['success']) {
                            setState(() {
                              chatId = response['chatId'];
                            });
                            debugPrint("Navigating to ChatScreen");
                            Navigator.push(
                              context,
                              SlideLeftRoute(
                                routeName: "/chat",
                                page: ChatScreen(
                                  fromUser: userInfo,
                                  toUser: user.userDetail!,
                                  chatId: chatId ?? '',
                                  restaurant: widget.restaurant,
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          debugPrint("Failed to create or get chat: $e");
                          showSuccessOrFail(e.toString(), false, context);
                        }
                      },
                      child: TableUserListItem(user: widget.userList[index]),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
import 'dart:convert';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:iseey/AfterLoginFlow/user_block/domain/BlockedUser_Models/BlockedUserListModel.dart';
import 'package:iseey/AfterLoginFlow/user_block/domain/BlockedUser_Models/BlockedUserResultExtension.dart';
import 'package:iseey/Services/ApiService.dart';
import 'package:iseey/Services/StateManagement.dart';
import 'package:iseey/generated/l10n.dart';
import 'package:provider/provider.dart';

class BlockedUserRepository {
  final GlobalKey<ScaffoldState> scaffoldKey;

  BlockedUserRepository(this.scaffoldKey);

  Future<List<BlockedUserResult>> getBlockedUserList() async {
    final req = HttpRequestModel(
      url: 'users/listblockedUser',
      method: RequestMethodType.GET,
      body: '',
      params: '',
      headerType: "json",
      authMethod: true,
    );

    try {
      final response = await HttpService().init(req, scaffoldKey);
      
      if (response is String && response.isNotEmpty) {
        final jsonRes = jsonDecode(response);
        
        if (jsonRes['success'] == true) {
          final modelData = BlockedUserListModel.fromJson(jsonRes);
          return modelData.data.users
              .map((user) => BlockedUserResultExtension.fromBlockedUser(user))
              .toList();
        } else {
          throw Exception(jsonRes['message'] ?? L10n.current.something_went_wrong);
        }
      } else {
        throw Exception(L10n.current.something_went_wrong);
      }
    } catch (e) {
      debugPrint("EXCEPTION $e");
      rethrow;
    }
  }

  Future<bool> unblockUser(String userId, BuildContext context) async {
    final data = {'user_id': userId};
    final req = HttpRequestModel(
      url: 'users/unblock',
      method: RequestMethodType.PUT,
      body: json.encode(data),
      params: '',
      headerType: "json",
      authMethod: true,
    );

    try {
      final response = await HttpService().init(req, scaffoldKey);

      if (response is String && response.isNotEmpty) {
        final jsonRes = jsonDecode(response);
        
        if (jsonRes['success'] == true) {
          Provider.of<StateManagement>(context, listen: false).reloadBuild();
          return true;
        } else {
          throw Exception(jsonRes['message']);
        }
      } else {
        throw Exception(L10n.current.something_went_wrong);
      }
    } catch (e) {
      debugPrint("EXCEPTION $e");
      rethrow;
    }
  }
}
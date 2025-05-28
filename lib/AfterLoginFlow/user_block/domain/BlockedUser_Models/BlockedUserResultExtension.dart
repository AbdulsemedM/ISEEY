import 'package:iseey/AfterLoginFlow/user_block/domain/BlockedUser_Models/BlockedUserListModel.dart';

extension BlockedUserResultExtension on BlockedUserResult {
  static BlockedUserResult fromBlockedUser(BlockedUser user) {
    return BlockedUserResult(
      sId: user.id,
      userId: user.userId,
      blocked: user.blocked,
      created: 0,
      updated: 0,
      userDetail: BlockedUserDetail(
        sId: user.userDetail.id,
        lastName: user.userDetail.lastName,
        email: user.userDetail.email,
        image: user.userDetail.image,
        gender: user.userDetail.gender,
        dob: user.userDetail.dob,
        city: '',
        state: '',
        country: user.userDetail.countryName,
        firstName: user.userDetail.firstName,
        description: user.userDetail.description,
      ),
      isBlockedYou: user.isBlockedYou,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iseey/AfterLoginFlow/Edit_profile/domain/Edit_profile_repository.dart';
import 'package:iseey/AuthFlow/view/widgets/custom_text_field.dart';
import 'package:iseey/GlobalFiles/GlobalMethods.dart';
import 'package:iseey/Services/assets_constant.dart';
import 'package:iseey/generated/l10n.dart';
import 'package:iseey/AfterLoginFlow/Edit_profile/view/widgets/save_button.dart';

class AccountInformation extends StatelessWidget {
  final TextEditingController oldPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final EditProfileRepository profileRepository;

  const AccountInformation({
    Key? key,
    required this.oldPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.scaffoldKey,
    required this.profileRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomTextField(
              controller: oldPasswordController,
              hintText: "",
              labelText: L10n.current.edit_profile_old_password_text_field,
              prefixIcon: AssetsConstant.pwdIcon,
              obscureText: true,
            ),
            CustomTextField(
              controller: newPasswordController,
              hintText: "",
              labelText: L10n.current.edit_profile_new_password_text_field,
              prefixIcon: AssetsConstant.pwdIcon,
              obscureText: true,
            ),
            CustomTextField(
              controller: confirmPasswordController,
              hintText: "",
              labelText: L10n.current.edit_profile_confirm_password_text_field,
              prefixIcon: AssetsConstant.pwdIcon,
              obscureText: true,
            ),
            SaveButton(
              onPressed: () async {
                if (newPasswordController.text != confirmPasswordController.text) {
                  Fluttertoast.showToast(msg: "Passwords do not match");
                  return;
                }

                try {
                  await profileRepository.changePassword(
                    oldPassword: oldPasswordController.text,
                    newPassword: newPasswordController.text,
                    scaffoldKey: scaffoldKey,
                  );
                  Navigator.pop(context);
                  showSuccessOrFail(
                    "Password changed successfully",
                    true,
                    context,
                    isCustom: true,
                    isTitleEnable: false,
                    onCustomOkPress: () {},
                  );
                } catch (e) {
                  Fluttertoast.showToast(msg: "Error: $e");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

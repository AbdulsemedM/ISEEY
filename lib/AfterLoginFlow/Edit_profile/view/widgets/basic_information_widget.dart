// basic_information_widget.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iseey/AfterLoginFlow/Edit_profile/domain/Edit_profile_repository.dart';
import 'package:iseey/AfterLoginFlow/Edit_profile/view/widgets/date_picker.dart';
import 'package:iseey/AfterLoginFlow/Edit_profile/view/widgets/delete_account_button.dart';
import 'package:iseey/AfterLoginFlow/Edit_profile/view/widgets/gender_picker.dart';
import 'package:iseey/AfterLoginFlow/Edit_profile/view/widgets/profile_image_picker.dart';
import 'package:iseey/AfterLoginFlow/Edit_profile/view/widgets/save_button.dart';
import 'package:iseey/AuthFlow/view/widgets/custom_text_field.dart';
import 'package:iseey/Services/assets_constant.dart';
import 'package:iseey/generated/l10n.dart';

class BasicInformationWidget extends StatelessWidget {
  final EditProfileRepository profileRepository;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController genderController;
  final TextEditingController dobController;
  final TextEditingController descriptionController;
  final TextEditingController fbController;
  final TextEditingController instaController;
  final String selectedGender;
  final DateTime selectedDob;
  final Position? currentPosition;
  final Function() onSavePressed;
  final Function() onDeleteAccountPressed;
  final Function() onImagePickerPressed;
  final Function(String) onGenderChanged;
  final Function(DateTime) onDateSelected;
  final String fileImage;
  final File? selectedImage;

  const BasicInformationWidget({
    Key? key,
    required this.profileRepository,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.genderController,
    required this.dobController,
    required this.descriptionController,
    required this.fbController,
    required this.instaController,
    required this.selectedGender,
    required this.selectedDob,
    required this.currentPosition,
    required this.onSavePressed,
    required this.onDeleteAccountPressed,
    required this.onImagePickerPressed,
    required this.onGenderChanged,
    required this.onDateSelected,
    required this.fileImage,
    required this.selectedImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            fileImagePicker(
              fileImage: fileImage,
              selectedImage: selectedImage,
              onTap: onImagePickerPressed,
            ),
            CustomTextField(
              controller: firstNameController,
              hintText: L10n.current.edit_profile_example_first_name,
              labelText: L10n.current.sign_up_first_name_text_field_title,
              prefixIcon: AssetsConstant.userIcon,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return "First name required";
                }
                return null;
              },
            ),
            CustomTextField(
              controller: lastNameController,
              hintText: L10n.current.edit_profile_example_last_name,
              labelText: L10n.current.sign_up_last_name_text_field_title,
              prefixIcon: AssetsConstant.userIcon,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return "Last name required";
                }
                return null;
              },
            ),
            CustomTextField(
              controller: emailController,
              hintText: L10n.current.edit_profile_example_email,
              labelText: L10n.current.sign_up_email_text_field_title,
              prefixIcon: AssetsConstant.userIcon,
              validator: (value) {
                if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value ?? '')) {
                  return 'Email not valid';
                }
                if (value?.isEmpty ?? true) {
                  return "Email required";
                }
                return null;
              },
            ),
            GenderPicker(
              selectedGender: selectedGender,
              onChanged: onGenderChanged,
            ),
            DatePicker(
              selectedDate: dobController.text,
              onDateSelected: onDateSelected,
            ),
            CustomTextField(
              controller: descriptionController,
              hintText: L10n.current.edit_profile_description_text_field,
              labelText: L10n.current.edit_profile_description_text_field,
              prefixIcon: AssetsConstant.userIcon,
            ),
            CustomTextField(
              controller: fbController,
              hintText: L10n.current.edit_profile_facebook_text_field,
              labelText: L10n.current.edit_profile_facebook_text_field,
              prefixIcon: AssetsConstant.facebook,
            ),
            CustomTextField(
              controller: instaController,
              hintText: L10n.current.edit_profile_instagram_text_field,
              labelText: L10n.current.edit_profile_instagram_text_field,
              prefixIcon: AssetsConstant.instagram,
            ),
            SaveButton(
              onPressed: onSavePressed,
            ),
            DeleteAccountButton(
              onPressed: onDeleteAccountPressed,
            ),
            Container(height: 50),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:iseey/AuthFlow/view/widgets/custom_text_field.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/Services/assets_constant.dart';
import 'package:iseey/generated/l10n.dart';

class GenderPicker extends StatelessWidget {
  final String selectedGender;
  final Function(String) onChanged;

  const GenderPicker({
    super.key,
    required this.selectedGender,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: TextEditingController(text: selectedGender),
      hintText: "",
      labelText: L10n.current.edit_profile_gender_text_field_text,
      prefixIcon: AssetsConstant.userIcon,
      onTap: () async {
        await showMaterialScrollPicker(
          context: context,
          title: L10n.current.edit_profile_gender_selection_title,
          showDivider: false,
          items: [
            L10n.current.gender_male,
            L10n.current.gender_female,
            L10n.current.gender_others,
          ],
          headerColor: AppColors.mainBackgroundColorOrange,
          buttonTextColor: AppColors.mainBackgroundColorOrange,
          onChanged: (value) => onChanged(value),
          onCancelled: () => debugPrint("Scroll Picker cancelled"),
          onConfirmed: () => debugPrint("Scroll Picker confirmed"),
          cancelText: L10n.current.cancel_button_title,
          selectedItem: selectedGender,
        );
      },
    );
  }
}
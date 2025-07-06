import 'package:flutter/material.dart';
import 'package:iseey/AuthFlow/view/widgets/custom_text_field.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/Services/assets_constant.dart';
import 'package:iseey/generated/l10n.dart';

class DatePicker extends StatelessWidget {
  final String selectedDate;
  final Function(DateTime) onDateSelected;

  const DatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: TextEditingController(text: selectedDate),
      hintText: "",
      labelText: L10n.current.edit_profile_birthday_text_field_title,
      prefixIcon: AssetsConstant.calendar,
      onTap: () {
        FocusScope.of(context).unfocus();
        showDatePicker(
          builder: (context, child) {
            return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: ColorScheme.light(primary: AppColors.mainBackgroundColorOrange),
              ),
              child: child ?? Container(),
            );
          },
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        ).then((value) {
          if (value != null) {
            onDateSelected(value);
          }
        });
      },
    );
  }
}
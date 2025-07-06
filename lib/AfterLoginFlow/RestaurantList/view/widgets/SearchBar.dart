import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/generated/l10n.dart';

class Searchbar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSearch; 
  const Searchbar({
    super.key,
    required this.controller,
    required this.onSearch, 
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: Neumorphic(
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
          padding: const EdgeInsets.fromLTRB(10, 0, 5, 1),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: AppColors.mainTextColorWhite,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  keyboardAppearance: Brightness.dark,
                  style: TextStyle(
                    color: AppColors.mainTextColorWhite,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                  controller: controller,
                  onChanged: onSearch,
                  onEditingComplete: () {
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    onSearch(controller.text);
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
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
            ],
          ),
        ),
      ),
    );
  }
}
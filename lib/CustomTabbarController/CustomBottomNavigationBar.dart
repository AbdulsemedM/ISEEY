import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/Services/menu.dart';
import 'package:iseey/Services/rive_utils.dart';
import 'package:rive/rive.dart';

class CustomBottomNavyBar extends StatelessWidget {
  final int selectedIndex;
  final List<Menu> items;
  final ValueChanged<int> onItemSelected;

  const CustomBottomNavyBar({
    Key? key,
    required this.selectedIndex,
    required this.items,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, 0),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
          decoration: BoxDecoration(
            color: AppColors.listBoxBackgroundColor.withOpacity(0.8),
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: AppColors.innerShadowColor.withOpacity(0.2),
                offset: const Offset(0, -10),
                blurRadius: 20,
                spreadRadius: -5,
              ),
              BoxShadow(
                color: AppColors.innerShadowColor.withOpacity(0.3),
                offset: const Offset(0, 20),
                blurRadius: 20,
                spreadRadius: -5,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              items.length,
              (index) {
                final item = items[index];
                final isFoodIcon = item.title == "food";
                final iconSize = isFoodIcon ? 50.0 : 36.0;
                
                return GestureDetector(
                  onTap: () {
                    if (item.rive.status != null) {
                      RiveUtils.chnageSMIBoolState(item.rive.status!);
                    }
                    onItemSelected(index);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: 60,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedBar(isActive: selectedIndex == index),
                        SizedBox(height: isFoodIcon ? 0 : 8),
                        SizedBox(
                          height: iconSize,
                          width: iconSize,
                          child: Opacity(
                            opacity: selectedIndex == index ? 1 : 0.5,
                            child: isFoodIcon 
                                ? ColorFiltered(
                                    colorFilter: const ColorFilter.mode(
                                      Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                    child: RiveAnimation.asset(
                                      item.rive.src,
                                      artboard: item.rive.artboard,
                                      onInit: (artboard) {
                                        item.rive.status = RiveUtils.getRiveInput(
                                          artboard,
                                          stateMachineName: item.rive.stateMachineName,
                                        );
                                        if (selectedIndex == index) {
                                          item.rive.status?.value = true;
                                        }
                                      },
                                    ),
                                  )
                                : RiveAnimation.asset(
                                    item.rive.src,
                                    artboard: item.rive.artboard,
                                    onInit: (artboard) {
                                      item.rive.status = RiveUtils.getRiveInput(
                                        artboard,
                                        stateMachineName: item.rive.stateMachineName,
                                      );
                                      if (selectedIndex == index) {
                                        item.rive.status?.value = true;
                                      }
                                    },
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedBar extends StatelessWidget {
  final bool isActive;

  const AnimatedBar({
    Key? key,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 2),
      height: 4,
      width: isActive ? 20 : 0,
      decoration: BoxDecoration(
        color: AppColors.mainBackgroundColorOrange,
        borderRadius: const BorderRadius.all(Radius.circular(2)),
      ),
    );
  }
}
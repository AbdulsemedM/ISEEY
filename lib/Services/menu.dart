import 'package:rive/rive.dart';

class Menu {
  final String title;
  final RiveModel rive;

  Menu({required this.title, required this.rive});
}

List<Menu> bottomNavItems = [
  Menu(
    title: "food",
    rive: RiveModel(
      src: "assets/RiveAssets/food.riv",
      artboard: "food",
      stateMachineName: "food_interactivity",
    ),
  ),
  Menu(
    title: "Home",
    rive: RiveModel(
      src: "assets/RiveAssets/icons.riv",
      artboard: "HOME",
      stateMachineName: "HOME_interactivity",
    ),
  ),
  Menu(
    title: "Chat",
    rive: RiveModel(
      src: "assets/RiveAssets/icons.riv",
      artboard: "CHAT",
      stateMachineName: "CHAT_Interactivity",
    ),
  ),
];

class RiveModel {
  final String src, artboard, stateMachineName;
  late SMIBool? status;

  RiveModel({
    required this.src,
    required this.artboard,
    required this.stateMachineName,
    this.status,
  });

  set setStatus(SMIBool state) {
    status = state;
  }
}
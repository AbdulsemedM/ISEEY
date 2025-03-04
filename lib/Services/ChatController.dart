import 'package:get/get.dart';

class ChatListController extends GetxController {
  RxList chatData = [].obs;
  var loc = {}.obs;

  @override
  void onInit() => super.onInit();

  addMsgToList(Map message) => chatData.add(message);

  clearChat() => chatData.clear();
}

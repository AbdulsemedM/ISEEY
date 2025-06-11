import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:iseey/Models/restaurant_list_result.dart';
import 'package:iseey/Services/local_storage_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class StateManagement extends ChangeNotifier {
  RestaurantListResult? selectedRestaurant;
  String? _currentUserId;
  bool? isReload = false;
  bool? isRestaurantReload = false;
  String? strPdfPath = "";
  IO.Socket? _socket;
  bool _isSocketConnected = false;
  String? _currentChatId;
  List<String> _joinedRooms = [];

  String? get currentUserId => _currentUserId;
  IO.Socket? get socket => _socket;
  bool get isSocketConnected => _isSocketConnected;
  String? get currentChatId => _currentChatId;
  List<String> get joinedRooms => _joinedRooms;
  Future<void> initSocket({required String token}) async {
    try {
      _socket = IO.io(
        'ws://iseey.app:5002',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .setQuery({'token': token})
            .build(),
      );

      _socket?.onConnect((_) {
        _isSocketConnected = true;
        debugPrint('Socket connected');
        notifyListeners();
      });

      _socket?.onDisconnect((_) {
        _isSocketConnected = false;
        debugPrint('Socket disconnected');
        notifyListeners();
        _attemptReconnect();
      });

      _socket?.onError((error) {
        debugPrint('Socket error: $error');
        notifyListeners();
      });

      _socket?.connect();
    } catch (e) {
      debugPrint('Socket initialization error: $e');
    }
  }

  LocalStorageService localStorageService = LocalStorageService.instance;

  void _attemptReconnect() {
    Future.delayed(const Duration(seconds: 5), () {
      if (_socket != null && !_isSocketConnected) {
        debugPrint('Attempting to reconnect socket...');
        _socket?.connect();
      }
    });
  }

  void joinChatRoom(String chatId) {
    if (_socket != null && _isSocketConnected) {
      _socket?.emit('joinRoom', {'room_id': chatId});
      _currentChatId = chatId;
      if (!_joinedRooms.contains(chatId)) {
        _joinedRooms.add(chatId);
      }
      notifyListeners();
    }
  }

  void leaveChatRoom(String chatId) {
    if (_socket != null && _isSocketConnected) {
      _socket?.emit('leaveRoom', {'room_id': chatId});
      _joinedRooms.remove(chatId);
      if (_currentChatId == chatId) {
        _currentChatId = null;
      }
      notifyListeners();
    }
  }

  void sendMessage({required String message, required String receiverId}) {
    if (_socket != null &&
        _isSocketConnected &&
        _currentChatId != null &&
        message.isNotEmpty) {
      _socket?.emit('sendMessage', {
        'message': message,
        'chat_id': _currentChatId,
        'receiver_id': receiverId,
      });
    }
  }

  void disposeSocket() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _isSocketConnected = false;
    _currentChatId = null;
    _joinedRooms.clear();
    notifyListeners();
  }

  String? getStrPdfPath() => strPdfPath;
  RestaurantListResult? getSelectedRestaurant() => selectedRestaurant;

  Future<void> setSelectedRestaurant(RestaurantListResult restaurant) async {
    selectedRestaurant = restaurant;
    var restaurantMenu = selectedRestaurant?.menu ?? '';
    if (restaurantMenu.contains('.pdf')) {
      await _openPdf(restaurantMenu);
    }
    notifyListeners();
  }

  Future<void> setCurrentUserId(String userId) async {
    _currentUserId = userId;
    await localStorageService.saveString('currentUserId', userId);
    notifyListeners();
  }

  Future<void> loadCurrentUserId() async {
    if (_currentUserId == null) {
      _currentUserId = await localStorageService.getString('currentUserId');
      notifyListeners();
    }
  }

  Future<void> clearCurrentUserId() async {
    _currentUserId = null;
    await localStorageService.remove('currentUserId');
    notifyListeners();
  }

  void reloadRestaurantBuild() {
    isRestaurantReload = true;
    notifyListeners();
  }

  void reloadBuild() {
    isReload = true;
    notifyListeners();
  }

  Future<bool> _openPdf(String url) async {
    final file = await DefaultCacheManager().getSingleFile(url);
    strPdfPath = file.path;
    return true;
  }
}

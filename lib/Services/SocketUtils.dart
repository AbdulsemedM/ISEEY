import 'dart:convert';

import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:iseey/Models/ChatMessageModel.dart';
import 'package:iseey/Models/TableListModel.dart';
import 'package:iseey/AuthFlow/domain/user_model/user_model.dart';
import 'package:iseey/Services/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

const String socketUrlString = 'ws://iseey.app:5003';

class SocketUtils {
  SocketUtils._privateConstructor();
  static final SocketUtils _instance = SocketUtils._privateConstructor();

  static SocketUtils get instance => _instance;

  // Events
  static const String JOIN_ROOM = 'joinRoom';
  static const String LEAVE_ROOM = 'leaveRoom';
  static const String SEND_MESSAGE = 'sendMessage';
  static const String UPDATE_ALL_MESSAGE_TO_SEEN = 'updateAllMessagesToSeen';
  static const String NEW_CHECK_IN_CREATED = "NEW_CHECK_IN_CREATED";
  static const String NEW_CHECK_OUT_CREATED = "NEW_CHECK_OUT_CREATED";

  static const String ON_MESSAGE_RECEIVED = 'recieveMessage';
  static const String ON_JOINED_ROOM = 'joinedRoom';
  static const String ON_GET_CHATS = 'getChats';
  static const String ON_LEAVE_CHAT_ROOM = 'leaveChatRoom';
  static const String ON_ERROR = 'error';

  // Status
  static const int STATUS_MESSAGE_NOT_SENT = 10001;
  static const int STATUS_MESSAGE_SENT = 10002;
  static const int STATUS_MESSAGE_DELIVERED = 10003;
  static const int STATUS_MESSAGE_READ = 10004;

  // Type of Chat
  static const String SINGLE_CHAT = 'single_chat';

  String _chatID = "";
  late IO.Socket socket;

  void initChatSocket(UserResult? fromUser, String chatId) async {
    this._chatID = chatId;
    debugPrint("🟢 socket init: $fromUser");
  }

  Future<void> connectSocket() async {
    try {
      final token = await _getToken();

      socket = IO.io(
        socketUrlString,
        OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .setPath('/socket.io')
            .setQuery({'token': token})
            .build(),
      );

      _setupSocketListeners();
      socket.connect();
    } catch (error) {
      debugPrint("🔴 Socket connection error: ${error.toString()}");
    }
  }

  Future<String> _getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("token") ?? "";
  }

  void _setupSocketListeners() {
    socket.onConnect((_) {
      debugPrint("🟢 Socket connected with ID: ${socket.id}");
      if (_chatID.isNotEmpty) {
        socket.emit(JOIN_ROOM, {"room_id": _chatID});
      }
    });

    socket.onConnectError((error) {
      debugPrint("🔴 Socket connect error: $error");
      _attemptReconnect();
    });

    socket.onDisconnect((reason) {
      debugPrint("🔴 Socket disconnected: $reason");
      _attemptReconnect();
    });

    socket.onError((error) => debugPrint("🔴 Socket error: $error"));
  }

  void _attemptReconnect() {
    debugPrint("🟡 Attempting to reconnect in 5 seconds...");
    Future.delayed(Duration(seconds: 5), () {
      if (!socket.connected) {
        socket.connect();
      }
    });
  }

  void connectToSocket() {
    if (!socket.connected) {
      debugPrint("🟡 Manually connecting to socket...");
      socket.connect();
    }
  }

  void sendJoinRoom(
      {bool? isChatId = false, UserResult? toChatUser, String? chatId}) {
    if (socket.connected) {
      final roomId = isChatId ?? false ? chatId : toChatUser?.userId;
      if (roomId != null) {
        socket.emit(JOIN_ROOM, {"room_id": roomId});
        debugPrint("🟢 socket emit JOIN_ROOM: $roomId");
      } else {
        debugPrint("🔴 Room ID is null. Cannot emit JOIN_ROOM.");
      }
    } else {
      debugPrint("🔴 Socket is not connected. Cannot emit JOIN_ROOM.");
      socket.connect();
    }
  }

  Future<bool> sendDeleteChat(String chatID) async {
    try {
      HttpRequestModel req = HttpRequestModel(
        url: 'socket/deleteChat/$chatID',
        method: RequestMethodType.DELETE,
        body: '',
        params: '',
        headerType: "json",
        authMethod: true,
      );

      var response = await HttpService().init(req, GlobalKey<ScaffoldState>());

      if (response is String && response.isNotEmpty) {
        var jsonRes = jsonDecode(response);
        if (jsonRes["success"] == true) {
          debugPrint("🟢 Chat deleted successfully: ${jsonRes["message"]}");
          return true;
        } else {
          debugPrint("🔴 Failed to delete chat: ${jsonRes["message"]}");
          return false;
        }
      }
      debugPrint("🔴 Empty or invalid response");
      return false;
    } catch (e) {
      debugPrint("🔴 Error deleting chat: $e");
      return false;
    }
  }

  Future<bool> sendDeleteMessage(String msgID) async {
    try {
      debugPrint("🟡 [DELETE MESSAGE] Attempting to delete message ID: $msgID");

      HttpRequestModel req = HttpRequestModel(
        url: 'socket/deleteChatMessage/$msgID',
        method: RequestMethodType.DELETE,
        body: '',
        params: '',
        headerType: "json",
        authMethod: true,
      );

      debugPrint("🟡 [DELETE MESSAGE] Sending request to: ${req.url}");
      debugPrint(
          "🟡 [DELETE MESSAGE] Request method: ${req.method.toString()}");

      var response = await HttpService().init(req, GlobalKey<ScaffoldState>());

      debugPrint(
          "🟡 [DELETE MESSAGE] Raw response received: ${response.toString()}");

      if (response is String && response.isNotEmpty) {
        var jsonRes = jsonDecode(response);
        debugPrint("🟡 [DELETE MESSAGE] Parsed JSON response: $jsonRes");

        if (jsonRes["success"] == true) {
          debugPrint(
              "🟢 [DELETE MESSAGE SUCCESS] Message deleted successfully: ${jsonRes["message"]}");
          debugPrint("🟢 [DELETE MESSAGE SUCCESS] Deleted message ID: $msgID");
          return true;
        } else {
          debugPrint(
              "🔴 [DELETE MESSAGE FAILED] Server response: ${jsonRes["message"]}");
          debugPrint(
              "🔴 [DELETE MESSAGE FAILED] Error details: ${jsonRes["error"] ?? 'No error details'}");
          return false;
        }
      } else {
        debugPrint(
            "🔴 [DELETE MESSAGE ERROR] Empty or invalid response format");
        debugPrint(
            "🔴 [DELETE MESSAGE ERROR] Expected String, got: ${response.runtimeType}");
        return false;
      }
    } catch (e, stackTrace) {
      debugPrint("🔴 [DELETE MESSAGE EXCEPTION] Error: ${e.toString()}");
      debugPrint("🔴 [DELETE MESSAGE EXCEPTION] Stack trace: $stackTrace");
      debugPrint(
          "🔴 [DELETE MESSAGE EXCEPTION] Failed to delete message ID: $msgID");
      return false;
    }
  }

  Future<bool> sendClearChat(String chatId) async {
    try {
      HttpRequestModel req = HttpRequestModel(
        url: 'socket/clearChatMessages/$chatId',
        method: RequestMethodType.DELETE,
        body: '',
        params: '',
        headerType: "json",
        authMethod: true,
      );

      var response = await HttpService().init(req, GlobalKey<ScaffoldState>());

      if (response is String && response.isNotEmpty) {
        var jsonRes = jsonDecode(response);
        if (jsonRes["success"] == true) {
          debugPrint("🟢 Chat cleared successfully: ${jsonRes["message"]}");
          return true;
        } else {
          debugPrint("🔴 Failed to clear chat: ${jsonRes["message"]}");
          return false;
        }
      }
      debugPrint("🔴 Empty or invalid response");
      return false;
    } catch (e) {
      debugPrint("🔴 Error clearing chat: $e");
      return false;
    }
  }

  sendLeaveRoomMessage(
    ChatMessageResult chatMessageModel,
    UserResult toChatUser,
  ) {
    socket.emit(LEAVE_ROOM, [
      {"room_id": toChatUser.userId}
    ]);
  }

  updateSeenCounts(String chatID) {
    socket.emit('updateAllMessagesToSeen', [
      {"chat_id": chatID}
    ]);
  }

  updateLatLng(String lat, String lng, String resID) {
    socket.emit(
      'updateLatLng',
      [
        {"lat": lat, "lng": lng, "restaurant_id": resID}
      ],
    );
  }

  void sendSingleChatMessage(String? txtMessage, UserDetail? toChatUser) {
    if (socket.connected) {
      if (txtMessage != null && txtMessage.isNotEmpty && toChatUser != null) {
        socket.emit(
          SEND_MESSAGE,
          {
            "message": txtMessage,
            "chat_id": _chatID,
            "receiver_id": toChatUser.sId,
          },
        );
        debugPrint("🟢 socket emit SEND_MESSAGE: $txtMessage");
      } else {
        debugPrint(
            "🔴 Message or receiver is null/empty. Cannot send message.");
      }
    } else {
      debugPrint("🔴 Socket is not connected. Cannot send message.");
      // Optionally, attempt to reconnect the socket here
      socket.connect();
    }
  }

  setConnectListener(Function onConnect) {
    socket.onConnect((data) {
      debugPrint("🟢 socket onConnect: $data ?? ''");
      onConnect(data);
    });
  }

  setOnConnectionErrorListener(Function onConnectError) {
    socket.onConnectError((event) {
      debugPrint("🔴 socket onConnect ERROR: $event ?? ''");
      onConnectError(event);
    });
  }

  setOnConnectionErrorTimeOutListener(Function onConnectTimeout) {
    socket.onConnectTimeout((event) {
      debugPrint("🔴 socket connect TIMEOUT: $event ?? ''");
      onConnectTimeout(event);
    });
  }

  setOnErrorListener(Function onError) {
    socket.onError((event) {
      debugPrint("🔴 socket ERROR LISTENER: $event ?? ''");
      onError(event);
    });
  }

  setOnDisconnectListener(Function onDisconnect) {
    socket.onDisconnect((event) {
      debugPrint("🔴 socket onConnect ERROR: $event ?? ''");
      onDisconnect(event);
      socket.disconnect().connect();
    });
  }

  setOnChatMessageReceivedListener(Function onChatMessageReceived) {
    socket.on(ON_MESSAGE_RECEIVED, (data) {
      debugPrint('🟡 ON_MESSAGE_RECEIVED: $data');
      onChatMessageReceived(data);
    });
  }

  setOnCheckedInListener(Function onCheckedInReceived) {
    socket.on(NEW_CHECK_IN_CREATED, (event) {
      printInfo(info: '🟡 ON_CHECKED_IN ⚪️');
      onCheckedInReceived(event);
    });
  }

  setOnCheckedOutListener(Function onCheckedOUTReceived) {
    socket.on(NEW_CHECK_OUT_CREATED, (event) {
      printInfo(info: '🟡 ON_CHECKED_OUT ⚪️');
      onCheckedOUTReceived(event);
    });
  }

  setOnCustomErrorListener(Function onCustomError) {
    socket.on(ON_ERROR, (event) {
      debugPrint("🔴 socket Custom ERROR Listener: $event ?? ''");
      onCustomError(event);
    });
  }

  closeConnection() {
    socket.close();
    socket.io.cleanup();
    socket.io.close();
  }
}

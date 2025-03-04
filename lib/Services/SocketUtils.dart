import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:iseey/Models/ChatMessageModel.dart';
import 'package:iseey/Models/TableListModel.dart';
import 'package:iseey/Models/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

const String socketUrlString = 'https://iseey.app';

class SocketUtils {
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

  initSocket(UserResult? fromUser, String chatId) async {
    this._chatID = chatId;
    debugPrint("🟢 socket init: $fromUser");

    await onConnect();
  }

  onConnect() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    try {
      socket = IO.io(
        socketUrlString,
        OptionBuilder()
            .setTransports(['websocket'])
            .setPath('/socket.io')
            .setQuery(
              {'authorization': token},
            )
            .disableAutoConnect()
            .build(),
      );

      socket.onConnect(
        (data) => printInfo(info: "🟢 socket connected: $data"),
      );
    } catch (error) {
      debugPrint("🔴 CATCH ERROR: ${error.toString()}");
    }
  }

  void connectToSocket() {
    socket.disconnect().connect();
    socket.on("joinedRoom", (data) => debugPrint("$data"));
    socket.on("error-log", (data) => debugPrint("Erroor kirikiri===> $data"));

    socket.onConnect((data) {
      debugPrint("socket connected");
    });
  }

  sendJoinRoom({bool? isChatId = false, UserResult? toChatUser, String? chatId}) {
    socket.emit(JOIN_ROOM, {"room_id": isChatId ?? false ? chatId : toChatUser?.userId});
    debugPrint("🟢 socket emit JOIN_ROOM: $toChatUser");
  }

  sendClearChat(String chatId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";
    String languageCode = pref.getString("languageCode") ?? "en";

    socket.emit("clearChatMessages/$chatId", [{}]);
    var headers = {'Authorization': 'Bearer $token', 'language': languageCode};
    var request = http.Request(
      'DELETE',
      Uri.parse('https://iseey.app/api/app/socket/clearChatMessages/$chatId'),
    );
    request.bodyFields = {};
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      debugPrint(await response.stream.bytesToString());
    } else {
      debugPrint(response.reasonPhrase);
    }
  }

  sendDeleteMessage(String msgID) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";
    String languageCode = pref.getString("languageCode") ?? "en";
    var headers = {'Authorization': 'Bearer $token', 'language': languageCode};
    var request = http.Request('DELETE', Uri.parse('https://iseey.app/api/app/socket/deleteChatMessage/$msgID'));
    request.bodyFields = {};
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      debugPrint(await response.stream.bytesToString());
    } else {
      debugPrint(response.reasonPhrase);
    }
  }

  sendDeleteChat(String chatID) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";
    String languageCode = pref.getString("languageCode") ?? "en";
    var headers = {'Authorization': 'Bearer $token', 'language': languageCode};
    var request = http.Request('DELETE', Uri.parse('https://iseey.app/api/app/socket/deleteChat/$chatID'));
    request.bodyFields = {};
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      debugPrint(await response.stream.bytesToString());
    } else {
      debugPrint(response.reasonPhrase);
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
    socket.emit(
      SEND_MESSAGE,
      [
        {
          "message": txtMessage!,
          "chat_id": _chatID,
          "reciever_id": toChatUser?.sId,
        }
      ],
    );
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
    socket.on(ON_MESSAGE_RECEIVED, (event) {
      debugPrint('🟡 ON_MESSAGE_RECEIVED ⚪️');
      onChatMessageReceived(event);
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

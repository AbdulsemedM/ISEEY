import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:iseey/AuthFlow/domain/user_model/user_model.dart';
import 'package:iseey/GlobalFiles/GlobalMethods.dart';
import 'package:iseey/Services/ApiService.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/GlobalFiles/GlobalVariables.dart';
import 'package:iseey/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:iseey/Services/StateManagement.dart';

class AuthRepository {
  final HttpService httpService;

  AuthRepository(this.httpService);

  Future<void> login(String email, String password,
      GlobalKey<ScaffoldState> scaffoldKey, BuildContext context) async {
    if (email.isEmpty) {
      GlobalWidgets.showSnackBarWithText(
        scaffoldKey.currentState!,
        L10n.current.empty_email_adress_error_message,
        "",
      );
      return;
    }

    if (!isValidateEmail(email)) {
      GlobalWidgets.showSnackBarWithText(
        scaffoldKey.currentState!,
        L10n.current.invalid_email_adress_error_message,
        "",
      );
      return;
    }

    if (password.isEmpty || password.length < 8) {
      GlobalWidgets.showSnackBarWithText(
        scaffoldKey.currentState!,
        password.isEmpty
            ? L10n.current.incorrect_email_adress_error_message
            : L10n.current.password_length_error_message,
        "",
      );
      return;
    }

    final data = {
      'email': email,
      'password': password,
      'device_token': fcmRegistrationToken,
      'device_type': Platform.isIOS ? 'ios' : 'android'
    };

    final req = HttpRequestModel(
      url: 'users/login',
      method: RequestMethodType.POST,
      params: '',
      body: json.encode(data),
      headerType: "json",
      authMethod: false,
    );

    final x = GlobalWidgets();
    try {
      x.showLoading(scaffoldKey.currentContext!);
      final response = await httpService.init(req, scaffoldKey);
      x.hideLoading();

      if (response.isNotEmpty) {
        final jsonRes = jsonDecode(response);
        if (jsonRes['data'] != null && jsonRes['data']['user'] != null) {
          final user = UserModel.fromJson(jsonRes);
          if (user.success == 200) {
            Provider.of<StateManagement>(context, listen: false)
                .setCurrentUserId(user.result?.userId ?? '');

            await _saveUserData(user.result?.token ?? '', user.result);
            _postLoginLocationUpdate(scaffoldKey);
            return;
          } else {
            throw Exception(user.message);
          }
        }
      }
      throw Exception("Invalid response structure");
    } catch (e) {
      x.hideLoading();
      rethrow;
    }
  }

  Future<void> updateDeviceDetails(GlobalKey<ScaffoldState> scaffoldKey) async {
    String? token = fcmRegistrationToken.isNotEmpty
        ? fcmRegistrationToken
        : await FirebaseMessaging.instance.getToken();
    if (token != null && token.isNotEmpty) {
      final data = {
        'device_token': token,
        'device_type': Platform.isIOS ? 'ios' : 'android',
      };
      final req = HttpRequestModel(
        url: 'users/updateDeviceDetails',
        method: RequestMethodType.POST,
        params: '',
        body: json.encode(data),
        headerType: "json",
        authMethod: true,
      );
      try {
        final response = await httpService.init(req, scaffoldKey);
        debugPrint("Update device details API Response: $response");
      } catch (e) {
        debugPrint("Error updating device details: $e");
        throw Exception("Failed to update device details");
      }
    }
  }

  /// Post-login location update with up to 3 retries and exponential backoff.
  /// Failure does not block login; errors are caught and logged.
  void _postLoginLocationUpdate(GlobalKey<ScaffoldState> scaffoldKey) {
    Future<void> attempt(int tryIndex) async {
      const maxRetries = 3;
      if (tryIndex > maxRetries) return;
      try {
        final position = await determinePosition();
        await updateUserCurrentLocation(
          scaffoldKey: scaffoldKey,
          latitude: position.latitude,
          longitude: position.longitude,
        );
      } catch (e) {
        debugPrint("Post-login location update attempt $tryIndex failed: $e");
        if (tryIndex < maxRetries) {
          final delay = Duration(seconds: 1 << (tryIndex - 1));
          await Future.delayed(delay);
          await attempt(tryIndex + 1);
        }
      }
    }
    attempt(1);
  }

  Future<void> updateUserCurrentLocation({
    required GlobalKey<ScaffoldState> scaffoldKey,
    required double latitude,
    required double longitude,
  }) async {
    final data = {
      'lat': latitude,
      'lng': longitude,
    };
    final req = HttpRequestModel(
      url: 'users/updatelatlng',
      method: RequestMethodType.POST,
      params: '',
      body: json.encode(data),
      headerType: "json",
      authMethod: true,
    );
    try {
      final response = await httpService.init(req, scaffoldKey);
      debugPrint("Update location API Response: $response");
    } catch (e) {
      debugPrint("Error updating location: $e");
      rethrow;
    }
  }

  Future<void> _saveUserData(String token, UserResult? userInfo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isFromLogin", true);
    await prefs.setString("token", token);
    debugPrint("Token saved: $token");
    await _storeMapData("userdata", userInfo);
  }

  Future<void> _storeMapData(String key, UserResult? userInfo) async {
    if (userInfo != null) {
      final userData = userInfo.toJson();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, json.encode(userData));
    }
  }

  Future<void> signup(
      {required String firstName,
      required String lastName,
      required String email,
      required String password,
      required GlobalKey<ScaffoldState> scaffoldKey,
      required BuildContext context}) async {
    final data = <String, dynamic>{
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'device_token': fcmRegistrationToken,
      'device_type': Platform.isIOS ? 'ios' : 'android',
    };

    final req = HttpRequestModel(
      url: 'users/signup',
      method: RequestMethodType.POST,
      body: json.encode(data),
      headerType: "json",
      authMethod: false,
    );

    final x = GlobalWidgets();
    try {
      x.showLoading(scaffoldKey.currentContext!);
      final response = await httpService.init(req, scaffoldKey);
      x.hideLoading();
      debugPrint("Signup API Response: $response");
      final jsonRes = jsonDecode(response);
      debugPrint("Decoded JSON: $jsonRes");
      final user = UserModel.fromJson(jsonRes);
      if (user.success == 200) {
        Provider.of<StateManagement>(context, listen: false)
            .setCurrentUserId(user.result?.userId ?? '');
        await login(email, password, scaffoldKey, context);
      } else {
        throw Exception(user.message);
      }
    } catch (e) {
      x.hideLoading();
      rethrow;
    }
  }
}

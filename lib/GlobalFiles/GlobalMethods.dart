import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:iseey/Services/ApiService.dart';
import 'package:iseey/Services/assets_constant.dart';
import 'package:iseey/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'GlobalVariables.dart';
import 'GlobalWidgets.dart';

setCurrentLanguage(String value) async {
  var prefs = await SharedPreferences.getInstance();
  await prefs.setString("currentLanguage", value);
}

Future<void> setFCM(String value) async {
  await SharedPreferences.getInstance()
    ..setString('FCM', value);
}

getFCM() async {
  var prefs = await SharedPreferences.getInstance();
  return prefs.getString('FCM');
}

setStringValueForKey(String key, String value) async {
  var prefs = await SharedPreferences.getInstance();
  return await prefs.setString(key, value);
}

void launchURL(String link, [bool shouldOpenNewTab = true]) async {
  var url = Uri.parse(link);
  if (await canLaunchUrl(url)) {
    if (Platform.isAndroid) {
      if (url.toString().startsWith("https://www.facebook.com/")) {
        final url2 = "fb://facewebmodal/f?href=$url";
        final intent2 = AndroidIntent(action: "action_view", data: url2);
        final canWork = await intent2.canResolveActivity();
        if (canWork != null && canWork) return intent2.launch();
      }
      final intent = AndroidIntent(action: "action_view", data: url.toString());
      return intent.launch();
    } else {
      await launchUrl(url,
          webOnlyWindowName: shouldOpenNewTab ? null : '_self');
    }
  } else {
    Fluttertoast.showToast(msg: 'Invalid url: $link');
  }
}

setBoolValueForKey(String key, bool value) async {
  var prefs = await SharedPreferences.getInstance();
  return await prefs.setBool(key, value);
}

Future<bool> getBoolValueForKey(String key) async {
  var prefs = await SharedPreferences.getInstance();
  return prefs.getBool(key) ?? false;
}

Future<String> getStringValueForKey(String key) async {
  var prefs = await SharedPreferences.getInstance();
  return (prefs.getString(key) ?? "");
}

dynamic getMapData(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return json.decode(prefs.getString(key) ?? '');
}

storeMapData(String key, value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(key, json.encode(value));
}

removePrefForKey(String key) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove(key);
}

bool validatePasswordStructureContainAllType(String value) {
  String? pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp? regExp = new RegExp(pattern);
  return regExp.hasMatch(value);
}

bool isValidateEmail(String value) {
  if (value.isEmpty) {
    return false; //'Enter your Email Address';
  }
  String? pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp? regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return false; //'Enter Valid Email Address';
  else
    return true;
}

String validateEmail(String value) {
  if (value.isEmpty) {
    return 'Enter your Email Address';
  }

  String? pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp? regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Enter Valid Email Address';
  else
    return "";
}

calculateAge(DateTime birthDate) {
  DateTime? currentDate = DateTime.now();
  int? age = currentDate.year - birthDate.year;
  int? month1 = currentDate.month;
  int? month2 = birthDate.month;
  if (month2 > month1) {
    age--;
  } else if (month1 == month2) {
    int day1 = currentDate.day;
    int day2 = birthDate.day;
    if (day2 > day1) {
      age--;
    }
  }
  return age;
}

DateTime? convertDateFromString(
    {required String strDate, String dateComingFormat = "yyyy-MM-dd"}) {
  var formatter = new DateFormat(dateComingFormat);
  DateTime? giveDate = formatter.parse(strDate);

  return giveDate;
}

String convertStringFromDate(
    {required DateTime date, String? dateWantInFormat = "yyyy-MM-dd"}) {
  var formatter = new DateFormat(dateWantInFormat);
  String? strFormattedDate = formatter.format(date);

  return strFormattedDate;
}

String? convertFormattedDateStringFromString(
    String strDate, String dateFormat) {
  var formatter = new DateFormat('yyyy-MM-dd');
  DateTime giveDate = formatter.parse(strDate);

  formatter = DateFormat(dateFormat);
  String? strFormattedDate = formatter.format(giveDate);

  return strFormattedDate;
}

DateTime getDateFromTimeStamp(int timeStamp) {
  var date = new DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
  return date;
}

String? getTimeStampToFormattedTime(
    {String timeFormat = 'dd.MM.yyyy hh:mm a', required int timestamp}) {
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  var format = DateFormat(timeFormat);
  String? currentTime = format.format(date);

  return currentTime;
}

String? getTimeInCustomFormat({String timeFormat = 'dd.MM.yyyy hh:mm a'}) {
  var format = DateFormat(timeFormat);
  DateTime? currentDateTime = DateTime.now();
  String? currentTime = format.format(currentDateTime);

  return currentTime;
}

String? capitalize(String? s) => s![0].toUpperCase() + s.substring(1);

String getDayFromDate(DateTime date) {
  var formatter = new DateFormat('dd');
  String strMonth = formatter.format(date);

  return strMonth;
}

String getMonthFromDate(DateTime date) {
  var formatter = new DateFormat('MMM');
  String strMonth = formatter.format(date);

  return strMonth;
}

int getSecondsFromDate(DateTime date) {
  DateTime? currentDate = DateTime.now();
  int? remainingSeconds = date.difference(currentDate).inSeconds;

  return remainingSeconds;
}

showSuccessOrFail(
  String message,
  bool? success,
  BuildContext? context, {
  bool isCustom = false,
  bool isTitleEnable = true,
  VoidCallback? onCustomOkPress,
}) {
  if (context == null || !Navigator.of(context, rootNavigator: true).mounted) {
    return;
  }
  if (success == true) {
    return globalWidget.showPopUpWithMessage(
      isTitleEnable: isTitleEnable,
      context: context,
      titleMessage: "Success",
      iconAssetPath: AssetsConstant.successIcon,
      message: message,
      onPressOKButton: () {
        if (isCustom) {
          onCustomOkPress?.call();
        } else if (Navigator.of(context, rootNavigator: true).canPop()) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      },
    );
  } else if (success == false) {
    if (message.toLowerCase().contains("retrieved successfully")) {
      debugPrint("Suppressed non-critical error: $message");
      return;
    }

    return globalWidget.showPopUpWithMessage(
      isTitleEnable: isTitleEnable,
      context: context,
      titleMessage: L10n.current.sign_up_failure_message_title,
      iconAssetPath: AssetsConstant.errorIcon,
      message: message,
      onPressOKButton: () {
        if (isCustom) {
          onCustomOkPress?.call();
        } else if (Navigator.of(context, rootNavigator: true).canPop()) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      },
    );
  }
}

Future<dynamic> callUpdateLatLong(GlobalKey<ScaffoldState> scaffoldKey) async {
  Position? _currentPosition = await determinePosition();
  var data = new Map<String, dynamic>();
  data['lat'] = _currentPosition.latitude.toString();
  data['lng'] = _currentPosition.longitude.toString();

  var body = json.encode(data);

  HttpRequestModel req = new HttpRequestModel(
    url: 'users/updatelatlng',
    method: RequestMethodType.POST,
    body: body,
    params: '',
    headerType: "json",
    authMethod: true,
  );
  var response;
  var x = GlobalWidgets();
  try {
    response = await HttpService().init(req, scaffoldKey);

    if (response is String && response != '') {
      var jsonRes = jsonDecode(response);

      bool success = jsonRes["success"];
      String message = jsonRes["message"];

      if (success == 200) {
        return {'lat': data['lat'], 'lng': data['lng']};
      } else {
        final context = scaffoldKey.currentContext;
        if (context != null) showSuccessOrFail(message, success, context);
        return false;
      }
    } else {
      final context = scaffoldKey.currentContext;
      if (context != null)
        showSuccessOrFail(
          L10n.current.something_went_wrong,
          false,
          context,
        );
      return false;
    }
  } catch (e) {
    debugPrint("EXCEPTION $e");
  }
  x.hideLoading();
  return false;
}

Future<Position> determinePosition() async {
  try {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    log("Location permission status: $permission");
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    final results = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      ),
    );
    log("Current position: ${results.latitude}, ${results.longitude}");
    return results;
  } catch (e) {
    throw Exception(
      'Error determining position: $e',
    );
  }
}

String getCSString(List<String> list) => list.join(", ");
String getTitleCase(String str) => str[0].toUpperCase() + str.substring(1);

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:iseey/AuthFlow/view/LoginScreen.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
import 'ConnectionStatusSingleton.dart';

String baseUrl = 'https://iseey.app/app/api/';
String mainBaseUrl = 'https://iseey.app/app/api/';
const multipartURL = 'https://iseey.app/app/api/';

bool? isNetworkConnected;

enum RequestMethodType { GET, POST, DELETE, PATCH, MULTIPART, PUT }

class HttpRequestModel {
  final String url;
  final RequestMethodType? method;
  final Object? body;
  final Map<String, String>? multipartBody;
  final String? params;
  final String headerType;
  final bool authMethod;
  File? file;
  String? fileFieldName;

  HttpRequestModel({
    required this.url,
    required this.headerType,
    required this.authMethod,
    required this.body,
    this.method = RequestMethodType.GET,
    this.params,
    this.multipartBody,
    this.file,
    this.fileFieldName = 'file', // Default value
  });
}

StreamSubscription? connectionChangeStream;

class HttpService {
  late Map<String, String> headers;

  setHeaders(HttpRequestModel httpRequestModel) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";
    log("Token: $token");
    String languageCode = pref.getString("languageCode") ?? "en";

    if (!httpRequestModel.authMethod) {
      this.headers = {'Content-type': 'application/json'};
    } else {
      if (httpRequestModel.method == RequestMethodType.MULTIPART) {
        this.headers = {
          'Authorization': "Bearer " + token,
          'Content-type': 'multipart/form-data',
          'language': languageCode
        };
      } else {
        this.headers = {
          'Authorization': "Bearer " + token,
          'Content-type': 'application/json',
          'language': languageCode
        };
      }
    }

    baseUrl = mainBaseUrl;
  }

  void connectionChanged(dynamic hasConnection) {
    isNetworkConnected = hasConnection;
  }

  Future<dynamic> init(
      HttpRequestModel httpRequestModel, GlobalKey<ScaffoldState> context,
      [callback]) async {
    if (connectionChangeStream != null) {
      connectionChangeStream?.cancel();
      connectionChangeStream = null;
    }
    ConnectionStatusSingleton connectionStatus =
        ConnectionStatusSingleton.getInstance();
    connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
    await this.setHeaders(httpRequestModel);

    isNetworkConnected = await connectionStatus.checkConnection();

    if (isNetworkConnected == false) {
      GlobalWidgets.showSnackBarWithText(
        context.currentState!,
        L10n.current.no_internet_connection,
        "",
      );
      return '';
    }

    try {
      if (httpRequestModel.method == RequestMethodType.MULTIPART) {
        var url = multipartURL + httpRequestModel.url.replaceAll(baseUrl, "");
        print('Multipart request URL: $url');
        File file = httpRequestModel.file!;
        var response = await doMultipartFile(
          url,
          this.headers,
          file,
          httpRequestModel.multipartBody ?? {},
          httpRequestModel.fileFieldName ?? 'file',
        );
        return response; // Returns Map for multipart requests
      }

      // Handle other request types (returning String)
      String url = baseUrl + httpRequestModel.url;
      http.Response response;

      switch (httpRequestModel.method) {
        case RequestMethodType.PATCH:
          response = await doPatch(url, httpRequestModel.body, this.headers);
          break;
        case RequestMethodType.POST:
          response = await doPost(url, httpRequestModel.body, this.headers);
          break;
        case RequestMethodType.GET:
          response = await callGetMethod(url, this.headers);
          break;
        case RequestMethodType.DELETE:
          response = await doDelete(url, this.headers);
          break;
        case RequestMethodType.PUT:
          response = await http.put(
            Uri.parse(url),
            headers: this.headers,
            body: httpRequestModel.body,
          );
          break;
        default:
          return '';
      }

      return handleResponse(response, context, callback);
    } catch (e) {
      debugPrint(e.toString());
      return '';
    }
  }

  showServerConnectionRefuseError(GlobalKey<ScaffoldState> context) {
    GlobalWidgets.showSnackBarWithText(
      context.currentState!,
      L10n.current.something_went_wrong,
      "",
    );
  }

  Future<String> handleResponse(
      Response aResponse, GlobalKey<ScaffoldState> context,
      [callback]) async {
    if (callback != null) {
      callback();
    }

    switch (aResponse.statusCode) {
      case 200:
        return aResponse.body;

      case 201:
        return aResponse.body;

      case 400:
        return aResponse.body;

      case 401:
        final currentState = context.currentState;
        final currentContext = context.currentContext;
        if (currentState != null)
          GlobalWidgets.showSnackBarWithText(
            currentState,
            L10n.current.incorrect_email_adress_error_message,
            "",
            displayDuration: 2,
          );
        await Future.delayed(Duration(seconds: 3));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("isFromLogin", false);
        if (currentContext != null)
          Navigator.pushAndRemoveUntil(
            currentContext,
            PageRouteBuilder(
              settings: RouteSettings(name: "/login"),
              pageBuilder: (BuildContext context, Animation animation,
                  Animation secondaryAnimation) {
                return LoginScreen();
              },
              transitionsBuilder: (BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child) {
                return new SlideTransition(
                  position: new Tween<Offset>(
                    begin: const Offset(-1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            ),
            (Route route) => false,
          );

        break;

      case 404:
        GlobalWidgets.showSnackBarWithText(
          context.currentState!,
          L10n.current.something_went_wrong,
          "",
        );
        throw new Error();

      case 405:
        GlobalWidgets.showSnackBarWithText(
            context.currentState!, L10n.current.blocked_user_no_data_title, "");
        throw new Error();

      case 500:
        GlobalWidgets.showSnackBarWithText(
            context.currentState!, L10n.current.blocked_user_no_data_title, "");
        throw new Error();

      default:
        try {
          var jsonRes = jsonDecode(aResponse.body);
          Map<String, dynamic> result = jsonRes["errors"];
          String msg = result["detail"];

          GlobalWidgets.showSnackBarWithText(context.currentState!, msg, "");
        } catch (e) {
          GlobalWidgets.showSnackBarWithText(
            context.currentState!,
            L10n.current.something_went_wrong,
            "",
          );
        }

        throw new Error();
    }

    return Future(() => aResponse.body);
  }

  handleError(error) => debugPrint("Error in Api Call");

  Future<http.Response> callGetMethod(
      String subUrl, Map<String, String> headerType) {
    return http.get(Uri.parse(Uri.encodeFull(subUrl)), headers: headerType);
  }

  Future<http.Response> doPatch(
      String subUrl, Object? body, Map<String, String> headerType) {
    return http.patch(Uri.parse(Uri.encodeFull(subUrl)),
        headers: headerType, body: body);
  }

  Future<http.Response> doPost(
      String subUrl, Object? body, Map<String, String> headerType) {
    return http.post(Uri.parse(Uri.encodeFull(subUrl)),
        headers: headerType, body: body);
  }

  Future<http.Response> doDelete(
      String subUrl, Map<String, String> headerType) {
    return http.delete(Uri.parse(Uri.encodeFull(subUrl)), headers: headerType);
  }

  Future<Map<String, dynamic>> doMultipartFile(
    String subUrl,
    Map<String, String> headerType,
    File file,
    Map<String, String> body,
    String fileFieldName,
  ) async {
    print('[DEBUG] Preparing multipart request to $subUrl');

    var request = http.MultipartRequest('POST', Uri.parse(subUrl));

    // Add headers
    request.headers.addAll({
      'Authorization': headerType['Authorization'] ?? '',
      'language': headerType['language'] ?? 'en',
    });

    // Add the file
    var multipartFile = await http.MultipartFile.fromPath(
      fileFieldName,
      file.path,
      filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
      contentType: MediaType('image', 'jpeg'),
    );
    request.files.add(multipartFile);

    // Add any additional fields
    if (body.isNotEmpty) {
      request.fields.addAll(body);
    }

    print('[DEBUG] Sending multipart request...');
    var response = await request.send();

    // Read the response only once
    final responseBody = await response.stream.bytesToString();
    print('[DEBUG] Response status: ${response.statusCode}');
    print('[DEBUG] Response body: $responseBody');

    return {
      'statusCode': response.statusCode,
      'body': responseBody,
    };
  }
}

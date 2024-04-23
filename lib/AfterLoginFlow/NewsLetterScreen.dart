import 'dart:convert';

import 'package:ISEEY/GlobalFiles/AppColors.dart';
import 'package:ISEEY/GlobalFiles/GlobalMethods.dart';
import 'package:ISEEY/GlobalFiles/GlobalVariables.dart';
import 'package:ISEEY/GlobalFiles/GlobalWidgets.dart';
import 'package:ISEEY/Models/NewsletterModel.dart';
import 'package:ISEEY/Services/ApiService.dart';
import 'package:ISEEY/Services/assets_constant.dart';
import 'package:ISEEY/generated/l10n.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:progress_indicators/progress_indicators.dart';

class NewsLetterScreen extends StatefulWidget {
  @override
  _NewsLetterScreenState createState() => _NewsLetterScreenState();
}

class _NewsLetterScreenState extends State<NewsLetterScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      callGetNewsLetterApi();
    });
  }

  bool loading = false;
  List<NewsletterResult> newsletterListResult = [];

  callGetNewsLetterApi() async {
    HttpRequestModel req = new HttpRequestModel(
        url: 'newsletters/list',
        method: RequestMethodType.GET,
        body: '',
        params: '',
        headerType: "json",
        authMethod: true);
    var response;
    try {
      setState(() {
        loading = true;
      });
      response = await HttpService().init(req, scaffoldKey);

      if (response is String && response != '') {
        var jsonRes = jsonDecode(response);

        NewsletterModel modelData = NewsletterModel.fromJson(jsonRes);

        if (modelData.success == 200) {
          setState(() {
            newsletterListResult.clear();
            newsletterListResult.addAll(modelData.result);
          });
        } else {
          showSuccessOrFail(modelData.message, modelData.success, context);
        }
      } else {
        showSuccessOrFail(L10n.current.something_went_wrong, 000, context);
      }
      setState(() {
        loading = false;
      });
    } catch (e) {
      debugPrint("EXCEPTION $e");
      setState(() {
        loading = false;
      });
    }
  }

  callPatchNewsLetterApi(GlobalKey<ScaffoldState> scaffoldKey,
      String restaurantId, bool newsletterEnable) async {
    HttpRequestModel req = new HttpRequestModel(
        url: 'newsletters/subscribe/$restaurantId/$newsletterEnable',
        method: RequestMethodType.PATCH,
        body: '',
        params: '',
        headerType: "json",
        authMethod: true);
    var response;
    try {
      setState(() {
        loading = true;
      });
      response = await HttpService().init(req, scaffoldKey);

      setState(() {
        loading = false;
      });
      if (response is String && response != '') {
        var jsonRes = jsonDecode(response);

        NewsletterModel modelData = NewsletterModel.fromJson(jsonRes);

        if (modelData.success == 200) {
        } else {
          showSuccessOrFail(modelData.message, modelData.success, context);
        }
      } else {
        showSuccessOrFail(L10n.current.something_went_wrong, 000, context);
      }
    } catch (e) {
      debugPrint("EXCEPTION $e");
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.screensBackgroundsColor,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          padding: EdgeInsets.only(top: 15),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    alignment: Alignment.center,
                    child: NeumorphicButton(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Center(
                        child: Image.asset(
                          AssetsConstant.instance.leftArrowIcon,
                          fit: BoxFit.contain,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.flat,
                        depth: -2,
                        color: AppColors.listBoxBackgroundColor,
                        border: NeumorphicBorder(
                          color: AppColors.innerShadowColor,
                          width: 0.1,
                        ),
                        intensity: 0.6,
                        shadowDarkColor: AppColors.innerShadowColor,
                        shadowLightColorEmboss: AppColors.innerShadowColor,
                        shadowDarkColorEmboss: AppColors.innerShadowColor,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(right: 45),
                      height: 45,
                      width: double.infinity,
                      child: GlobalWidgets.setText(
                        L10n.current.newsletter_page_title,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        strTextColor: AppColors.strMainTextColorWhite,
                      ),
                    ),
                  ),
                ],
              ),
              loading
                  ? Padding(
                      padding: const EdgeInsets.only(top: 300.0),
                      child: Container(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 25),
                                child: GlobalWidgets.setText(
                                    L10n.current.loading_title,
                                    strTextColor:
                                        AppColors.strMainTextColorWhite,
                                    fontSize: 16),
                              ),
                              CollectionSlideTransition(
                                children: <Widget>[
                                  Container(),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 5, 8, 0),
                                    child: Icon(
                                      Icons.circle,
                                      color:
                                          AppColors.mainBackgroundColorOrange,
                                      size: 15,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 5, 8, 0),
                                    child: Icon(
                                      Icons.circle,
                                      color:
                                          AppColors.mainBackgroundColorOrange,
                                      size: 15,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 5, 8, 0),
                                    child: Icon(
                                      Icons.circle,
                                      color:
                                          AppColors.mainBackgroundColorOrange,
                                      size: 15,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                    child: Icon(
                                      Icons.circle,
                                      color:
                                          AppColors.mainBackgroundColorOrange,
                                      size: 15,
                                    ),
                                  ),
                                  Container(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Flexible(
                      child: Container(
                        child: ListView.builder(
                          padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
                          itemCount: newsletterListResult.length == 0
                              ? 1
                              : newsletterListResult.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => debugPrint('what is this for'),
                              child: newsletterListResult.length == 0
                                  ? Container(
                                      child: Center(
                                          child: Container(
                                        width: screenSize.width - 40,
                                        height: screenSize.width - 40,
                                        child: Neumorphic(
                                          style: NeumorphicStyle(
                                            shape: NeumorphicShape.flat,
                                            depth: -3,
                                            lightSource: LightSource.top,
                                            color: AppColors
                                                .tabBarBoxBackgroundColor,
                                            border: NeumorphicBorder(
                                              color: AppColors.innerShadowColor,
                                              width: 1,
                                            ),
                                            shadowDarkColor:
                                                AppColors.innerShadowColor,
                                            shadowLightColorEmboss:
                                                Colors.transparent,
                                            shadowDarkColorEmboss:
                                                AppColors.innerShadowColor,
                                          ),
                                          child: Stack(
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                height: double.infinity,
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 40, 0, 40),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 0, 40),
                                                      child: Image.asset(
                                                        AssetsConstant.instance.errorIcon,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 0, 15),
                                                      child:
                                                          GlobalWidgets.setText(
                                                        L10n.current
                                                            .blocked_user_sorry_title,
                                                        strTextColor: AppColors
                                                            .strMainTextColorWhite,
                                                        textAlign:
                                                            TextAlign.center,
                                                        fontSize: 26,
                                                      ),
                                                    ),
                                                    Container(
                                                      child:
                                                          GlobalWidgets.setText(
                                                        L10n.current
                                                            .blocked_user_no_data_title,
                                                        strTextColor: AppColors
                                                            .strMainTextColorWhite,
                                                        textAlign:
                                                            TextAlign.center,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )),
                                    )
                                  : setListItem(
                                      newsletterListResult[index], index),
                            );
                          },
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  setListItem(NewsletterResult result, int index) {
    return Container(
      child: Neumorphic(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
          padding: EdgeInsets.all(0),
          style: NeumorphicStyle(
            shape: NeumorphicShape.flat,
            boxShape: NeumorphicBoxShape.roundRect(
              BorderRadius.circular(5),
            ),
            depth: -2,
            color: AppColors.listBoxBackgroundColor,
            border: NeumorphicBorder(
              color: AppColors.innerShadowColor,
              width: 0.1,
            ),
            intensity: 0.6,
            shadowDarkColor: AppColors.innerShadowColor,
            shadowLightColorEmboss: AppColors.innerShadowColor,
            shadowDarkColorEmboss: AppColors.innerShadowColor,
          ),
          child: Slidable(
            key: ValueKey(index),
            closeOnScroll: true,
            endActionPane: ActionPane(
              motion: ScrollMotion(),
              extentRatio: 0.24,
              children: [
                CustomSlidableAction(
                  backgroundColor: AppColors.listBoxBackgroundColor,
                  onPressed: (BuildContext context) {},
                  child: Container(
                    width: 45,
                    height: 45,
                    alignment: Alignment.center,
                    child: NeumorphicButton(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Center(
                        child: Image.asset(
                          AssetsConstant.instance.deleteIcon,
                          fit: BoxFit.contain,
                          scale: 1.2,
                        ),
                      ),
                      onPressed: () {
                        globalWidget.showPopUpWithMessage(
                            context:
                                mainTabsScaffoldKey.currentContext ?? context,
                            conditionButtonEnable: true,
                            titleMessage: L10n.current.app_name,
                            onPressOKButton: () {
                              callDeleteNewsLetter(
                                  scaffoldKey, result.restaurantId, index);
                            },
                            message: L10n.current
                                .newsletter_page_delete_newsletter_warning_message);
                      },
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.flat,
                        boxShape: NeumorphicBoxShape.circle(),
                        depth: -5,
                        lightSource: LightSource.top,
                        color: AppColors.listBoxBackgroundColor,
                        border: NeumorphicBorder(
                          color: AppColors.innerShadowColor,
                          width: 2,
                        ),
                        shadowDarkColor: AppColors.innerShadowColor,
                        shadowLightColorEmboss: Colors.transparent,
                        shadowDarkColorEmboss: AppColors.innerShadowColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 20, 0, 5),
                      width: 250,
                      child: GlobalWidgets.setText(
                        result.restaurantDetail?.name ?? '',
                        maxLine: 4,
                        fontSize: 20,
                        strTextColor: AppColors.strMainTextColorWhite,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 20),
                      width: 250,
                      child: GlobalWidgets.setText(
                        result.restaurantDetail?.cityDetails != null &&
                                result.restaurantDetail?.countryDetails != null
                            ? "${result.restaurantDetail?.cityDetails?.name} - ${result.restaurantDetail?.countryDetails?.name}"
                            : "",
                        maxLine: 4,
                        fontSize: 16,
                        strTextColor: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 60,
                          height: 30,
                          child: Neumorphic(
                            style: NeumorphicStyle(
                              shape: NeumorphicShape.flat,
                              boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(15),
                              ),
                              depth: -3,
                              lightSource: LightSource.top,
                              color: AppColors.screensBackgroundsColor,
                              border: NeumorphicBorder(
                                color: AppColors.innerShadowColor,
                                width: 1,
                              ),
                              shadowDarkColor: AppColors.innerShadowColor,
                              shadowLightColorEmboss: Colors.transparent,
                              shadowDarkColorEmboss: AppColors.innerShadowColor,
                            ),
                            child: FlutterSwitch(
                              value: result.enabled,
                              onToggle: (value) {
                                setState(() {
                                  callPatchNewsLetterApi(scaffoldKey,
                                      result.restaurantId, !result.enabled);
                                  result.enabled = !result.enabled;
                                });
                              },
                              activeColor: Colors.transparent,
                              inactiveColor: Colors.transparent,
                            ),
                          ),
                        ),
                        Container(
                          width: 20,
                          height: 20,
                          margin: EdgeInsets.only(right: 10, left: 10),
                          child: Neumorphic(
                            style: NeumorphicStyle(
                              shape: NeumorphicShape.flat,
                              boxShape: NeumorphicBoxShape.circle(),
                              depth: -3,
                              lightSource: LightSource.top,
                              color: result.enabled
                                  ? AppColors.mainBackgroundColorOrange
                                  : AppColors.screensBackgroundsColor,
                              shadowDarkColor: AppColors.innerShadowColor,
                              shadowLightColorEmboss: Colors.transparent,
                              shadowDarkColorEmboss: AppColors.innerShadowColor,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Future<bool> callDeleteNewsLetter(GlobalKey<ScaffoldState> scaffoldKey,
      String restaurantId, int index) async {
    HttpRequestModel req = new HttpRequestModel(
        url: 'newsletters/delete/$restaurantId',
        method: RequestMethodType.DELETE,
        body: '',
        params: '',
        headerType: "json",
        authMethod: true);
    var response;
    var x = GlobalWidgets();
    try {
      x.showLoading(scaffoldKey.currentContext ?? context);
      response = await HttpService().init(req, scaffoldKey);
      x.hideLoading();

      if (response is String && response != '') {
        var jsonRes = jsonDecode(response);

        int success = jsonRes["success"];
        String message = jsonRes["message"];
        if (success == 200) {
          setState(() {
            try {
              newsletterListResult.removeAt(index);
            } catch (e) {}
          });
          return true;
        } else {
          showSuccessOrFail(message, success, context);
          return false;
        }
      } else {
        showSuccessOrFail(L10n.current.something_went_wrong, 000, context);
        return false;
      }
    } catch (e) {
      debugPrint("EXCEPTION $e");
    }
    x.hideLoading();
    return false;
  }
}

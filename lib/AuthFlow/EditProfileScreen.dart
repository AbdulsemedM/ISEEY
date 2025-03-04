import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iseey/AuthFlow/LoginScreen.dart';
import 'package:iseey/GlobalFiles/GlobalFiles.dart';
import 'package:iseey/GlobalFiles/transitions/slide_route.dart';
import 'package:iseey/Models/UserModel.dart';
import 'package:iseey/Services/ApiService.dart';
import 'package:iseey/Services/assets_constant.dart';
import 'package:iseey/Services/notification_utils.dart';
import 'package:iseey/generated/l10n.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel? userModel;
  final bool isFromSignUp;

  EditProfileScreen({
    Key? key,
    this.userModel,
    this.isFromSignUp = false,
  }) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  int selectedScreenIndex = 0;
  String selectedGender = '';
  DateTime selectedDob = DateTime.now();
  Position? currentPosition;

  List<String> genderList = [
    L10n.current.gender_male,
    L10n.current.gender_female,
    L10n.current.gender_others,
  ];

  @override
  void initState() {
    super.initState();

    _initData();
  }

  void _initData() async {
    await setUserData();
    await _setUserPosition();
  }

  setUserData() async {
    Map<String, dynamic> data = await getMapData("userdata");
    UserResult? userInfo = UserResult.fromJson(data);
    setState(() {
      profileImgUrl = userInfo.image;
      profileImage = profileImgUrl;
      firstNameController.text = userInfo.firstName;
      lastNameController.text = userInfo.lastName;
      emailController.text = userInfo.email;
      selectedGender = userInfo.gender;
      descriptionController.text = userInfo.description;
      fbController.text = userInfo.facebookUrl;
      instaController.text = userInfo.instagramUrl;
      genderController.text = genderList[selectedGender == "M"
          ? 0
          : selectedGender == "F"
              ? 1
              : 2];

      String strDob = userInfo.dob;
      if (userInfo.dob.isEmpty) {
        dobController.text = "";
      } else {
        selectedDob = DateTime.fromMillisecondsSinceEpoch(int.parse(strDob));
        dobController.text = convertStringFromDate(date: selectedDob, dateWantInFormat: "dd-MM-yyyy");
      }
    });
  }

  Future<void> _setUserPosition() async {
    final position = await Geolocator.getCurrentPosition();
    setState(() => currentPosition = position);
  }

  Future<File> getImageFileFromAssets(String? path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  callProfileUpdateApi(String imgUrl) async {
    FocusScope.of(context).unfocus();
    var x = GlobalWidgets();

    try {
      var data = new Map<String, String>();
      data['email'] = emailController.text;
      data['first_name'] = firstNameController.text;
      data['last_name'] = lastNameController.text;
      data['gender'] = selectedGender;
      data['dob'] = selectedDob.millisecondsSinceEpoch.toString();
      if (currentPosition != null) {
        data['lng'] = currentPosition!.longitude.toString();
        data['lat'] = currentPosition!.latitude.toString();
      }
      if (descriptionController.text.isNotEmpty) data['description'] = descriptionController.text;
      if (fbController.text.isNotEmpty) data['facebookURL'] = fbController.text;
      if (instaController.text.isNotEmpty) data['instagramURL'] = instaController.text;

      var selectedPath = selectedImage?.path ?? '';

      if (selectedPath.isNotEmpty) {
        await HttpRequestModel(
          url: 'upload/user',
          method: RequestMethodType.POST,
          body: {"picture": selectedPath},
          headerType: "json",
          authMethod: true,
        );
      }

      HttpRequestModel req = new HttpRequestModel(
        url: 'users/updateProfile',
        method: RequestMethodType.PUT,
        body: json.encode(data),
        multipartBody: data,
        params: '',
        headerType: "json",
        authMethod: true,
      );

      var response;

      try {
        x.showLoading(scaffoldKey.currentContext ?? context);
        response = await HttpService().init(req, scaffoldKey);
        x.hideLoading();

        if (response is String && response != '') {
          var jsonRes = jsonDecode(response);

          UserModel user = UserModel.fromJson(jsonRes);

          if (user.success != 200) {
            showSuccessOrFail(user.message, false, context);
          }

          HttpRequestModel getProfileResponse = new HttpRequestModel(
            url: 'users/getProfile',
            method: RequestMethodType.GET,
            body: '',
            multipartBody: null,
            params: '',
            headerType: "json",
            authMethod: true,
          );

          final profileResponse = await HttpService().init(getProfileResponse, scaffoldKey);
          final data = jsonDecode(profileResponse);

          if (profileResponse != '') {
            UserResult user = UserResult.fromJson(data['data']);
            saveResponse(user);
          }
        } else {}
      } catch (error) {
        showSuccessOrFail(L10n.current.something_went_wrong, false, context);
        debugPrint("EXCEPTION $error");
      }
    } catch (error) {
      showSuccessOrFail(L10n.current.something_went_wrong, false, context);
      debugPrint("Error in getting current position $error");
    }
    x.hideLoading();
  }

  void saveResponse(UserResult? userInfo) async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    prefs.setBool("isFromLogin", true);
    storeMapData("userdata", userInfo ?? null);
  }

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController fbController = TextEditingController();
  TextEditingController instaController = TextEditingController();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.screensBackgroundsColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            padding: EdgeInsets.only(top: 15),
            child: Column(
              children: [
                Row(
                  children: [
                    widget.isFromSignUp
                        ? Container(width: 45)
                        : Container(
                            width: 45,
                            height: 45,
                            alignment: Alignment.center,
                            child: NeumorphicButton(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Center(
                                child: Image.asset(
                                  AssetsConstant.leftArrowIcon,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              onPressed: () {
                                if (!widget.isFromSignUp) {
                                  Navigator.pop(context);
                                }
                              },
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.flat,
                                depth: -3,
                                lightSource: LightSource.top,
                                color: AppColors.listBoxBackgroundColor,
                                border: NeumorphicBorder(
                                  color: AppColors.innerShadowColor,
                                  width: 1,
                                ),
                                shadowDarkColor: AppColors.innerShadowColor,
                                shadowLightColorEmboss: Colors.transparent,
                                shadowDarkColorEmboss: AppColors.innerShadowColor,
                              ),
                            ),
                          ),
                    !widget.isFromSignUp
                        ? Flexible(
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(right: 45),
                              height: 45,
                              width: double.infinity,
                              child: GlobalWidgets.setText(
                                L10n.current.menu_profile_title,
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                strTextColor: AppColors.strMainTextColorWhite,
                              ),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
                !widget.isFromSignUp
                    ? Container(
                        margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      setState(() {
                                        selectedScreenIndex = 0;
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.fromLTRB(5, 20, 5, 15),
                                          child: GlobalWidgets.setText(
                                            L10n.current.edit_profile_basic_information_title,
                                            strTextColor: AppColors.strMainTextColorWhite,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.45,
                                          height: 3,
                                          color: selectedScreenIndex == 0
                                              ? AppColors.mainBackgroundColorOrange
                                              : Colors.transparent,
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      setState(() {
                                        selectedScreenIndex = 1;
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.fromLTRB(5, 20, 5, 15),
                                          margin: EdgeInsets.only(left: 10),
                                          child: GlobalWidgets.setText(
                                            L10n.current.edit_profile_account_information_title,
                                            strTextColor: AppColors.strMainTextColorWhite,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.45,
                                          height: 3,
                                          color: selectedScreenIndex == 1
                                              ? AppColors.mainBackgroundColorOrange
                                              : Colors.transparent,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )))
                    : Container(height: 20),
                selectedScreenIndex == 0
                    ? Flexible(
                        child: setBasicInformation(),
                      )
                    : Flexible(
                        child: setAccountInformation(),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  setBasicInformation() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () => getActionSheet(),
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: profileImage.isEmpty
                        ? CircleAvatar(
                            radius: 71.0,
                            backgroundColor: AppColors.mainBackgroundColorOrange,
                            child: selectedImage != null
                                ? CircleAvatar(
                                    radius: 70.0,
                                    backgroundImage: FileImage(selectedImage ?? File('')),
                                    backgroundColor: AppColors.mainBackgroundColorOrange,
                                  )
                                : CircleAvatar(
                                    radius: 70.0,
                                    backgroundColor: Colors.white,
                                    backgroundImage: AssetImage("assets/man-placeholder.png"),
                                  ),
                          )
                        : CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.transparent,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: profileImage,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const CircularProgressIndicator(),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                            ),
                          ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      child: Image.asset(
                        AssetsConstant.editProfileImgIcon,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(5, 20, 5, 0),
              child: GlobalWidgets.setTextField(
                onTap: () {},
                controller: firstNameController,
                fontColor: AppColors.mainTextColorWhite,
                cursorColor: AppColors.mainBackgroundColorOrange,
                txtFieldLabelText: L10n.current.sign_up_first_name_text_field_title,
                txtFieldHintText: L10n.current.edit_profile_example_first_name,
                strPrefixAssetImageName: AssetsConstant.userIcon,
                inputType: TextInputType.name,
                validator: (value) {
                  if (value.length == 0) {
                    return "      " + L10n.current.sign_up_first_name_required_error + strSup;
                  }
                  return null;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(5, 20, 5, 0),
              child: GlobalWidgets.setTextField(
                onTap: () {},
                controller: lastNameController,
                fontColor: AppColors.mainTextColorWhite,
                cursorColor: AppColors.mainBackgroundColorOrange,
                txtFieldLabelText: L10n.current.sign_up_last_name_text_field_title,
                txtFieldHintText: L10n.current.edit_profile_example_last_name,
                strPrefixAssetImageName: AssetsConstant.userIcon,
                inputType: TextInputType.name,
                validator: (value) {
                  if (value.length == 0) {
                    return "      " + L10n.current.sign_up_last_name_required_error + strSup;
                  }
                  return null;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(5, 20, 5, 0),
              child: GlobalWidgets.setTextField(
                onTap: () {},
                controller: emailController,
                fontColor: AppColors.mainTextColorWhite,
                txtFieldHintText: L10n.current.edit_profile_example_email,
                cursorColor: AppColors.mainBackgroundColorOrange,
                margin: EdgeInsets.fromLTRB(10, 15, 20, 15),
                inputType: TextInputType.emailAddress,
                txtFieldLabelText: L10n.current.sign_up_email_text_field_title,
                validator: (value) {
                  if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                    return 'Email not valid';
                  }
                  if (value.length == 0) {
                    return "      " + L10n.current.sign_up_email_required_error + strSup;
                  }
                  return null;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(5, 20, 5, 0),
              child: GlobalWidgets.setTextField(
                controller: genderController,
                fontColor: AppColors.mainTextColorWhite,
                cursorColor: AppColors.mainBackgroundColorOrange,
                strPrefixAssetImageName: AssetsConstant.userIcon,
                txtFieldLabelText: L10n.current.edit_profile_gender_text_field_text,
                txtFieldHintText: "",
                inputType: TextInputType.text,
                focusNode: AlwaysDisabledFocusNode(),
                onTap: () async {
                  return await showMaterialScrollPicker(
                    context: context,
                    title: L10n.current.edit_profile_gender_selection_title,
                    showDivider: false,
                    items: genderList,
                    headerColor: AppColors.mainBackgroundColorOrange,
                    buttonTextColor: AppColors.mainBackgroundColorOrange,
                    onChanged: (dynamic value) {
                      setState(() {
                        selectedGender = value == L10n.current.gender_male
                            ? "M"
                            : value == L10n.current.gender_female
                                ? "F"
                                : "O";
                        genderController.text = value ?? '';
                      });
                    },
                    onCancelled: () => debugPrint("Scroll Picker cancelled"),
                    onConfirmed: () => debugPrint("Scroll Picker confirmed"),
                    cancelText: L10n.current.cancel_button_title,
                    selectedItem: selectedGender,
                  );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(5, 20, 5, 0),
              child: GlobalWidgets.setTextField(
                controller: dobController,
                focusNode: AlwaysDisabledFocusNode(),
                fontColor: AppColors.mainTextColorWhite,
                cursorColor: AppColors.mainBackgroundColorOrange,
                strPrefixAssetImageName: AssetsConstant.calendar,
                txtFieldLabelText: L10n.current.edit_profile_birthday_text_field_title,
                inputType: TextInputType.text,
                txtFieldHintText: "",
                onTap: () {
                  FocusScope.of(context).unfocus();
                  showDatePicker(
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          colorScheme: ColorScheme.light(primary: AppColors.mainBackgroundColorOrange),
                        ),
                        child: child ?? Container(),
                      );
                    },
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  ).then((value) {
                    selectedDob = value != null ? value.toUtc() : DateTime.now();
                    String strDate =
                        convertStringFromDate(date: value ?? DateTime.now(), dateWantInFormat: "dd-MM-yyyy");
                    dobController.text = strDate;
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(5, 20, 5, 0),
              child: GlobalWidgets.setTextField(
                onTap: () {},
                controller: descriptionController,
                fontColor: AppColors.mainTextColorWhite,
                cursorColor: AppColors.mainBackgroundColorOrange,
                txtFieldLabelText: L10n.current.edit_profile_description_text_field,
                txtFieldHintText: L10n.current.edit_profile_description_text_field,
                strPrefixAssetImageName: AssetsConstant.userIcon,
                inputType: TextInputType.text,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(5, 20, 5, 0),
              child: GlobalWidgets.setTextField(
                onTap: () {},
                controller: fbController,
                fontColor: AppColors.mainTextColorWhite,
                cursorColor: AppColors.mainBackgroundColorOrange,
                txtFieldLabelText: L10n.current.edit_profile_facebook_text_field,
                txtFieldHintText: L10n.current.edit_profile_facebook_text_field,
                strPrefixAssetImageName: AssetsConstant.facebook,
                prefixIconMargin: EdgeInsets.all(3),
                inputType: TextInputType.text,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(5, 20, 5, 0),
              child: GlobalWidgets.setTextField(
                onTap: () {},
                controller: instaController,
                fontColor: AppColors.mainTextColorWhite,
                cursorColor: AppColors.mainBackgroundColorOrange,
                txtFieldLabelText: L10n.current.edit_profile_instagram_text_field,
                txtFieldHintText: L10n.current.edit_profile_instagram_text_field,
                strPrefixAssetImageName: AssetsConstant.instagram,
                inputType: TextInputType.text,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30, bottom: 20),
              child: GlobalWidgets.setButton(
                padding: EdgeInsets.only(right: 35, left: 35, top: 15, bottom: 15),
                onPressButton: () {
                  if (selectedGender == "None" || emailController.text.isEmpty) {
                    return Fluttertoast.showToast(msg: L10n.current.edit_profile_missing_info_error_message);
                  }
                  if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(emailController.text)) {
                    return Fluttertoast.showToast(msg: L10n.current.email_is_not_valid_error_message);
                  }
                  callProfileUpdateApi('');
                },
                textWidget: SizedBox(
                  width: 125,
                  child: GlobalWidgets.setText(
                    L10n.current.edit_profile_save_button_title,
                    textAlign: TextAlign.center,
                    fontSize: 16,
                    strTextColor: AppColors.strMainTextColorWhite,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            createUserDeleteButton(),
            Container(height: 50)
          ],
        ),
      ),
    );
  }

  Widget createUserDeleteButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(6.0),
      onTap: handleDeleteProfile,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: SizedBox(
          width: 160,
          child: GlobalWidgets.setText(
            L10n.current.edit_profile_delete_account_button_title,
            textAlign: TextAlign.center,
            fontSize: 16,
            strTextColor: AppColors.strMainTextColorWhite,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Future<void> handleDeleteProfile() async {
    globalWidget.showPopUpWithMessage(
      context: mainTabsScaffoldKey.currentContext ?? context,
      conditionButtonEnable: true,
      titleMessage: "ISEEY",
      message: L10n.current.delete_account_warning_message,
      onPressOKButton: () {
        _deleteAccountNavigateToLogin(scaffoldKey);
      },
    );
  }

  _deleteAccountNavigateToLogin(GlobalKey<ScaffoldState> scaffoldKey) async {
    HttpRequestModel req = new HttpRequestModel(
        url: 'users/deleteUser',
        method: RequestMethodType.DELETE,
        body: '',
        params: '',
        headerType: "json",
        authMethod: true);
    var response;
    try {
      var x = GlobalWidgets();
      x.showLoading(scaffoldKey.currentContext ?? context);

      response = await HttpService().init(req, scaffoldKey);

      Future.delayed(const Duration(milliseconds: 800), () {
        x.hideLoading();
        if (mounted) setState(() {});
      });

      print("response>>  ${response.toString()}");

      if (response is String && response != '') {
        var jsonRes = jsonDecode(response);
        int success = jsonRes["success"];

        if (success == 200) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.clear();
          prefs.setBool("isFromLogin", false);
          NotificationUtils().clearAllNotifications();

          Navigator.pushReplacement(
            mainTabsScaffoldKey.currentContext ?? context,
            SlideRightRoute(
              page: LoginScreen(),
              routeName: "/login",
            ),
          );
          if (mounted) {
            setState(() {});
          }
        } else {
          showSuccessOrFail(L10n.current.something_went_wrong, false, context);
        }
      } else {
        showSuccessOrFail(L10n.current.something_went_wrong, false, context);
      }
    } catch (e) {
      debugPrint("EXCEPTION $e");
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    prefs.setBool("isFromLogin", false);
    NotificationUtils().clearAllNotifications();

    Navigator.pushReplacement(
      mainTabsScaffoldKey.currentContext ?? context,
      SlideRightRoute(
        page: LoginScreen(),
        routeName: "/login",
      ),
    );
    if (mounted) {
      setState(() {});
    }
  }

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  setAccountInformation() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(5, 40, 5, 0),
              child: GlobalWidgets.setTextField(
                onTap: () {},
                controller: oldPasswordController,
                fontColor: AppColors.mainTextColorWhite,
                cursorColor: AppColors.mainBackgroundColorOrange,
                strPrefixAssetImageName: AssetsConstant.pwdIcon,
                txtFieldLabelText: L10n.current.edit_profile_old_password_text_field,
                txtFieldHintText: "",
                obscureText: true,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(5, 30, 5, 0),
              child: GlobalWidgets.setTextField(
                onTap: () {},
                controller: newPasswordController,
                fontColor: AppColors.mainTextColorWhite,
                cursorColor: AppColors.mainBackgroundColorOrange,
                strPrefixAssetImageName: AssetsConstant.pwdIcon,
                txtFieldLabelText: L10n.current.edit_profile_new_password_text_field,
                txtFieldHintText: "",
                obscureText: true,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(5, 30, 5, 0),
              child: GlobalWidgets.setTextField(
                onTap: () {},
                controller: confirmPasswordController,
                fontColor: AppColors.mainTextColorWhite,
                cursorColor: AppColors.mainBackgroundColorOrange,
                strPrefixAssetImageName: AssetsConstant.pwdIcon,
                txtFieldLabelText: L10n.current.edit_profile_confirm_password_text_field,
                txtFieldHintText: "",
                obscureText: true,
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(20, 45, 20, 0),
              child: GlobalWidgets.setButton(
                padding: EdgeInsets.only(right: 35, left: 35, top: 15, bottom: 15),
                onPressButton: () {
                  callChangePasswordApi();
                },
                textWidget: GlobalWidgets.setText(
                  L10n.current.edit_profile_save_button_title,
                  textAlign: TextAlign.center,
                  fontSize: 16,
                  strTextColor: AppColors.strMainTextColorWhite,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getActionSheet() {
    containerForSheet<String>(
      child: CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: GlobalWidgets.setText(
                L10n.current.image_picker_camera_option,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                strTextColor: AppColors.strMainBackgroundColorOrange,
              ),
              onPressed: () {
                imageCropPicker(ImageSource.camera);
                Navigator.of(context, rootNavigator: true).pop("Discard");
              },
            ),
            CupertinoActionSheetAction(
              child: GlobalWidgets.setText(
                L10n.current.image_picker_gallery_option,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                strTextColor: AppColors.strMainBackgroundColorOrange,
              ),
              onPressed: () {
                imageCropPicker(ImageSource.gallery);
                Navigator.of(context, rootNavigator: true).pop("Discard");
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: GlobalWidgets.setText(
              L10n.current.cancel_button_title,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              strTextColor: AppColors.strMainBackgroundColorOrange,
            ),
            isDefaultAction: true,
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop("Discard");
            },
          )),
    );
  }

  void containerForSheet<T>({required Widget child}) {
    showCupertinoModalPopup<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T? value) {
      if (value == "Camera") {
        imageCropPicker(ImageSource.camera);
      } else if (value == "Gallery") {
        imageCropPicker(ImageSource.gallery);
      }
    });
  }

  File? selectedImage;
  final picker = ImagePicker();
  String profileImage = '';
  bool isEditProfileImage = false;

  Future imageCropPicker(ImageSource imageSource) async {
    var image = await picker.pickImage(source: imageSource);
    if (image != null) {
      List<PlatformUiSettings> uiSettings = [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
        )
      ];

      var croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        maxWidth: 720,
        maxHeight: 720,
        compressQuality: 80,
        uiSettings: uiSettings,
      );

      File processedFile = File(croppedFile?.path ?? '');
      setState(() {
        profileImage = "";
        isEditProfileImage = true;
        selectedImage = processedFile;
      });
    }
  }

  callChangePasswordApi() async {
    if (newPasswordController.text != confirmPasswordController.text) {
      return globalWidget.showPopUpWithMessage(
        context: context,
        titleMessage: L10n.current.change_password_pop_up_title,
        message: L10n.current.change_password_pop_up_message,
        onPressOKButton: () {
          debugPrint("OK Pressed");
        },
      );
    }
    var data = new Map<String, dynamic>();
    data['old_password'] = oldPasswordController.text;
    data['password'] = newPasswordController.text;
    var body = json.encode(data);

    HttpRequestModel req = new HttpRequestModel(
        url: 'users/changePassword',
        method: RequestMethodType.POST,
        body: body,
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

        UserModel user = UserModel.fromJson(jsonRes);
        if (user.success == 200) {
          showSuccessOrFail(
            user.message,
            true,
            context,
            isTitleEnable: false,
          );
        } else {
          showSuccessOrFail(user.message, false, context);
        }
      } else {
        showSuccessOrFail(L10n.current.something_went_wrong, false, context);
      }
    } catch (e) {
      debugPrint("EXCEPTION $e");
    }
    x.hideLoading();
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

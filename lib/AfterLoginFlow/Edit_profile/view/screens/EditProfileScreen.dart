import 'dart:io';

import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iseey/AfterLoginFlow/Edit_profile/domain/Edit_profile_repository.dart';
import 'package:iseey/AfterLoginFlow/Edit_profile/view/widgets/account_information.dart';
import 'package:iseey/AfterLoginFlow/Edit_profile/view/widgets/basic_information_widget.dart';
import 'package:iseey/AuthFlow/domain/user_model/user_model.dart';
import 'package:iseey/AuthFlow/view/LoginScreen.dart';
import 'package:iseey/CustomTabbarController/CustomTabbarController.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/GlobalFiles/GlobalMethods.dart';
import 'package:iseey/GlobalFiles/GlobalVariables.dart';
import 'package:iseey/GlobalFiles/GlobalWidgets.dart';
import 'package:iseey/GlobalFiles/transitions/slide_route.dart';
import 'package:iseey/Services/assets_constant.dart';
import 'package:iseey/generated/l10n.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel? userModel;
  final bool isFromSignUp;
  final String? firstName;
  final String? lastName;
  final String? email;

  const EditProfileScreen({
    Key? key,
    this.userModel,
    this.isFromSignUp = false,
    this.firstName,
    this.lastName,
    this.email,
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

    if (widget.isFromSignUp) {
      firstNameController.text = widget.firstName ?? '';
      lastNameController.text = widget.lastName ?? '';
      emailController.text = widget.email ?? '';
    }

    _initData();
  }

  void _initData() async {
    await setUserData();
    await _setUserPosition();
  }

  Future<void> setUserData() async {
    final profileRepository = Provider.of<EditProfileRepository>(context, listen: false);
    final userInfo = await profileRepository.getUserData();

    setState(() {
      profileImgUrl = userInfo.image;
      fileImage = profileImgUrl;

      if (!widget.isFromSignUp) {
        firstNameController.text = userInfo.firstName;
        lastNameController.text = userInfo.lastName;
        emailController.text = userInfo.email;
      }

      selectedGender = userInfo.gender;
      descriptionController.text = userInfo.description;
      fbController.text = userInfo.facebookUrl ?? '';
      instaController.text = userInfo.instagramUrl ?? '';
      genderController.text = genderList[selectedGender == "M"
          ? 0
          : selectedGender == "F"
              ? 1
              : 2];

      if (userInfo.dob.isNotEmpty) {
        selectedDob = DateTime.fromMillisecondsSinceEpoch(int.parse(userInfo.dob));
        dobController.text = convertStringFromDate(date: selectedDob, dateWantInFormat: "dd-MM-yyyy");
      } else {
        dobController.text = "";
      }
    });
  }

  Future<void> _setUserPosition() async {
    final position = await Geolocator.getCurrentPosition();
    setState(() => currentPosition = position);
  }

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController fbController = TextEditingController();
  TextEditingController instaController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  File? selectedImage;
  final picker = ImagePicker();
  String fileImage = '';
  bool isEditfileImage = false;

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
        fileImage = "";
        isEditfileImage = true;
        selectedImage = processedFile;
      });
    }
  }

  void _navigateToOnBoardingScreen() {
    Navigator.push(
      context,
      SlideLeftRoute(
        page: CustomTabBarController(),
        routeName: "/tabBarController",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileRepository = Provider.of<EditProfileRepository>(context);

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
                        child: BasicInformationWidget(
                          profileRepository: profileRepository,
                          firstNameController: firstNameController,
                          lastNameController: lastNameController,
                          emailController: emailController,
                          genderController: genderController,
                          dobController: dobController,
                          descriptionController: descriptionController,
                          fbController: fbController,
                          instaController: instaController,
                          selectedGender: selectedGender,
                          selectedDob: selectedDob,
                          currentPosition: currentPosition,
                          onSavePressed: () async {
                            if (selectedGender.isEmpty || emailController.text.isEmpty) {
                              Fluttertoast.showToast(msg: L10n.current.edit_profile_missing_info_error_message);
                              return;
                            }
                            if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(emailController.text)) {
                              Fluttertoast.showToast(msg: L10n.current.email_is_not_valid_error_message);
                              return;
                            }

                            try {
                              await profileRepository.updateProfile(
                                firstName: firstNameController.text,
                                lastName: lastNameController.text,
                                imageFile: selectedImage,
                                email: emailController.text,
                                gender: selectedGender,
                                dob: selectedDob.millisecondsSinceEpoch.toString(),
                                description: descriptionController.text,
                                facebookUrl: fbController.text.isEmpty ? null : fbController.text,
                                instagramUrl: instaController.text.isEmpty ? null : instaController.text,
                                lat: currentPosition?.latitude,
                                lng: currentPosition?.longitude,
                                scaffoldKey: scaffoldKey,
                              );
                              await setUserData();
                              setState(() {});
                              Fluttertoast.showToast(msg: "Profile updated successfully");
                              _navigateToOnBoardingScreen();
                            } catch (e) {
                              Fluttertoast.showToast(msg: "Error: $e");
                            }
                          },
                          onDeleteAccountPressed: () async {
                            try {
                              await profileRepository.deleteAccount(scaffoldKey);
                              Fluttertoast.showToast(msg: "Account deleted successfully");
                              Navigator.pushReplacement(
                                context,
                                SlideRightRoute(
                                  page: LoginScreen(),
                                  routeName: "/login",
                                ),
                              );
                            } catch (e) {
                              Fluttertoast.showToast(msg: "Error: $e");
                            }
                          },
                          onImagePickerPressed: () => imageCropPicker(ImageSource.gallery),
                          onGenderChanged: (value) {
                            setState(() {
                              selectedGender = value;
                            });
                          },
                          onDateSelected: (value) {
                            setState(() {
                              selectedDob = value;
                              dobController.text = convertStringFromDate(date: value, dateWantInFormat: "dd-MM-yyyy");
                            });
                          },
                          fileImage: fileImage,
                          selectedImage: selectedImage,
                        ),
                      )
                    : Flexible(
                        child: AccountInformation(
                          oldPasswordController: oldPasswordController,
                          newPasswordController: newPasswordController,
                          confirmPasswordController: confirmPasswordController,
                          scaffoldKey: scaffoldKey,
                          profileRepository: profileRepository,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

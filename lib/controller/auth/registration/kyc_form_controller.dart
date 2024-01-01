import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:qrpay/controller/auth/registration/registration_controller.dart';

import '../../../backend/local_storage/local_storage.dart';
import '../../../backend/model/auth/registation/basic_data_model.dart';
import '../../../backend/model/auth/registation/registration_with_kyc_model.dart';
import '../../../backend/services/api_services.dart';
import '../../../backend/utils/logger.dart';
import '../../../routes/routes.dart';
import '../../../utils/custom_color.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/size.dart';
import '../../../widgets/inputs/primary_input_filed.dart';
import '../../../widgets/others/update_kyc_widget/kyc_image_widget.dart';
import '../../../widgets/text_labels/title_heading4_widget.dart';

final log = logger(BasicDataController);

class BasicDataController extends GetxController {
  //todo keyc from field
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final countryCodeController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final zipCodeController = TextEditingController();
  final frontPartController = TextEditingController();
  final backPartController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    countryCodeController.dispose();
    cityController.dispose();
    zipCodeController.dispose();
    frontPartController.dispose();
    backPartController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    inputFieldControllers.clear();
    super.dispose();
  }

  //todo import controller
  final controller = Get.put(RegistrationController());

  //todo value
  RxString countryCode = LocalStorage.getCountryCode()!.obs;
  RxString countryName = "".obs;
  RxBool termsAndCondition = false.obs;

  List<TextEditingController> inputFieldControllers = [];
  List<String> listImagePath = [];
  List<String> listFieldName = [];
  String translatedFieldName = '';

  RxList inputFileFields = [].obs;
  RxList inputFields = [].obs;
  RxBool hasFile = false.obs;

  @override
  void onInit() {
    countryCodeController.text = LocalStorage.getCountry()!;
    countryController.text = LocalStorage.getCountry()!;
    getBasicData();
    super.onInit();
  }

  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  late BasicDataModel _basicDataModel;

  BasicDataModel get basicDataModel => _basicDataModel;

  Future<BasicDataModel> getBasicData() async {
    inputFields.clear();
    inputFieldControllers.clear();
    _isLoading.value = true;
    update();

    await ApiServices.basicData().then((value) {
      _basicDataModel = value!;
      final data = _basicDataModel.data.registerKycFields.fields;
      LocalStorage.saveEmailVerification(
          isEmailVerification: _basicDataModel.data.emailVerification);
      LocalStorage.saveKycVerification(
          isKycVerification: _basicDataModel.data.kycVerification);

      LocalStorage.saveCountryCode(
          countryCodeValue:
              _basicDataModel.data.countries.first.mobileCode.toString());
      LocalStorage.saveCountry(
          countryValue: _basicDataModel.data.countries.first.name.toString());
      countryController.text =
          _basicDataModel.data.countries.first.name.toString();

      if (LocalStorage.isKycVerification()) {
        for (int item = 0; item < data.length; item++) {
          // make the dynamic controller
          var textEditingController = TextEditingController();
          inputFieldControllers.add(textEditingController);

          // make dynamic input widget
          if (data[item].type.contains('file')) {
            hasFile.value = true;
            inputFileFields.add(
              Column(
                crossAxisAlignment: crossStart,
                children: [
                  TitleHeading4Widget(
                    text: data[item].label,
                    textAlign: TextAlign.left,
                    color: CustomColor.primaryLightTextColor,
                    fontSize: Dimensions.headingTextSize3,
                    fontWeight: FontWeight.w600,
                  ),
                  verticalSpace(Dimensions.heightSize),
                  KycImageWidget(
                    labelName: data[item].label,
                    fieldName: data[item].name,
                  ),
                ],
              ),
            );
          } else if (data[item].type.contains('text') ||
              data[item].type.contains('textarea')) {
            inputFields.add(
              Column(
                children: [
                  verticalSpace(Dimensions.heightSize),
                  PrimaryInputWidget(
                    paddings: EdgeInsets.only(
                      left: Dimensions.widthSize,
                      right: Dimensions.widthSize,
                      bottom: Dimensions.heightSize,
                    ),
                    controller: inputFieldControllers[item],
                    hint: data[item].label,
                    isValidator: data[item].required,
                    label: data[item].label,
                  ),
                ],
              ),
            );
          }
        }
      }

      _isLoading.value = false;
      update();
    }).catchError(
      (onError) {
        log.e(onError);
      },
    );
    update();
    return _basicDataModel;
  }

  //

  late RegistrationWithKycModel _registrationModel;

  RegistrationWithKycModel get registrationModel => _registrationModel;

  Future<RegistrationWithKycModel> registrationProcess() async {
    _isLoading.value = true;
    String isAgree = '';
    if (termsAndCondition.value) {
      isAgree = '1';
    } else {
      isAgree = '';
    }
    Map<String, String> inputBody = {
      'firstname': firstNameController.text,
      'lastname': lastNameController.text,
      'email': controller.emailController.text,
      'phone_code': countryCode.value,
      'phone': phoneNumberController.text,
      'country': countryController.text,
      'city': cityController.text,
      'zip_code': zipCodeController.text,
      'password': passwordController.text,
      'password_confirmation': confirmPasswordController.text,
      'agree': isAgree.toString(),
    };
    final data = _basicDataModel.data.registerKycFields.fields;

    for (int i = 0; i < data.length; i += 1) {
      if (data[i].type != 'file') {
        inputBody[data[i].name] = inputFieldControllers[i].text;
      }
    }

    await ApiServices.registrationApi(
            body: inputBody, fieldList: listFieldName, pathList: listImagePath)
        .then((value) {
      _registrationModel = value!;
      _isLoading.value = false;
      update();

      _goToSavedUser(_registrationModel);
    }).catchError((onError) {
      log.e(onError);
    });
    _isLoading.value = false;
    update();
    return _registrationModel;
  }

  _goToSavedUser(RegistrationWithKycModel loginModel) {
    LocalStorage.saveToken(token: loginModel.data.token.toString());
    LocalStorage.isLoginSuccess(isLoggedIn: true);
    LocalStorage.isLoggedIn();
    update();
    _goToDashboardScreen();
  }

  _goToDashboardScreen() {
    Get.offAndToNamed(Routes.waitForApprovalScreen);
  }

  updateImageData(String fieldName, String imagePath) {
    if (listFieldName.contains(fieldName)) {
      int itemIndex = listFieldName.indexOf(fieldName);
      listImagePath[itemIndex] = imagePath;
    } else {
      listFieldName.add(fieldName);
      listImagePath.add(imagePath);
    }
    update();
  }

  String? getImagePath(String fieldName) {
    if (listFieldName.contains(fieldName)) {
      int itemIndex = listFieldName.indexOf(fieldName);
      return listImagePath[itemIndex];
    }
    return null;
  }
}

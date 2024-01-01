import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qrpay/backend/utils/custom_loading_api.dart';
import 'package:qrpay/custom_assets/assets.gen.dart';
import 'package:qrpay/utils/responsive_layout.dart';
import 'package:qrpay/utils/size.dart';
import 'package:qrpay/utils/strings.dart';
import 'package:qrpay/views/others/custom_image_widget.dart';
import 'package:qrpay/widgets/buttons/custom_text_button.dart';
import 'package:qrpay/widgets/buttons/primary_button.dart';
import 'package:qrpay/widgets/others/glass_widget.dart';
import 'package:qrpay/widgets/text_labels/title_heading2_widget.dart';
import 'package:qrpay/widgets/text_labels/title_heading4_widget.dart';

import '../../../backend/local_storage/local_storage.dart';
import '../../../controller/auth/login/signin_controller.dart';
import '../../../controller/fingerprint/fingerprint_controller.dart';
import '../../../routes/routes.dart';
import '../../../utils/custom_color.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/inputs/password_input_widget.dart';
import '../../../widgets/inputs/primary_input_filed.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final controller = Get.put(SignInController());

  final phoneNumberFormKey = GlobalKey<FormState>();

  final signInFormKey = GlobalKey<FormState>();

  final forgotPasswordFormKey = GlobalKey<FormState>();

  final fingerprintController = Get.put(FingerprintController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        body: _bodyWidget(context),
      ),
    );
  }

  _bodyWidget(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSize * 0.05,
      ),
      physics: const BouncingScrollPhysics(),
      child: SizedBox(
        height: height,
        width: width,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            _logoWidget(
              context,
              logoHeight: height * 0.27,
            ),
            _bottomContainerWidget(
              context,
              height: height * 0.73,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  _titleAndSubtitleWidget(context),
                  _inputAndForgotWidget(context),
                  _buttonWidget(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _logoWidget(BuildContext context, {required double logoHeight}) {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.marginSizeVertical * 1.2),
      height: logoHeight,
      padding: EdgeInsets.only(
        top: Dimensions.paddingSize * 3,
        bottom: Dimensions.paddingSize * 1.5,
      ),
      child: Center(
        child: CustomImageWidget(
          path: Assets.logo.logo.path,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.1,
        ),
      ),
    );
  }

  _bottomContainerWidget(BuildContext context,
      {required Widget child, required double height}) {
    Radius borderRadius = const Radius.circular(20);
    return Container(
        height: height,
        margin: EdgeInsets.symmetric(
            horizontal: Dimensions.marginSizeHorizontal * 0.5),
        decoration: BoxDecoration(
          color: CustomColor.whiteColor,
          borderRadius:
              BorderRadius.only(topLeft: borderRadius, topRight: borderRadius),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.015),
              spreadRadius: 7,
              blurRadius: 5,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        padding: EdgeInsets.all(Dimensions.paddingSize),
        child: child);
  }

  _titleAndSubtitleWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Dimensions.marginSizeVertical * 0.5,
      ),
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
          TitleHeading2Widget(text: "Log In To Mobile Wallet"),
          // verticalSpace(
          //   Dimensions.heightSize * 0.5,
          // ),
          // TitleHeading4Widget(
          //   text: Strings.signInInformationSubtitle.tr,
          // ),
        ],
      ),
    );
  }

  _inputAndForgotWidget(BuildContext context) {
    return Form(
      key: signInFormKey,
      child: Column(
        crossAxisAlignment: crossEnd,
        children: [
          verticalSpace(Dimensions.heightSize),
          PrimaryInputWidget(
            controller: controller.emailController,
            hint: Strings.enterEmailAddress.tr,
            label: Strings.emailAddress.tr,
          ),
          verticalSpace(
            Dimensions.heightSize * 0.7,
          ),
          PasswordInputWidget(
            controller: controller.passwordController,
            hint: "Pin",
            label: "Pin",
          ),
          verticalSpace(
            Dimensions.heightSize * 0.3,
          ),
          InkWell(
            onTap: () => _openDialogue(context),
            child: TitleHeading4Widget(
              fontWeight: FontWeight.w600,
              fontSize: Dimensions.headingTextSize5,
              color: CustomColor.primaryTextColor,
              text: Strings.forgotPassword.tr,
            ),
          ),
        ],
      ),
    );
  }

  _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: Dimensions.marginSizeVertical,
        bottom: Dimensions.marginSizeVertical,
      ),
      child: Column(
        mainAxisAlignment: mainCenter,
        children: [
          Obx(
            () => controller.isLoading
                ? const CustomLoadingAPI()
                : PrimaryButton(
                    title: Strings.signIn.tr,
                    onPressed: () {
                      if (signInFormKey.currentState!.validate()) {
                        controller.loginProcess();
                      }
                    },
                    buttonTextColor: CustomColor.whiteColor,
                  ),
          ),
          verticalSpace(Dimensions.heightSize),
          Visibility(
            visible:
                fingerprintController.supportState == SupportState.supported &&
                    LocalStorage.isLoggedIn(),
            child: PrimaryButton(
              title: Strings.signInWithTouchId.tr,
              onPressed: () async {
                bool isAuthenticated =
                    await Authentication.authenticateWithBiometrics();

                if (isAuthenticated) {
                  Get.offAndToNamed(Routes.bottomNavBarScreen);
                } else {
                  debugPrint('isAuthenticated : false');
                }
              },
              buttonTextColor: CustomColor.whiteColor,
            ),
          ),
          verticalSpace(Dimensions.heightSize * 3.5),
          RichText(
            text: TextSpan(
              text: Strings.haveAccount.tr,
              style: GoogleFonts.inter(
                fontSize: Dimensions.headingTextSize5,
                color: CustomColor.primaryTextColor.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
              children: [
                WidgetSpan(
                  child: CustomTextButton(
                    onPressed: () {
                      controller.onPressedSignUP();
                    },
                    text: Strings.richSignUp.tr,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _openDialogue(
    BuildContext context,
  ) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              backgroundColor: Colors.transparent,
              alignment: Alignment.center,
              insetPadding: EdgeInsets.all(Dimensions.paddingSize * 0.3),
              contentPadding: EdgeInsets.zero,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              content: Builder(
                builder: (context) {
                  var width = MediaQuery.of(context).size.width;
                  return Stack(
                    children: [
                      Container(
                        width: width * 0.84,
                        margin: EdgeInsets.all(Dimensions.paddingSize * 0.5),
                        padding: EdgeInsets.all(Dimensions.paddingSize * 0.9),
                        decoration: BoxDecoration(
                          color: CustomColor.whiteColor,
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius * 1.4),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: crossStart,
                          children: [
                            SizedBox(height: Dimensions.heightSize * 2),
                            TitleHeading2Widget(
                                text: Strings.forgotPasswordTitle.tr),
                            verticalSpace(Dimensions.heightSize * 0.5),
                            TitleHeading4Widget(
                                text: Strings.pleaseEnterYourRegister.tr),
                            SizedBox(height: Dimensions.heightSize * 1),
                            Form(
                              key: forgotPasswordFormKey,
                              child: PrimaryInputWidget(
                                controller: controller.emailForgotController,
                                hint: Strings.enterEmailAddress.tr,
                                label: Strings.emailAddress.tr,
                              ),
                            ),
                            verticalSpace(Dimensions.heightSize * 0.5),
                            Obx(
                              () => controller.isLoading2
                                  ? const CustomLoadingAPI()
                                  : PrimaryButton(
                                      title: Strings.forgetPassword.tr,
                                      onPressed: () {
                                        if (forgotPasswordFormKey.currentState!
                                            .validate()) {
                                          controller
                                              .goToForgotEmailVerification();
                                        }
                                      },
                                      borderColor:
                                          Theme.of(context).primaryColor,
                                    ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: const Icon(
                                Icons.close,
                                color: CustomColor.whiteColor,
                              ),
                            )),
                      ),
                    ],
                  );
                },
              ),
            ).customGlassWidget(
              blurY: 1,
              blurX: 1,
            ));
  }
}

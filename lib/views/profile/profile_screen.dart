import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/backend/utils/custom_loading_api.dart';
import 'package:qrpay/controller/profile/update_profile_controller.dart';
import 'package:qrpay/utils/dimensions.dart';
import 'package:qrpay/utils/responsive_layout.dart';
import 'package:qrpay/utils/size.dart';
import 'package:qrpay/utils/strings.dart';
import 'package:qrpay/widgets/appbar/appbar_widget.dart';

import '../../backend/services/api_endpoint.dart';
import '../../custom_assets/assets.gen.dart';
import '../../routes/routes.dart';
import '../../utils/custom_color.dart';
import '../../widgets/others/profile_row_widget.dart';
import '../../widgets/text_labels/title_heading1_widget.dart';
import '../../widgets/text_labels/title_heading4_widget.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final controller = Get.put(UpdateProfileController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: AppBarWidget(
          text: Strings.profile.tr,
        ),
        body: Obx(
          () => controller.isLoading
              ? const CustomLoadingAPI()
              : _bodyWidget(context),
        ),
      ),
    );
  }

  _bodyWidget(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        _userImageText(context),
        _tileWidget(context),
      ],
    );
  }

  _userImageText(BuildContext context) {
    var data = controller.profileModel.data;

    final image =
        '${ApiEndpoint.mainDomain}/${data.imagePath}/${data.user.image}';
    final defaultImage =
        '${ApiEndpoint.mainDomain}/${data.imagePath}/${data.defaultImage}';
    return Column(
      mainAxisAlignment: mainCenter,
      children: [
        Center(
          child: Container(
            margin: EdgeInsets.only(
              top: Dimensions.paddingSize,
              bottom: Dimensions.paddingSize,
            ),
            height: Dimensions.heightSize * 8.3,
            width: Dimensions.widthSize * 11.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radius * 1.5),
              color: Theme.of(context).primaryColor,
              border:
                  Border.all(color: Theme.of(context).primaryColor, width: 5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radius),
              child: FadeInImage(
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
                image: NetworkImage(
                    data.imagePath.isNotEmpty ? image : defaultImage),
                placeholder: AssetImage(
                  Assets.clipart.user.path,
                ),
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    Assets.clipart.user.path,
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
        ),
        TitleHeading1Widget(
          text: data.user.username,
          fontSize: 22,
        ),
        TitleHeading4Widget(
          text: data.user.email,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).primaryColor,
          fontSize: Dimensions.headingTextSize3,
        ),
        verticalSpace(Dimensions.heightSize * 2)
      ],
    );
  }

  _tileWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: crossStart,
      children: [
        //!my_wallet
        Visibility(
          visible: false,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.75,
            padding: EdgeInsets.all(Dimensions.paddingSize * 0.4),
            decoration: BoxDecoration(
                color: controller.myWallet.value
                    ? Theme.of(context).primaryColor
                    : CustomColor.primaryLightScaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(Dimensions.radius * 10),
                  bottomRight: Radius.circular(Dimensions.radius * 10),
                )),
            child: InkWell(
              onTap: (() {
                controller.myWallet.value = true;
                Timer(const Duration(milliseconds: 10), () {
                  controller.myWallet.value = false;
                  Get.toNamed(Routes.myWalletScreen);
                });
              }),
              child: Padding(
                padding: EdgeInsets.only(left: Dimensions.paddingSize * 1.3),
                child: TileWidget(
                  iconColor: controller.myWallet.value
                      ? CustomColor.whiteColor
                      : Theme.of(context).primaryColor,
                  textColor: controller.myWallet.value
                      ? CustomColor.whiteColor
                      : Theme.of(context).primaryColor,
                  icon: Assets.icon.myWallet,
                  text: Strings.myWallet,
                ),
              ),
            ),
          ),
        ),

        //!update_profile
        Container(
          width: MediaQuery.of(context).size.width * 0.75,
          padding: EdgeInsets.all(Dimensions.paddingSize * 0.4),
          decoration: BoxDecoration(
              color: controller.updateProfile.value
                  ? Theme.of(context).primaryColor
                  : CustomColor.primaryLightScaffoldBackgroundColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(Dimensions.radius * 10),
                bottomRight: Radius.circular(Dimensions.radius * 10),
              )),
          child: InkWell(
            onTap: (() {
              controller.updateProfile.value = true;
              Timer(const Duration(milliseconds: 10), () {
                controller.updateProfile.value = false;
                Get.toNamed(Routes.updateProfileScreen);
              });
            }),
            child: Padding(
              padding: EdgeInsets.only(left: Dimensions.paddingSize * 1.3),
              child: TileWidget(
                iconColor: controller.updateProfile.value
                    ? CustomColor.whiteColor
                    : Theme.of(context).primaryColor,
                textColor: controller.updateProfile.value
                    ? CustomColor.whiteColor
                    : CustomColor.primaryTextColor,
                icon: Assets.icon.profile,
                text: Strings.updateProfile,
              ),
            ),
          ),
        ),

        //!update_Kyc_From
        Container(
          width: MediaQuery.of(context).size.width * 0.75,
          padding: EdgeInsets.all(Dimensions.paddingSize * 0.4),
          decoration: BoxDecoration(
              color: controller.updateKYCFrom.value
                  ? Theme.of(context).primaryColor
                  : CustomColor.primaryLightScaffoldBackgroundColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(Dimensions.radius * 10),
                bottomRight: Radius.circular(Dimensions.radius * 10),
              )),
          child: InkWell(
            onTap: (() {
              controller.updateKYCFrom.value = true;
              Timer(const Duration(milliseconds: 10), () {
                controller.updateKYCFrom.value = false;
                Get.toNamed(Routes.updateKycScreen);
              });
            }),
            child: Padding(
              padding: EdgeInsets.only(left: Dimensions.paddingSize * 1.3),
              child: TileWidget(
                iconColor: controller.updateKYCFrom.value
                    ? CustomColor.whiteColor
                    : Theme.of(context).primaryColor,
                textColor: controller.updateKYCFrom.value
                    ? CustomColor.whiteColor
                    : CustomColor.primaryTextColor,
                icon: Assets.icon.kycUpdate,
                text: Strings.updateKYC,
              ),
            ),
          ),
        ),

        //!two_fa_secuirity
        Container(
          width: MediaQuery.of(context).size.width * 0.75,
          padding: EdgeInsets.all(Dimensions.paddingSize * 0.4),
          decoration: BoxDecoration(
              color: controller.fASecurity.value
                  ? Theme.of(context).primaryColor
                  : CustomColor.primaryLightScaffoldBackgroundColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(Dimensions.radius * 10),
                bottomRight: Radius.circular(Dimensions.radius * 10),
              )),
          child: InkWell(
            onTap: (() {
              controller.fASecurity.value = true;
              Timer(const Duration(milliseconds: 10), () {
                controller.fASecurity.value = false;
                Get.toNamed(Routes.enable2FaScreen);
              });
            }),
            child: Padding(
              padding: EdgeInsets.only(left: Dimensions.paddingSize * 1.3),
              child: TileWidget(
                iconColor: controller.fASecurity.value
                    ? CustomColor.whiteColor
                    : Theme.of(context).primaryColor,
                textColor: controller.fASecurity.value
                    ? CustomColor.whiteColor
                    : CustomColor.primaryTextColor,
                icon: Assets.icon.twoFa,
                text: Strings.fA2Security,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

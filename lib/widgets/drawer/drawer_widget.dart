import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/backend/local_storage/local_storage.dart';
import 'package:qrpay/backend/utils/custom_loading_api.dart';
import 'package:qrpay/routes/routes.dart';
import 'package:qrpay/utils/strings.dart';

import '../../backend/services/api_endpoint.dart';
import '../../controller/others/log_out_controller.dart';
import '../../controller/profile/update_profile_controller.dart';
import '../../custom_assets/assets.gen.dart';
import '../../utils/custom_color.dart';
import '../../utils/dimensions.dart';
import '../../utils/drawer_utils.dart';
import '../../utils/size.dart';
import '../../views/others/custom_image_widget.dart';
import '../buttons/primary_button.dart';
import '../text_labels/title_heading2_widget.dart';
import '../text_labels/title_heading3_widget.dart';
import '../text_labels/title_heading4_widget.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({Key? key}) : super(key: key);
  final controller = Get.put(UpdateProfileController());
  final logOutController = Get.put(LogOutController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        width: MediaQuery.of(context).size.width / 1.34,
        shape: Platform.isAndroid
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                topRight: Radius.circular(
                  Dimensions.radius * 2,
                ),
              ))
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                topRight: Radius.circular(
                  Dimensions.radius * 2,
                ),
                bottomRight: Radius.circular(
                  Dimensions.radius * 2,
                ),
              )),
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        child: controller.isLoading
            ? const CustomLoadingAPI()
            : ListView(
                children: [
                  _userImgWidget(context),
                  _userTextwidget(context),
                  _drawerWidget(context),
                ],
              ),
      ),
    );
  }

  _userImgWidget(BuildContext context) {
    var data = controller.profileModel.data;

    final image =
        '${ApiEndpoint.mainDomain}/${data.imagePath}/${data.user.image}';
    final defaultImage =
        '${ApiEndpoint.mainDomain}/${data.imagePath}/${data.defaultImage}';
    return Center(
      child: Container(
        margin: EdgeInsets.only(
          top: Dimensions.paddingSize,
          bottom: Dimensions.paddingSize,
        ),
        height: Dimensions.heightSize * 8.3,
        width: Dimensions.widthSize * 11.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius * 1.5),
          color: Colors.transparent,
          border: Border.all(color: Theme.of(context).primaryColor, width: 5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radius),
          child: FadeInImage(
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
            image:
                NetworkImage(data.user.image.isNotEmpty ? image : defaultImage),
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
    );
  }

  _userTextwidget(BuildContext context) {
    var data = controller.profileModel.data;
    return Column(
      children: [
        TitleHeading3Widget(
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

  _drawerWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: crossStart,
      mainAxisAlignment: mainCenter,
      children: [
        ...DrawerUtils.items.map((item) {
          return _drawerTileWidget(
            item['icon'],
            item['title'],
            onTap: () => Get.toNamed(
              '${item['route']}',
            ),
          );
        }),
        Obx(
          () => logOutController.isLoading
              ? const CustomLoadingAPI()
              : InkWell(
                  onTap: () {
                    _logOutDialogueWidget(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSize * 1,
                      vertical: Dimensions.paddingSize * 0.2,
                    ),
                    child: Row(
                      crossAxisAlignment: crossStart,
                      mainAxisAlignment: mainStart,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: Dimensions.heightSize * 2.5,
                          width: Dimensions.widthSize * 3.3,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radius * 0.7),
                            color: CustomColor.whiteColor.withOpacity(0.2),
                          ),
                          child: CustomImageWidget(
                            path: Assets.icon.signout,
                            height: 32,
                            width: 32,
                          ),
                        ),
                        horizontalSpace(Dimensions.widthSize),
                        Padding(
                          padding: EdgeInsets.only(
                              top: Dimensions.paddingSize * 0.32),
                          child: const TitleHeading3Widget(
                            text: Strings.signOut,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  _drawerTileWidget(icon, title, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSize * 1,
          vertical: Dimensions.paddingSize * 0.2,
        ),
        child: Row(
          crossAxisAlignment: crossStart,
          mainAxisAlignment: mainStart,
          children: [
            Container(
              alignment: Alignment.center,
              height: Dimensions.heightSize * 2.5,
              width: Dimensions.widthSize * 3.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius * 0.7),
                color: CustomColor.whiteColor.withOpacity(0.2),
              ),
              child: CustomImageWidget(
                path: icon,
                height: 32,
                width: 32,
              ),
            ),
            horizontalSpace(Dimensions.widthSize),
            Padding(
              padding: EdgeInsets.only(top: Dimensions.paddingSize * 0.32),
              child: TitleHeading3Widget(
                text: title,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _logOutDialogueWidget(
    BuildContext context,
  ) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            alignment: Alignment.center,
            insetPadding: EdgeInsets.all(Dimensions.paddingSize * 0.3),
            contentPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: Builder(
              builder: (context) {
                var width = MediaQuery.of(context).size.width;
                return Container(
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
                    crossAxisAlignment: crossCenter,
                    children: [
                      SizedBox(height: Dimensions.heightSize * 2),
                      TitleHeading2Widget(text: Strings.signOut.tr),
                      verticalSpace(Dimensions.heightSize * 1),
                      TitleHeading4Widget(text: Strings.logMessage.tr),
                      verticalSpace(Dimensions.heightSize * 1),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * .25,
                              child: PrimaryButton(
                                title: Strings.cancel.tr,
                                onPressed: () {
                                  Get.back();
                                },
                                borderColor: CustomColor.blackColor,
                                buttonColor: CustomColor.blackColor,
                              ),
                            ),
                          ),
                          horizontalSpace(Dimensions.widthSize),
                          Expanded(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * .25,
                              child: PrimaryButton(
                                title: Strings.signOut.tr,
                                onPressed: () {
                                  logOutController.logOutProcess();
                                  Get.back();
                                  LocalStorage.logout();
                                  Get.offNamedUntil(
                                      Routes.signInScreen, (route) => false);
                                },
                                borderColor: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        });
  }
}

import 'package:qrpay/controller/navbar/navbar_controller.dart';
import 'package:qrpay/custom_assets/assets.gen.dart';
import 'package:qrpay/routes/routes.dart';
import 'package:qrpay/views/others/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/custom_color.dart';
import '../../utils/dimensions.dart';
import '../../utils/strings.dart';
import '../../widgets/bottom_navbar/bottom_navber.dart';

import '../../widgets/drawer/drawer_widget.dart';
import '../../widgets/text_labels/title_heading4_widget.dart';

class BottomNavBarScreen extends StatelessWidget {
  final bottomNavBarController = Get.put(NavbarController(), permanent: false);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  BottomNavBarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        drawer: CustomDrawer(),
        key: scaffoldKey,
        appBar: appbarWidget(context),
        extendBody: true,
        backgroundColor: Theme.of(context).primaryColor,
        bottomNavigationBar:
            buildBottomNavigationMenu(context, bottomNavBarController),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: bottomNavBarController
            .page[bottomNavBarController.selectedIndex.value],
      ),
    );
  }

  appbarWidget(BuildContext context) {
    return AppBar(
      backgroundColor: bottomNavBarController.selectedIndex.value == 0
          ? Theme.of(context).primaryColor
          : CustomColor.primaryLightScaffoldBackgroundColor,
      elevation: bottomNavBarController.selectedIndex.value == 0 ? 0 : 0,
      centerTitle:
          bottomNavBarController.selectedIndex.value == 0 ? true : false,
      leading: bottomNavBarController.selectedIndex.value == 0
          ? GestureDetector(
              onTap: () {
                scaffoldKey.currentState!.openDrawer();
              },
              child: Padding(
                  padding: EdgeInsets.only(
                      left: Dimensions.paddingSize,
                      right: Dimensions.paddingSize * 0.2),
                  child: CustomImageWidget(
                    path: Assets.icon.drawerMenu,
                    height: 17,
                    width: 17,
                    color: CustomColor.whiteColor,
                  )),
            )
          : Container(),
      title: bottomNavBarController.selectedIndex.value == 0
          ? Padding(
              padding: EdgeInsets.all(Dimensions.paddingSize * 1.2),
              child: TitleHeading4Widget(
                  text: Strings.appName.toUpperCase(),
                  fontWeight: FontWeight.w500,
                  color: CustomColor.whiteColor,
                  fontSize: 24),
            )
          : Container(
              padding: EdgeInsets.only(left: Dimensions.paddingSize),
              child: TitleHeading4Widget(
                text: Strings.notification,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w500,
                fontSize: 24,
                color: Theme.of(context).primaryColor,
              ),
            ),
      actions: [
        bottomNavBarController.selectedIndex.value == 0
            ? Padding(
                padding: EdgeInsets.only(right: Dimensions.paddingSize * 0.6),
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.profileScreen);
                  },
                  child: CustomImageWidget(
                    path: Assets.icon.profile,
                    height: 28,
                    width: 28,
                    color: CustomColor.whiteColor,
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}

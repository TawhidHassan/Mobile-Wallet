import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/utils/custom_color.dart';
import 'package:qrpay/utils/custom_style.dart';

import 'back_button.dart';

class AppBarWidget extends AppBar {
  final String text;
  final VoidCallback? onTapLeading;
  final VoidCallback? onTapAction;
  final bool homeButtonShow;
  final IconData? actionIcon;

  AppBarWidget(
      {required this.text,
      this.onTapLeading,
      this.onTapAction,
      this.homeButtonShow = false,
      this.actionIcon,
      super.key})
      : super(
          title: Text(
            text,
            style: CustomStyle.darkHeading4TextStyle.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: CustomColor.primaryLightColor,
            ),
          ),
          elevation: 0,
          backgroundColor: CustomColor.primaryLightScaffoldBackgroundColor,
          actions: [
            Visibility(
              visible: homeButtonShow,
              child: IconButton(
                  onPressed: onTapAction,
                  icon: Icon(
                    actionIcon ?? Icons.home,
                    color: CustomColor.primaryLightColor,
                  )),
            )
          ],
          leading: BackButtonWidget(
            onTap: onTapLeading ??
                () {
                  Get.back();
                },
          ),
        );
}

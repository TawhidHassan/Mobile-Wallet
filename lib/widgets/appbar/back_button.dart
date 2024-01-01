import 'package:qrpay/custom_assets/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/dimensions.dart';
import '../../views/others/custom_image_widget.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({Key? key, this.onTap}) : super(key: key);

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: Dimensions.paddingSize * 0.6,
          top: Dimensions.paddingSize * 0.6,
          bottom: Dimensions.paddingSize * 0.6),
      child: GestureDetector(
        onTap: onTap ??
            () {
              Get.back();
            },
        child: CustomImageWidget(
          path: Assets.icon.backward,
          height: Dimensions.heightSize * 2,
          width: Dimensions.widthSize * 2.2,
          // color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:qrpay/utils/custom_style.dart';
import 'package:qrpay/utils/strings.dart';

import '../../../utils/custom_color.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/size.dart';
import '../../text_labels/custom_title_heading_widget.dart';

extension PreviewAmount on Widget {
  Widget previewAmount({
    required amount,
  }) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
          color: CustomColor.whiteColor,
          borderRadius: BorderRadius.circular(Dimensions.radius * 1.5)),
      margin:
          EdgeInsets.symmetric(vertical: Dimensions.marginSizeVertical * 0.2),
      child: Column(
        mainAxisAlignment: mainCenter,
        children: [
          CustomTitleHeadingWidget(
            text: amount,
            textAlign: TextAlign.center,
            style: CustomStyle.darkHeading1TextStyle.copyWith(
              fontSize: Dimensions.headingTextSize4 * 2,
              fontWeight: FontWeight.w800,
              color: CustomColor.primaryLightColor,
            ),
          ),
          CustomTitleHeadingWidget(
              text: Strings.enteredAmount,
              textAlign: TextAlign.center,
              style: CustomStyle.darkHeading4TextStyle),
        ],
      ),
    );
  }
}

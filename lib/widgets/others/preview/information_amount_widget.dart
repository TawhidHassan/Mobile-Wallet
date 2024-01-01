import 'package:qrpay/utils/custom_style.dart';
import 'package:qrpay/widgets/text_labels/title_heading4_widget.dart';
import 'package:flutter/material.dart';
import '../../../utils/custom_color.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/size.dart';
import '../../text_labels/custom_title_heading_widget.dart';
import '../../text_labels/title_heading3_widget.dart';

extension AmountInformation on Widget {
  Widget amountInformationWidget({
    required information,
    required enterAmount,
    required enterAmountRow,
    required fee,
    required feeRow,
    received,
    receivedRow,
    total,
    totalRow,
  }) {
    return Container(
      height: 220,
      margin: EdgeInsets.only(top: Dimensions.heightSize * 0.4),
      decoration: BoxDecoration(
          color: CustomColor.whiteColor,
          borderRadius: BorderRadius.circular(Dimensions.radius * 1.5)),
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: Dimensions.paddingSize * 0.7,
              bottom: Dimensions.paddingSize * 0.3,
              left: Dimensions.paddingSize * 0.7,
              right: Dimensions.paddingSize * 0.7,
            ),
            child: CustomTitleHeadingWidget(
                text: information,
                textAlign: TextAlign.left,
                style: CustomStyle.f20w600pri),
          ),
          Divider(
            thickness: 1,
            color: CustomColor.primaryLightColor.withOpacity(0.2),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: Dimensions.paddingSize * 0.3,
              bottom: Dimensions.paddingSize * 0.6,
              left: Dimensions.paddingSize * 0.7,
              right: Dimensions.paddingSize * 0.7,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: mainSpaceBet,
                  children: [
                    TitleHeading4Widget(
                      text: enterAmount,
                      color: CustomColor.primaryLightColor.withOpacity(
                        0.4,
                      ),
                    ),
                    TitleHeading3Widget(
                      text: enterAmountRow,
                      color: CustomColor.primaryLightColor.withOpacity(
                        0.6,
                      ),
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                verticalSpace(Dimensions.heightSize * 0.7),
                Row(
                  mainAxisAlignment: mainSpaceBet,
                  children: [
                    TitleHeading4Widget(
                      text: fee,
                      color: CustomColor.primaryLightColor.withOpacity(
                        0.4,
                      ),
                    ),
                    TitleHeading3Widget(
                      text: feeRow,
                      color: CustomColor.primaryLightColor.withOpacity(
                        0.6,
                      ),
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                verticalSpace(Dimensions.heightSize * 0.7),
                Row(
                  mainAxisAlignment: mainSpaceBet,
                  children: [
                    TitleHeading4Widget(
                      text: received,
                      color: CustomColor.primaryLightColor.withOpacity(
                        0.4,
                      ),
                    ),
                    TitleHeading3Widget(
                      text: receivedRow,
                      color: CustomColor.primaryLightColor.withOpacity(
                        0.6,
                      ),
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                verticalSpace(Dimensions.heightSize * 0.7),
                Row(
                  mainAxisAlignment: mainSpaceBet,
                  children: [
                    TitleHeading4Widget(
                      text: total,
                      color: CustomColor.primaryLightColor.withOpacity(
                        0.4,
                      ),
                    ),
                    TitleHeading3Widget(
                      text: totalRow,
                      color: CustomColor.primaryLightColor.withOpacity(
                        0.6,
                      ),
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

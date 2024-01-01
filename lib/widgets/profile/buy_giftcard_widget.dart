import 'package:qrpay/widgets/text_labels/title_heading2_widget.dart';
import 'package:flutter/material.dart';

import '../../custom_assets/assets.gen.dart';
import '../../utils/custom_color.dart';
import '../../utils/custom_style.dart';
import '../../utils/dimensions.dart';
import '../../utils/size.dart';
import '../../utils/strings.dart';

class BuyGiftCardWidget extends StatelessWidget {
  const BuyGiftCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.32,
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSize,
        vertical: Dimensions.paddingSize * 0.6,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius * 1.3),
        image: DecorationImage(
          image: AssetImage(Assets.card.googlePlayFront.path),
        ),
      ),
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
          verticalSpace(Dimensions.heightSize * 3),
          const TitleHeading2Widget(
            text: Strings.googlePlay,
            color: CustomColor.whiteColor,
          ),
          verticalSpace(Dimensions.heightSize * 2),
          Text(
            "9864 1326 7135 3126",
            style: TextStyle(
              fontFamily: "AgencyFB",
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: CustomColor.whiteColor.withOpacity(0.6),
            ),
          ),
          verticalSpace(Dimensions.heightSize * 2),
          Row(
            mainAxisAlignment: mainSpaceBet,
            children: [
              Column(
                mainAxisAlignment: mainCenter,
                children: [
                  Text(
                    Strings.nineElevent,
                    style: CustomStyle.f20w600pri
                        .copyWith(color: CustomColor.whiteColor),
                  ),
                  Text(
                    Strings.expiryDate,
                    style: CustomStyle.darkHeading3TextStyle.copyWith(
                      color: CustomColor.whiteColor.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                      fontSize: Dimensions.headingTextSize5,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: mainCenter,
                children: [
                  Text(
                    Strings.nineSix,
                    style: CustomStyle.f20w600pri
                        .copyWith(color: CustomColor.whiteColor),
                  ),
                  Text(
                    Strings.cvc,
                    style: CustomStyle.darkHeading3TextStyle.copyWith(
                      color: CustomColor.whiteColor.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                      fontSize: Dimensions.headingTextSize5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:qrpay/utils/custom_style.dart';
import 'package:qrpay/widgets/text_labels/custom_title_heading_widget.dart';
import 'package:qrpay/widgets/text_labels/title_heading3_widget.dart';
import 'package:flutter/material.dart';

import '../../utils/dimensions.dart';
import '../../utils/size.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({
    super.key,
    required this.subtitle,
    required this.title,
    required this.dateText,
    required this.monthText,
  });

  final String title, monthText, dateText, subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.paddingSize * 0.3),
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: Dimensions.marginSizeVertical * 0.7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius),
          color: Theme.of(context).primaryColor.withOpacity(0.05),
        ),
        padding: EdgeInsets.only(right: Dimensions.paddingSize * 0.2),
        height: Dimensions.heightSize * 6,
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.only(
                    left: Dimensions.marginSizeVertical * 0.4,
                    top: Dimensions.marginSizeVertical * 0.5,
                    bottom: Dimensions.marginSizeVertical * 0.4,
                    right: Dimensions.marginSizeVertical * 0.2,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.04),
                    borderRadius:
                        BorderRadius.circular(Dimensions.radius * 0.6),
                  ),
                  child: Column(
                    mainAxisAlignment: mainCenter,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTitleHeadingWidget(
                        text: dateText,
                        style: CustomStyle.darkHeading4TextStyle.copyWith(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).primaryColor),
                      ),
                      CustomTitleHeadingWidget(
                        text: monthText,
                        style: CustomStyle.darkHeading4TextStyle.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor),
                      ),
                    ],
                  ),
                )),
            Expanded(
              flex: 7,
              child: Column(
                crossAxisAlignment: crossStart,
                mainAxisAlignment: mainCenter,
                children: [
                  TitleHeading3Widget(
                    text: title,
                  ),
                  verticalSpace(Dimensions.widthSize * 0.7),
                  CustomTitleHeadingWidget(
                    text: subtitle,
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                    style: CustomStyle.darkHeading4TextStyle.copyWith(
                        fontSize: Dimensions.headingTextSize5,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

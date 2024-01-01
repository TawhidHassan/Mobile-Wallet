import 'package:qrpay/utils/custom_style.dart';
import 'package:qrpay/utils/dimensions.dart';
import 'package:qrpay/utils/size.dart';
import 'package:qrpay/views/others/custom_image_widget.dart';
import 'package:qrpay/widgets/text_labels/custom_title_heading_widget.dart';
import 'package:flutter/material.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  final String icon, text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: FittedBox(
        child: Column(
          children: [
            CircleAvatar(
              radius: 27,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.06),
              child: CustomImageWidget(
                path: icon,
                height: 24,
                color: Theme.of(context).primaryColor,
                width: 24,
              ),
            ),
            verticalSpace(Dimensions.heightSize * 0.5),
            CustomTitleHeadingWidget(
              text: text,
              style: CustomStyle.darkHeading5TextStyle
                  .copyWith(fontWeight: FontWeight.w600, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

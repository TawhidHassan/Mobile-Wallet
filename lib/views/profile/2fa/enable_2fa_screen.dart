import 'package:qrpay/utils/dimensions.dart';
import 'package:qrpay/utils/responsive_layout.dart';
import 'package:qrpay/utils/size.dart';
import 'package:qrpay/utils/strings.dart';
import 'package:qrpay/widgets/appbar/appbar_widget.dart';
import 'package:qrpay/widgets/buttons/primary_button.dart';
import 'package:qrpay/widgets/text_labels/title_heading2_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../backend/utils/custom_loading_api.dart';
import '../../../backend/utils/status_data_widget.dart';
import '../../../controller/profile/twoFa/enable_twofa_controller.dart';
import '../../../widgets/text_labels/title_heading4_widget.dart';

class Enable2FaScreen extends StatelessWidget {
  Enable2FaScreen({super.key});

  final controller = Get.put(TwoFaController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: AppBarWidget(
          text: "",
        ),
        body: Obx(() => controller.isLoading
            ? const CustomLoadingAPI()
            : _bodyWidget(context)),
      ),
    );
  }

  _bodyWidget(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.marginSizeHorizontal * 0.9,
      ),
      physics: const BouncingScrollPhysics(),
      children: [
        _textWidget(context),
        _buttonWidget(context),
      ],
    );
  }

  _textWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: Dimensions.marginSizeVertical * 0.8,
        bottom: Dimensions.marginSizeVertical,
      ),
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
          const TitleHeading2Widget(text: Strings.enable2FASecurity),
          verticalSpace(Dimensions.heightSize * 0.5),
          GestureDetector(
            onTap: () async {
              // Clipboard.setData(ClipboardData(text: controller.twoFaInfoModelData.data.message)).then((_){
              //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Copied to clipboard")));
              // });

              await Clipboard.setData(ClipboardData(
                  text: controller.twoFaInfoModelData.data.message));
            },
            child: TitleHeading4Widget(
              text: controller.twoFaInfoModelData.data.message,
            ),
          ),
        ],
      ),
    );
  }

  _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.marginSizeVertical * 2),
      child: controller.twoFaInfoModelData.data.status == 1
          ? const StatusDataWidget(
              text: "Verified",
              icon: Icons.check_circle_outline,
            )
          : PrimaryButton(
              title: Strings.oTPVerification.tr,
              onPressed: () {
                controller.gotoOtp();
              },
            ),
    );
  }
}

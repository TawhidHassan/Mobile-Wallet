import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/utils/responsive_layout.dart';
import 'package:qrpay/utils/strings.dart';
import 'package:qrpay/widgets/appbar/appbar_widget.dart';
import 'package:qrpay/widgets/others/limit_widget.dart';

import '../../../backend/utils/custom_loading_api.dart';
import '../../../controller/categories/mobile_topup/mobile_topup_controller.dart';
import '../../../routes/routes.dart';
import '../../../utils/custom_color.dart';
import '../../../utils/custom_style.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/size.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/dropdown/input_dropdown.dart';
import '../../../widgets/inputs/input_with_text.dart';
import '../../../widgets/inputs/top_up_phone_number_with_contry_code_input.dart';
import '../../../widgets/others/congratulation_widget.dart';
import '../../../widgets/text_labels/custom_title_heading_widget.dart';

class MobileTopUpScreen extends StatelessWidget {
  final controller = Get.put(MobileTopupController());

  MobileTopUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: AppBarWidget(text: Strings.mobileTopUp),
        body: Obx(() => controller.isLoading
            ? const CustomLoadingAPI()
            : _bodyWidget(context)),
      ),
    );
  }

  _bodyWidget(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.marginSizeHorizontal,
      ),
      physics: const BouncingScrollPhysics(),
      children: [
        _inputWidget(context),
        _buttonWidget(context),
      ],
    );
  }

  _buttonWidget(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(
          vertical: Dimensions.marginSizeVertical * 2,
        ),
        child: Obx(
          () => controller.isInsertLoading
              ? const CustomLoadingAPI()
              : PrimaryButton(
                  title: Strings.topUpNow,
                  onPressed: () {
                    // controller.gotoMobilePreview(context);

                    debugPrint(controller.billMethodselected.value);
                    controller.type.value = controller
                        .getType(controller.billMethodselected.value)!;
                    controller
                        .topUpApiProcess(
                            amount: controller.amountController.text,
                            number: controller.mobileNumberController.text,
                            type: controller.type.value)
                        .then((value) => StatusScreen.show(
                            context: context,
                            subTitle: Strings.yourTopUpSuccess.tr,
                            onPressed: () {
                              Get.offAllNamed(Routes.bottomNavBarScreen);
                            }));
                  }),
        ));
  }

  //drop down input,biil number input ,and amount input
  _inputWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.marginSizeVertical * 1.2),
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
          CustomTitleHeadingWidget(
            text: Strings.mobileTopUpType,
            style: CustomStyle.darkHeading4TextStyle.copyWith(
              fontWeight: FontWeight.w600,
              color: CustomColor.primaryTextColor,
            ),
          ),
          verticalSpace(Dimensions.heightSize * 0.5),
          InputDropDown(
            itemsList: controller.billList,
            selectMethod: controller.billMethodselected,
            onChanged: ((p0) => controller.billMethodselected.value = p0!),
          ),
          verticalSpace(Dimensions.heightSize),
          //bill number input
          TopUpPhoneNumberInputWidget(
            countryCode: controller.countryCode,
            controller: controller.mobileNumberController,
            hint: Strings.xxx,
            label: Strings.phoneNumber,
          ),
          verticalSpace(Dimensions.heightSize),
          InputWithText(
            controller: controller.amountController,
            hint: Strings.zero00,
            label: Strings.amount,
            suffixText: "BDT",
            onChanged: (v) {
              controller.getFee(rate: controller.rate.value);
            },
          ),

          Obx(() {
            return LimitWidget(
                fee:
                    '${controller.totalFee.value.toStringAsFixed(4)} ${controller.baseCurrency.value}',
                limit:
                    '${controller.limitMin} - ${controller.limitMax} ${controller.baseCurrency.value}');
          }),
        ],
      ),
    );
  }
}

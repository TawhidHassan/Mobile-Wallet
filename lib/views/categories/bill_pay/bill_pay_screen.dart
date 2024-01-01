import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/backend/utils/custom_loading_api.dart';
import 'package:qrpay/utils/dimensions.dart';
import 'package:qrpay/utils/responsive_layout.dart';
import 'package:qrpay/utils/size.dart';
import 'package:qrpay/utils/strings.dart';
import 'package:qrpay/widgets/appbar/appbar_widget.dart';
import 'package:qrpay/widgets/buttons/primary_button.dart';
import 'package:qrpay/widgets/dropdown/input_dropdown.dart';
import 'package:qrpay/widgets/inputs/input_with_text.dart';
import 'package:qrpay/widgets/inputs/primary_input_filed.dart';
import 'package:qrpay/widgets/others/limit_widget.dart';

import '../../../controller/categories/bill_pay/bill_pay_controller.dart';
import '../../../routes/routes.dart';
import '../../../utils/custom_color.dart';
import '../../../utils/custom_style.dart';
import '../../../widgets/others/congratulation_widget.dart';
import '../../../widgets/text_labels/custom_title_heading_widget.dart';

class BillPayScreen extends StatelessWidget {
  BillPayScreen({super.key});

  final controller = Get.put(BillPayController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: AppBarWidget(text: Strings.billPay),
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

//drop down input,biil number input ,and amount input
  _inputWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.marginSizeVertical * 1.5),
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
          CustomTitleHeadingWidget(
            text: Strings.billType.tr,
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
          PrimaryInputWidget(
              controller: controller.billNumberController,
              hint: Strings.enterBillNumber.tr,
              label: Strings.billNumber),
          verticalSpace(Dimensions.heightSize),
          InputWithText(
            controller: controller.amountController,
            hint: Strings.zero00,
            label: Strings.amount.tr,
            suffixText: Strings.uSD,
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

  _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Dimensions.marginSizeVertical * 2,
      ),
      child: controller.isInsertLoading
          ? const CustomLoadingAPI()
          : PrimaryButton(
              title: Strings.payBill.tr,
              onPressed: () {
                // controller.gotoBillPreview(context);
                debugPrint(controller.billMethodselected.value);
                controller.type.value =
                    controller.getType(controller.billMethodselected.value)!;
                controller
                    .billPayApiProcess(
                        amount: controller.amountController.text,
                        billNumber: controller.billNumberController.text,
                        type: controller.type.value)
                    .then((value) => StatusScreen.show(
                        context: context,
                        subTitle: Strings.yourBillPaySuccess.tr,
                        onPressed: () {
                          Get.offAllNamed(Routes.bottomNavBarScreen);
                        }));
              }),
    );
  }
}

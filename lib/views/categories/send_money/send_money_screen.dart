import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/backend/utils/custom_loading_api.dart';
import 'package:qrpay/custom_assets/assets.gen.dart';
import 'package:qrpay/routes/routes.dart';
import 'package:qrpay/utils/dimensions.dart';
import 'package:qrpay/utils/responsive_layout.dart';
import 'package:qrpay/utils/size.dart';
import 'package:qrpay/utils/strings.dart';
import 'package:qrpay/widgets/appbar/appbar_widget.dart';
import 'package:qrpay/widgets/buttons/primary_button.dart';
import 'package:qrpay/widgets/inputs/input_with_dropdown.dart';

import '../../../controller/categories/send_money/send_money_controller.dart';
import '../../../widgets/inputs/copy_with_input.dart';
import '../../../widgets/others/limit_widget.dart';
import '../../../widgets/text_labels/title_heading5_widget.dart';

class MoneyTransferScreen extends StatefulWidget {
  const MoneyTransferScreen({super.key});

  @override
  State<MoneyTransferScreen> createState() => _MoneyTransferScreenState();
}

class _MoneyTransferScreenState extends State<MoneyTransferScreen> {
  final controller = Get.put(SendMoneyController());

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: AppBarWidget(text: Strings.sendMoney),
        body: Obx(
          () => controller.isLoading
              ? const CustomLoadingAPI()
              : _bodyWidget(context),
        ),
      ),
    );
  }

  _bodyWidget(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSize * 0.9),
      physics: const BouncingScrollPhysics(),
      children: [
        _inputWidget(context),
        Obx(() {
          return LimitWidget(
              fee:
                  '${controller.totalFee.value.toStringAsFixed(4)} ${controller.baseCurrency.value}',
              limit:
                  '${controller.limitMin} - ${controller.limitMax} ${controller.baseCurrency.value}');
        }),
        _buttonWidget(context),
      ],
    );
  }

  _inputWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.marginSizeVertical * 1.6),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CopyInputWidget(
                  suffixIcon: Assets.icon.scan,
                  suffixColor: Theme.of(context).primaryColor,
                  onTap: () {
                    Get.toNamed(Routes.qRCodeScreen);
                  },
                  controller: controller.copyInputController,
                  hint: Strings.enterEmailAddress,
                  label: Strings.emailAddress,
                ),
                Obx(() {
                  return TitleHeading5Widget(
                    text: controller.checkUserMessage.value,
                    color: controller.isValidUser.value
                        ? Colors.green
                        : Colors.red,
                  );
                })
              ],
            ),
            verticalSpace(Dimensions.heightSize),
            SendMoneyInputWithDropdown(
              controller: controller.amountController,
              hint: Strings.zero00,
              label: Strings.amount,
            ),
          ],
        ),
      ),
    );
  }

  _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: Dimensions.marginSizeVertical * 4,
        bottom: Dimensions.marginSizeVertical,
      ),
      child: Obx(
        () => controller.isSendMoneyLoading
            ? const CustomLoadingAPI()
            : PrimaryButton(
                title: Strings.send,
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Get.toNamed(Routes.sendMoneyPreviewScreen);

                    // _bottomSheetWidget(context);
                  }
                }),
      ),
    );
  }

  _bottomSheetWidget(BuildContext context) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      context: context,
      builder: (builder) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Container(
            height: MediaQuery.of(context).size.height / 3,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: paymentMethods.length,
                    itemBuilder: (context, index) => Obx(() {
                      return RadioListTile(
                        title: Text(paymentMethods[index]),
                        value: paymentMethods[index],
                        groupValue: controller.selectedPaymentMethod.toString(),
                        onChanged: (value) {
                          controller.selectedPaymentMethod.value = value!;
                        },
                      );
                    }),
                  ),
                ),
                PrimaryButton(
                    title: Strings.confirm,
                    onPressed: () {
                      if (controller.selectedPaymentMethod.toString() != '') {
                        Get.offAndToNamed(Routes.sendMoneyPreviewScreen);
                      }
                    }),
              ],
            ));
      }),
    );
  }

  List<String> paymentMethods = ['Bkash', 'Nagad', 'Rocket'];
}

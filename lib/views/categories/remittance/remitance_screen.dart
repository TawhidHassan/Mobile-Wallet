import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:qrpay/backend/utils/custom_loading_api.dart';
import 'package:qrpay/utils/dimensions.dart';
import 'package:qrpay/utils/responsive_layout.dart';
import 'package:qrpay/utils/size.dart';
import 'package:qrpay/utils/strings.dart';
import 'package:qrpay/widgets/appbar/appbar_widget.dart';
import 'package:qrpay/widgets/buttons/primary_button.dart';
import 'package:qrpay/widgets/others/limit_widget.dart';

import '../../../controller/categories/remittance/remitance_controller.dart';
import '../../../routes/routes.dart';
import '../../../utils/custom_color.dart';
import '../../../utils/custom_style.dart';
import '../../../widgets/inputs/country_dropdown.dart';
import '../../../widgets/inputs/input_with_text.dart';
import '../../../widgets/inputs/receiving_method_drop_down.dart';
import '../../../widgets/inputs/recipient_drop_down.dart';
import '../../../widgets/text_labels/custom_title_heading_widget.dart';

class RemittanceScreen extends StatelessWidget {
  RemittanceScreen({super.key});

  final controller = Get.put(RemittanceController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: AppBarWidget(text: Strings.remittance),
        body: Obx(
              () => controller.isLoading
              ? const CustomLoadingAPI()
              : _bodyWidget(context),
        ),
      ),
    );
  }

  _bodyWidget(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.marginSizeHorizontal * 0.9,
        ),
        children: [
          _countryInput(context),
          _dropdownInput(context),
          _selectedInputWidget(context),
          _buttonWidget(context),
        ],
      ),
    );
  }

  _countryInput(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.marginSizeVertical),
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
          CustomTitleHeadingWidget(
            text: Strings.sendingCountry,
            style: CustomStyle.darkHeading4TextStyle.copyWith(
              fontWeight: FontWeight.w600,
              color: CustomColor.primaryTextColor,
            ),
          ),
          verticalSpace(Dimensions.heightSize * 0.8),
          CountryDropDown(
            selectMethod: controller.selectedSendingCountry,
            itemsList: controller.sendingCountryList,
            onChanged: (value) {
              controller.selectedSendingCountry.value = value!.country;
              controller.sendingCountryId.value = value.id;
              controller.selectedSendingCountryCode.value = value.code;
              controller.fromCountriesRate.value = value.rate;
              controller.recipientGet;
            },
          ),
          verticalSpace(Dimensions.heightSize * 0.5),
          CustomTitleHeadingWidget(
            text: Strings.receivingCountry,
            style: CustomStyle.darkHeading4TextStyle.copyWith(
              fontWeight: FontWeight.w600,
              color: CustomColor.primaryTextColor,
            ),
          ),
          verticalSpace(Dimensions.heightSize * 0.8),
          CountryDropDown(
            selectMethod: controller.selectedReceivingCountry,
            itemsList: controller.receivingCountryList,
            onChanged: (value) {
              controller.selectedReceivingCountry.value = value!.country;
              controller.receivingCountryId.value = value.id;
              controller.selectedReceivingCountryCode.value = value.code;
              controller.toCountriesRate.value = value.rate;
              Logger().w(value.rate);
              controller.recipientGet;
              controller.remittanceGetRecipientProcess();
            },
          ),
        ],
      ),
    );
  }

  _dropdownInput(BuildContext context) {
    return Column(
      crossAxisAlignment: crossStart,
      children: [
        verticalSpace(Dimensions.heightSize * 0.5),
        //!receiving method
        CustomTitleHeadingWidget(
          text: "Payment Method",
          style: CustomStyle.labelTextStyle.copyWith(
            color: CustomColor.primaryTextColor,
          ),
        ),
        verticalSpace(Dimensions.heightSize * 0.5),
        ReceivingMethodDropDown(
          onChanged: (value) {
            controller.selectedMethod.value = value!.labelName;
            controller.selectedTrxType.value = value.fieldName;
            controller.remittanceGetRecipientProcess();
          },
          itemsList: controller.transactionTypeList,
          selectMethod: controller.selectedMethod,
        ),
        verticalSpace(Dimensions.heightSize * 0.8),

        CustomTitleHeadingWidget(
            text: "Account",
            style: CustomStyle.labelTextStyle.copyWith(
              color: CustomColor.primaryTextColor,
            )),
        verticalSpace(Dimensions.heightSize * 0.5),
        Row(
          children: [
            Expanded(
              flex: 9,
              child: RecipientDropDown(
                onChanged: (value) {
                  controller.selectedRecipient.value =
                  "${value!.firstname} ${value.lastname}";
                  controller.selectedRecipientId.value = value.id;
                },
                itemsList: controller.recipientList,
                selectMethod: controller.selectedRecipient,
              ),
            ),
            horizontalSpace(Dimensions.widthSize * 0.5),
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: (() {
                  Get.toNamed(Routes.addRecipientScreen);
                }),
                child: Container(
                  height: 52,
                  width: Dimensions.widthSize * 8.2,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(Dimensions.radius * 0.5),
                      color: Theme.of(context).primaryColor),
                  child: CustomTitleHeadingWidget(
                    text: Strings.addPlus,
                    style: CustomStyle.lightHeading4TextStyle.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: Dimensions.headingTextSize3,
                      color: CustomColor.whiteColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        verticalSpace(Dimensions.heightSize * 0.9),
      ],
    );
  }

  _selectedInputWidget(BuildContext context) {
    var currency = controller.baseCurrency.value;
    return Column(
      crossAxisAlignment: crossStart,
      children: [
        InputWithText(
          hint: Strings.zero00,
          suffixText: controller.selectedSendingCountryCode.value.toString(),
          controller: controller.amountController,
          label: Strings.amount,
          onChanged: (amount) {
            controller.recipientGet;
            controller.getFee(rate: controller.fromCountriesRate.value);
          },
        ),
        verticalSpace(Dimensions.heightSize * 0.3),
        LimitWidget(
            fee: "${controller.totalFee.value.toStringAsFixed(4)} $currency",
            limit:
            "${controller.minLimit.value.toString()} $currency - ${controller.maxLimit.value.toString()} $currency "),
        verticalSpace(Dimensions.heightSize * 0.5),
        InputWithText(
          hint: Strings.zero00,
          suffixText: "BDT",
          controller: controller.recipientGetController,
          label: Strings.recipientGet,
          onChanged: (amount) {
            controller.senderSendAmount;
          },
        ),
      ],
    );
  }

  _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Dimensions.marginSizeVertical),
      child: PrimaryButton(
          title: Strings.send,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              controller.togoRemittancePreview();
            }
          }),
    );
  }
}

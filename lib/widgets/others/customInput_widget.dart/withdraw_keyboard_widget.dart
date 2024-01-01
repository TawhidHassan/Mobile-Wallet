import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qrpay/widgets/text_labels/custom_title_heading_widget.dart';
import 'package:qrpay/widgets/text_labels/title_heading4_widget.dart';

import '../../../backend/utils/custom_loading_api.dart';
import '../../../controller/categories/withdraw_controller/withdraw_controller.dart';
import '../../../utils/custom_color.dart';
import '../../../utils/custom_style.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/strings.dart';
import '../../buttons/primary_button.dart';
import '../limit_with_exchange_rate_widget.dart';

class WithdrawKeyboardWidget extends StatelessWidget {
  WithdrawKeyboardWidget({
    Key? key,
    required this.buttonText,
    required this.onTap,
    required this.isLoading,
  }) : super(key: key);
  final String buttonText;
  final VoidCallback onTap;
  final controller = Get.put(WithdrawController());
  final RxBool isLoading;

  @override
  Widget build(BuildContext context) {
    return _bodyWidget(context);
  }

  _bodyWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _walletDropDownWidget(context),
        _inputFieldWidget(context),
        _minMaxWidget(),

        _customNumKeyBoardWidget(context),
        _buttonWidget(context)
      ],
    );
  }

  _inputFieldWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: Dimensions.marginSizeHorizontal * 0.5,
        top: Dimensions.marginSizeVertical,
      ),
      alignment: Alignment.topCenter,
      height: Dimensions.inputBoxHeight,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Directionality(
            textDirection: TextDirection.rtl,
            child: SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: Dimensions.widthSize * 0.7),
                  Expanded(
                    child: GetBuilder<WithdrawController>(
                      assignId: true,
                      builder: (logic) {
                        return TextFormField(
                          style:  controller.amountTextController.value.text ==
                        "Amount:-  0.0" ?
                          Get.isDarkMode
                              ? CustomStyle.lightHeading2TextStyle.copyWith(
                              fontSize: 18,
                              color: Theme
                                  .of(context)
                                  .primaryColor
                                  .withOpacity(0.30)
                          )
                              : CustomStyle.darkHeading2TextStyle.copyWith(
                            color: Theme
                                .of(context)
                                .primaryColor
                                .withOpacity(0.30),
                            fontSize: 18,
                          ):
                          Get.isDarkMode
                              ? CustomStyle.lightHeading2TextStyle.copyWith(
                            fontSize: Dimensions.headingTextSize3 * 2,
                          )
                              : CustomStyle.darkHeading2TextStyle.copyWith(
                            color: Theme
                                .of(context)
                                .primaryColor,
                            fontSize: Dimensions.headingTextSize3 * 2,
                          ),
                          readOnly: true,
                          controller: controller.amountTextController,
                          keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'(^-?\d*\.?\d*)')),
                            LengthLimitingTextInputFormatter(
                              6,
                            ), //max length of 12 characters
                          ],
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return null;
                            } else {
                              return Strings.pleaseFillOutTheField;
                            }
                          },
                          decoration: const InputDecoration(
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: Dimensions.widthSize * 0.5,
                  ),
                ],
              ),
            ),
          ),
          // SizedBox(width: Dimensions.widthSize * 0.7),
          // _currencyDropDownWidget(context),
        ],
      ),
    );
  }

  _customNumKeyBoardWidget(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 10.0,
      mainAxisSpacing: 10.0,
      childAspectRatio: 3 / 1.7,
      shrinkWrap: true,
      children: List.generate(
        controller.keyboardItemList.length,
            (index) {
          return controller.inputItem(index);
        },
      ),
    );
  }

  _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: Dimensions.marginSizeHorizontal * 0.8,
        right: Dimensions.marginSizeHorizontal * 0.8,
        top: Platform.isAndroid ? Dimensions.marginSizeVertical * 1.8 : 0.0,
      ),
      child: Row(
        children: [
          Expanded(
            child: isLoading.value
                ? const CustomLoadingAPI()
                : PrimaryButton(
              title: buttonText,
              onPressed: onTap,
              borderColor: Theme
                  .of(context)
                  .primaryColor,
              buttonColor: Theme
                  .of(context)
                  .primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  _walletDropDownWidget(BuildContext context) {
    return Obx(() {
      return Container(
        width: MediaQuery
            .of(context)
            .size
            .width * 0.50,
        height: Dimensions.buttonHeight * 0.6,
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(
            horizontal: Dimensions.marginSizeHorizontal * 3,
            vertical: Dimensions.marginSizeVertical * 1.5),
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.marginSizeHorizontal * .4,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius * 3),
          color: Theme
              .of(context)
              .primaryColor,
        ),
        child: FittedBox(
          child: Row(
            children: [
              DropdownButton(
                underline: Container(),
                hint: TitleHeading4Widget(
                  text: controller.selectedCurrencyName.value,
                  fontSize: Dimensions.headingTextSize2,
                  color: CustomColor.whiteColor,
                  fontWeight: FontWeight.w500,
                ),
                icon: const Icon(
                  Icons.arrow_drop_down_rounded,
                  color: CustomColor.whiteColor,
                ),
                items: controller.currencyList
                    .map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(
                    onTap: () {
                      controller.selectedCurrencyAlias.value = value.alias;
                      controller.selectedCurrencyType.value = value.type;
                      controller.selectedCurrencyId.value = value.id;
                      controller.currencyWalletCode.value = value.currencyCode;

                      controller.rate.value = value.rate.toDouble();

                      controller.fee.value = value.fixedCharge.toDouble();
                      controller.limitMin.value =
                          value.minLimit.toDouble() / controller.rate.value;
                      controller.limitMax.value =
                          value.maxLimit.toDouble() / controller.rate.value;
                      controller.percentCharge.value =
                          value.percentCharge.toDouble();
                    },
                    value: value.name,
                    child: Container(
                      alignment: Alignment.center,
                      height: 40.h,
                      child: Text(
                        value.name,
                        style: TextStyle(
                          color: controller.selectedCurrencyName.value ==
                              value.name
                              ? Theme
                              .of(context)
                              .primaryColor
                              : Theme
                              .of(context)
                              .primaryColor,
                          fontSize: Dimensions.headingTextSize4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? value) {
                  controller.selectedCurrencyName.value = value!;
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  _currencyDropDownWidget(BuildContext context) {
    return Obx(() {
      return Container(
        width: MediaQuery
            .of(context)
            .size
            .width * 0.33,
        height: Dimensions.buttonHeight * 0.65,
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(
            horizontal: Dimensions.marginSizeHorizontal * 0.1,
            vertical: Dimensions.marginSizeVertical * 0.2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radius * 3),
            color: Theme
                .of(context)
                .primaryColor),
        child: DropdownButton(
          underline: Container(),
          hint: TitleHeading4Widget(
            text: controller.baseCurrency.value,
            fontSize: Dimensions.headingTextSize2,
            color: CustomColor.whiteColor,
            fontWeight: FontWeight.w500,
          ),
          icon: const Icon(
            Icons.arrow_drop_down_rounded,
            color: CustomColor.whiteColor,
          ),
          items: controller.baseCurrencyList
              .map<DropdownMenuItem<String>>((value) {
            return DropdownMenuItem<String>(
              value: value.toString(),
              child: Container(
                alignment: Alignment.centerLeft,
                height: 40.h,
                child: CustomTitleHeadingWidget(
                  text: value.toString(),
                  style: GoogleFonts.inter(
                    color: controller.baseCurrency.value == value
                        ? Theme
                        .of(context)
                        .primaryColor
                        : Theme
                        .of(context)
                        .primaryColor,
                    fontSize: Dimensions.headingTextSize3,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
          onChanged: (String? value) {
            controller.baseCurrency.value = value!;
          },
        ),
      );
    });
  }

  _minMaxWidget() {
    return Obx(() =>
        LimitWithExchangeRateWidget(
          exchangeRate:
          "1 ${controller.baseCurrency.value} = ${controller.rate.value
              .toStringAsFixed(2)} ${controller.currencyWalletCode.value}",
          fee:
          "${controller.fee.value} + ${controller.percentCharge
              .value}% ${controller.currencyWalletCode.value}",
          limit:
          "${controller.limitMin.value.toStringAsFixed(2)} ~ ${controller
              .limitMax.value.toStringAsFixed(2)} ${controller.currencyCode
              .value}",
        ));
  }
}

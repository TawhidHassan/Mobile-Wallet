import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/utils/dimensions.dart';
import 'package:qrpay/utils/responsive_layout.dart';
import 'package:qrpay/utils/strings.dart';
import 'package:qrpay/views/categories/remittance/recipient_email_input_widget.dart';
import 'package:qrpay/views/categories/remittance/recipient_phone_number_widget.dart';
import 'package:qrpay/widgets/appbar/appbar_widget.dart';
import 'package:qrpay/widgets/buttons/primary_button.dart';

import '../../../backend/utils/custom_loading_api.dart';
import '../../../controller/categories/remittance/add_recipient_controller.dart';
import '../../../utils/custom_color.dart';
import '../../../utils/custom_style.dart';
import '../../../utils/size.dart';
import '../../../widgets/inputs/primary_input_filed.dart';
import '../../../widgets/text_labels/custom_title_heading_widget.dart';
import '../../../widgets/text_labels/title_heading5_widget.dart';
import 'banks_dropdown_widget.dart';
import 'receiver_country_dropdown_widget.dart';
import 'transaction_type_dropdown_widget.dart';

class AddRecipientScreen extends StatelessWidget {
  AddRecipientScreen({super.key});

  final controller = Get.put(AddRecipientController());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: AppBarWidget(text: Strings.addReceipient),
        body: Obx(() => controller.isLoading
            ? const CustomLoadingAPI()
            : _bodyWidget(context)),
      ),
    );
  }

  _bodyWidget(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
            horizontal: Dimensions.marginSizeHorizontal * 0.9),
        children: [
          _transTypeWidget(),
          _countryWidget(),
          _emailWidget(),
          _phoneNumerWidget(),
          _nameEmailInput(context),
          verticalSpace(Dimensions.heightSize),
          _addressInput(context),
          _buttonWidget(context),
        ],
      ),
    );
  }

  _phoneNumerWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RecipientPhoneNumberInputWidget(
          countryCode: controller.numberCode,
          controller: controller.numberController,
          hint: Strings.xxx,
          label: Strings.phoneNumber,
        ),
        verticalSpace(Dimensions.heightSize),
      ],
    );
  }

  _emailWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RecipientEmailInputWidget(
          controller: controller.emailController,
          hint: "Enter Account Number",
          label: "Account Number",
          maxLines: 1,
        ),
        verticalSpace(Dimensions.heightSize),
        Obx(() {
          return TitleHeading5Widget(
            text: controller.checkUserMessage.value,
            color: controller.isValidUser.value ? Colors.green : Colors.red,
          );
        }),
        verticalSpace(Dimensions.heightSize),
      ],
    );
  }

  _transTypeWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTitleHeadingWidget(
            text: Strings.transactionType,
            style: CustomStyle.labelTextStyle.copyWith(
              color: CustomColor.primaryTextColor,
            )),
        verticalSpace(Dimensions.heightSize * 0.5),
        TransactionTypeDropDown(
          selectMethod: controller.transactionTypeSelectedMethod,
          itemsList: controller.transactionTypeList,
          onChanged: (value) {
            controller.transactionTypeSelectedMethod.value = value!.labelName;
            controller.transactionTypeFieldName.value = value.fieldName;
            controller.transactionType = value;

            // print(value.fieldName);

            controller.changeCountry(value.fieldName);
          },
        ),
        verticalSpace(Dimensions.heightSize),
      ],
    );
  }

  _nameEmailInput(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: PrimaryInputWidget(
            hint: Strings.enterFirstName,
            label: Strings.firstName,
            controller: controller.firstNameController,
          ),
        ),
        horizontalSpace(Dimensions.widthSize),
        Expanded(
          child: PrimaryInputWidget(
            hint: Strings.enterLastName,
            label: Strings.lastName,
            controller: controller.lastNameController,
          ),
        ),
      ],
    );
  }

  _addressInput(BuildContext context) {
    return Column(
      crossAxisAlignment: crossStart,
      children: [
        Row(
          children: [
            Expanded(
              child: PrimaryInputWidget(
                hint: Strings.enterAddress,
                label: Strings.address,
                controller: controller.addressController,
              ),
            ),
            horizontalSpace(Dimensions.widthSize),
            Expanded(
              child: PrimaryInputWidget(
                hint: Strings.enterState,
                label: Strings.state,
                controller: controller.stateController,
              ),
            ),
          ],
        ),
        verticalSpace(Dimensions.heightSize),
        Row(
          children: [
            Expanded(
              child: PrimaryInputWidget(
                hint: Strings.enterCity,
                label: Strings.city,
                controller: controller.cityController,
              ),
            ),
            horizontalSpace(Dimensions.widthSize),
            Expanded(
              child: PrimaryInputWidget(
                hint: Strings.enterZipCode,
                label: Strings.zipCode,
                controller: controller.zipController,
              ),
            ),
          ],
        ),
        verticalSpace(Dimensions.heightSize),
        Obx(() => Visibility(
          visible: controller.transactionTypeSelectedMethod.value ==
              controller.transactionTypeList[2].labelName,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTitleHeadingWidget(
                  text: Strings.pickUpPoint,
                  style: CustomStyle.labelTextStyle.copyWith(
                    color: CustomColor.primaryTextColor,
                  )),
              verticalSpace(Dimensions.heightSize * 0.5),
              ReceiverBankDropDown(
                selectMethod: controller.pickupPointMethod,
                itemsList: controller.pickupPointList,
                onChanged: (value) {
                  controller.pickupPointMethod.value = value!.name;
                  controller.pickupPoint = value;
                },
              ),
            ],
          ),
        )),
        Obx(() => Visibility(
          visible: controller.transactionTypeSelectedMethod.value ==
              controller.transactionTypeList[0].labelName,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTitleHeadingWidget(
                  text: Strings.selectBank,
                  style: CustomStyle.labelTextStyle.copyWith(
                    color: CustomColor.primaryTextColor,
                  )),
              verticalSpace(Dimensions.heightSize * 0.5),
              ReceiverBankDropDown(
                selectMethod: controller.receiverBankSelectedMethod,
                itemsList: controller.receiverBankList,
                onChanged: (value) {
                  controller.receiverBankSelectedMethod.value = value!.name;
                  controller.receiverBank = value;
                },
              ),
            ],
          ),
        )),
      ],
    );
  }

  _countryWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTitleHeadingWidget(
            text: Strings.selectCountry,
            style: CustomStyle.labelTextStyle.copyWith(
              color: CustomColor.primaryTextColor,
            )),
        verticalSpace(Dimensions.heightSize * 0.5),
        AbsorbPointer(
          absorbing: controller.transactionTypeFieldName.value ==
              'wallet-to-wallet-transfer',
          child: ReceiverCountryDropDown(
            selectMethod: controller.receiverCountrySelectedMethod,
            itemsList: controller.receiverCountryList,
            onChanged: (value) {
              controller.receiverCountrySelectedMethod.value = value!.name;
              controller.receiverCountry = value;
              controller.numberCode.value = value.mobileCode;
            },
          ),
        ),
        verticalSpace(Dimensions.heightSize),
      ],
    );
  }

  _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Dimensions.marginSizeVertical),
      child: Obx(
            () => controller.isLoading
            ? const CustomLoadingAPI()
            : PrimaryButton(
            title: Strings.addReceipient,
            onPressed: () {
              if (formKey.currentState!.validate()) {
                controller.addRecipient();
              }
            }),
      ),
    );
  }
}

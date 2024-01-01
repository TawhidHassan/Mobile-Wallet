import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../backend/utils/custom_loading_api.dart';
import '../../../controller/categories/deposit/deposti_controller.dart';
import '../../../routes/routes.dart';
import '../../../utils/custom_color.dart';
import '../../../utils/strings.dart';
import '../../../widgets/appbar/appbar_widget.dart';
import '../../../widgets/others/congratulation_widget.dart';
import '../../../widgets/stripe_components/card_input_formatter.dart';
import '../../../widgets/stripe_components/card_month_input_formatter.dart';
import '../../../widgets/stripe_components/master_card.dart';
import '../../../widgets/stripe_components/my_painter.dart';

class AddMoneyStripeAnimatedScreen extends StatefulWidget {
  const AddMoneyStripeAnimatedScreen({Key? key}) : super(key: key);

  @override
  State<AddMoneyStripeAnimatedScreen> createState() =>
      _AddMoneyStripeAnimatedScreenState();
}

class _AddMoneyStripeAnimatedScreenState
    extends State<AddMoneyStripeAnimatedScreen> {
  final controller = Get.put(DepositController());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(text: Strings.addMoney),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30.h),
              FlipCard(
                fill: Fill.fillFront,
                direction: FlipDirection.HORIZONTAL,
                controller: controller.flipCardController,
                onFlip: () {
                  debugPrint('Flip');
                },
                flipOnTouch: true,
                onFlipDone: (isFront) {
                  debugPrint('isFront: $isFront');
                },
                front: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: buildCreditCard(
                    color: CustomColor.kDarkBlue,
                    cardExpiration:
                        controller.cardExpiryDateController.text.isEmpty
                            ? "00/0000"
                            : controller.cardExpiryDateController.text,
                    cardHolder: controller.cardHolderNameController.text.isEmpty
                        ? Strings.cardHolder.tr
                        : controller.cardHolderNameController.text
                            .toUpperCase(),
                    cardNumber: controller.cardNumberController.text.isEmpty
                        ? "XXXX XXXX XXXX XXXX"
                        : controller.cardNumberController.text,
                  ),
                ),
                back: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    elevation: 4.0,
                    color: CustomColor.kDarkBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Container(
                      height: 200.h,
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, bottom: 22.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(height: 10.h),
                          Container(
                            height: 45.h,
                            width: MediaQuery.of(context).size.width / 1.2,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          CustomPaint(
                            painter: MyPainter(),
                            child: SizedBox(
                              height: 35.h,
                              width: MediaQuery.of(context).size.width / 1.2,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    controller.cardCvvController.text.isEmpty
                                        ? "000"
                                        : controller.cardCvvController.text,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 21.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            Strings.creditCardSampleText.tr,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              _cardInputFormWidget(context),
              const SizedBox(height: 20 * 3),
              Obx(
                () => controller.isConfirmLoading
                    ? const CustomLoadingAPI()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          minimumSize: Size(
                              MediaQuery.of(context).size.width / 1.12, 55),
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            controller.addMoneyStripeConfirmProcess().then(
                                (value) => StatusScreen.show(
                                    context: context,
                                    subTitle:
                                        Strings.yourmoneyDepositSuccess.tr,
                                    onPressed: () {
                                      Get.offAllNamed(
                                          Routes.bottomNavBarScreen);
                                    }));
                          }
                        },
                        child: Text(
                          Strings.payNow.tr.toUpperCase(),
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _cardInputFormWidget(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          SizedBox(height: 40.h),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.12,
            child: TextFormField(
              controller: controller.cardNumberController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.grey),
              validator: (String? value) {
                if (value!.isEmpty) {
                  return Strings.pleaseFillOutTheField.tr;
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                filled: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                hintText: Strings.cardNumber.tr,
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.sp,
                ),
                prefixIcon: const Icon(
                  Icons.credit_card,
                  color: Colors.grey,
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(16),
                CardInputFormatter(),
              ],
              onChanged: (value) {
                var text = value.replaceAll(RegExp(r'\s+\b|\b\s'), ' ');
                setState(() {
                  controller.cardNumberController.value =
                      controller.cardNumberController.value.copyWith(
                          text: text,
                          selection:
                              TextSelection.collapsed(offset: text.length),
                          composing: TextRange.empty);
                });
              },
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.12,
            child: TextFormField(
              controller: controller.cardHolderNameController,
              keyboardType: TextInputType.name,
              style: const TextStyle(color: Colors.grey),
              validator: (String? value) {
                if (value!.isEmpty) {
                  return Strings.pleaseFillOutTheField.tr;
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                filled: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                hintText: Strings.fullName.tr,
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.sp,
                ),
                prefixIcon: const Icon(
                  Icons.person,
                  color: Colors.grey,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  controller.cardHolderNameController.value =
                      controller.cardHolderNameController.value.copyWith(
                          text: value,
                          selection:
                              TextSelection.collapsed(offset: value.length),
                          composing: TextRange.empty);
                });
              },
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.4,
                child: TextFormField(
                  controller: controller.cardExpiryDateController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.grey),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return Strings.pleaseFillOutTheField.tr;
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    hintText: 'MM/YY',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.sp,
                    ),
                    prefixIcon: const Icon(
                      Icons.calendar_today,
                      color: Colors.grey,
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                    CardDateInputFormatter(),
                  ],
                  onChanged: (value) {
                    var text = value.replaceAll(RegExp(r'\s+\b|\b\s'), ' ');
                    setState(() {
                      controller.cardExpiryDateController.value =
                          controller.cardExpiryDateController.value.copyWith(
                              text: text,
                              selection:
                                  TextSelection.collapsed(offset: text.length),
                              composing: TextRange.empty);
                    });
                  },
                ),
              ),
              SizedBox(width: 14.w),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.4,
                child: TextFormField(
                  controller: controller.cardCvvController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.grey),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return Strings.pleaseFillOutTheField.tr;
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    hintText: 'CVV',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.sp,
                    ),
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.grey,
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  onTap: () {
                    setState(() {
                      Future.delayed(const Duration(milliseconds: 300), () {
                        controller.flipCardController.toggleCard();
                      });
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      int length = value.length;
                      if (length == 4 || length == 9 || length == 14) {
                        controller.cardNumberController.text = '$value ';
                        controller.cardNumberController.selection =
                            TextSelection.fromPosition(
                                TextPosition(offset: value.length + 1));
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

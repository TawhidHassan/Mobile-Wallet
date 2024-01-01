import 'package:get/get.dart';
import 'package:qrpay/utils/size.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/categories/withdraw_controller/withdraw_controller.dart';
import '../../utils/custom_color.dart';
import '../../utils/custom_style.dart';
import '../../utils/dimensions.dart';
import '../../utils/strings.dart';
import '../text_labels/title_heading3_widget.dart';

class FlutterWaveBanksDropDown extends StatefulWidget {
  const FlutterWaveBanksDropDown({
    Key? key,
  }) : super(key: key);

  @override
  State<FlutterWaveBanksDropDown> createState() =>
      _FlutterWaveBanksDropDownState();
}

class _FlutterWaveBanksDropDownState extends State<FlutterWaveBanksDropDown> {
  FocusNode? focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode!.dispose();
    super.dispose();
  }

  final controller = Get.put(WithdrawController());
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.bankName.tr,
          style: CustomStyle.darkHeading4TextStyle.copyWith(
            fontWeight: FontWeight.w600,
            color: CustomColor.primaryTextColor,
          ),
        ),
        verticalSpace(7),
        TextFormField(
          readOnly: false,
          textInputAction: TextInputAction.next,
          controller: controller.bankNameController,
          onTap: () {
            setState(() {
              focusNode!.requestFocus();
            });
          },
          onFieldSubmitted: (value) {
            setState(() {
              focusNode!.unfocus();
            });
          },
          onChanged: (value) {
            if (value == "") {
              controller.isSearchEnable.value = false;
            } else {
              controller.isSearchEnable.value = true;
              controller.filterTransaction(value);
            }
          },
          focusNode: focusNode,
          textAlign: TextAlign.left,
          style: CustomStyle.darkHeading3TextStyle.copyWith(
            color: CustomColor.primaryTextColor,
          ),
          keyboardType: TextInputType.text,
          maxLines: 1,
          cursorColor: Theme.of(context).primaryColor,
          decoration: InputDecoration(
            hintText: Strings.enterBankName.tr,
            hintStyle: GoogleFonts.inter(
              fontSize: Dimensions.headingTextSize3,
              fontWeight: FontWeight.w500,
              color: CustomColor.primaryTextColor.withOpacity(0.2),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius * 0.5),
              borderSide: const BorderSide(
                color: CustomColor.transparent,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius * 0.5),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor.withOpacity(0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius * 0.5),
              borderSide:
                  BorderSide(width: 2, color: Theme.of(context).primaryColor),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: Dimensions.heightSize * 1.7,
              vertical: Dimensions.widthSize,
            ),
            suffixIcon: Icon(
              focusNode!.hasFocus ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color:
                  focusNode!.hasFocus ? Theme.of(context).primaryColor : null,
            ),
          ),
        ),
        verticalSpace(Dimensions.heightSize * 0.8),
        Obx(
          () {
            return Visibility(
              visible: controller.isSearchEnable.value,
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.2,
                child: Scrollbar(
                  child: ListView.builder(
                    itemCount: controller.foundChapter.value.length,
                    itemBuilder: (_, index) {
                      var data = controller.foundChapter.value[index];
                      return controller.foundChapter.value.first.name ==
                              Strings.noBankFound
                          ? Container(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: TitleHeading3Widget(
                                      text: data.name,
                                      textOverflow: TextOverflow.fade,
                                      maxLines: 1,
                                      color: CustomColor.redColor,
                                      fontSize: Dimensions.headingTextSize6,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                controller.isSearchEnable.value = false;
                                controller.bankCode.value =
                                    data.code.toString();
                                controller.bankNameController.text = data.name;
                                setState(() {
                                  focusNode!.unfocus();
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(
                                    Dimensions.paddingSize * 0.35),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: TitleHeading3Widget(
                                        text: data.name,
                                        textOverflow: TextOverflow.fade,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                    },
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}

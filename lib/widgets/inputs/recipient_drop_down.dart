// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../backend/model/remittance/remittance_get_recipient_model.dart';
import '../../utils/custom_color.dart';
import '../../utils/custom_style.dart';
import '../../utils/dimensions.dart';

class RecipientDropDown extends StatelessWidget {
  final RxString selectMethod;
  final List<RecipientInfo> itemsList;
  final void Function(RecipientInfo?)? onChanged;

  const RecipientDropDown({
    required this.itemsList,
    Key? key,
    required this.selectMethod,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      height: Dimensions.inputBoxHeight * 0.72,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(Dimensions.radius * 0.5),
      ),
      child: DropdownButtonHideUnderline(
        child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 20),
          child: DropdownButton(
            hint: Padding(
              padding: EdgeInsets.only(left: Dimensions.paddingSize * 0.7),
              child: Text(
                "Account Number",
                style: GoogleFonts.inter(
                    fontSize: Dimensions.headingTextSize4,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor),
              ),
            ),
            icon: const Padding(
              padding: EdgeInsets.only(right: 4),
              child: Icon(
                Icons.arrow_drop_down,
                color: CustomColor.primaryTextColor,
              ),
            ),
            isExpanded: true,
            underline: Container(),
            borderRadius: BorderRadius.circular(Dimensions.radius),
            items: itemsList.map<DropdownMenuItem<RecipientInfo>>((value) {
              return DropdownMenuItem<RecipientInfo>(
                value: value,
                child: Text(
                  "${value.firstname} ${value.lastname}",
                  style: CustomStyle.lightHeading3TextStyle,
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    ));
  }
}

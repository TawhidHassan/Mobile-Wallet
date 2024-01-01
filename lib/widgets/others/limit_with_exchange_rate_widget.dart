import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qrpay/utils/dimensions.dart';
import 'package:qrpay/utils/size.dart';

import '../../utils/strings.dart';

class LimitWithExchangeRateWidget extends StatelessWidget {
  const LimitWithExchangeRateWidget(
      {Key? key,
      required this.fee,
      required this.limit,
      required this.exchangeRate})
      : super(key: key);
  final String fee;
  final String limit;
  final String exchangeRate;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.symmetric(vertical: Dimensions.marginSizeVertical * 0.2),
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
          Text(
            "${Strings.exchangeRate}: $exchangeRate ",
            textAlign: TextAlign.left,
            style: GoogleFonts.inter(
              fontSize: Dimensions.headingTextSize5,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor.withOpacity(0.6),
            ),
          ),
          verticalSpace(Dimensions.heightSize * 0.2),
          Text(
            "${Strings.feesAndCharges}: $fee ",
            textAlign: TextAlign.left,
            style: GoogleFonts.inter(
              fontSize: Dimensions.headingTextSize5,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor.withOpacity(0.6),
            ),
          ),
          verticalSpace(Dimensions.heightSize * 0.2),
          Text(
            "${Strings.limit}: $limit",
            textAlign: TextAlign.left,
            style: GoogleFonts.inter(
              fontSize: Dimensions.headingTextSize5,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}

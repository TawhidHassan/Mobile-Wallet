import 'package:qrpay/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomLoadingAPI extends StatelessWidget {
  const CustomLoadingAPI({
    Key? key,
    this.color = Colors.black,
  }) : super(key: key);
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitDualRing(
        color: Theme
            .of(context)
            .primaryColor,
        size: Dimensions.heightSize * 2.6,
      ),
    );
  }
}

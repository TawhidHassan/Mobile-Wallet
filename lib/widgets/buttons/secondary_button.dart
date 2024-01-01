
import 'package:flutter/material.dart';

import '../../utils/custom_style.dart';
import '../../utils/dimensions.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    Key? key,
    required this.title,
    required this.onPressed,
    required this.borderColorName,
    required this.borderWidth,
    required this.backgroundColorName,
  }) : super(key: key);
  final String title;
  final VoidCallback onPressed;
  final Color borderColorName;
  final Color backgroundColorName;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimensions.buttonHeight,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColorName,
          side: BorderSide(
            width: borderWidth,
            color: borderColorName,
          ),
        ),
        child: Text(
          title,
          style: CustomStyle.darkHeading3TextStyle,
        ),
      ),
    );
  }
}

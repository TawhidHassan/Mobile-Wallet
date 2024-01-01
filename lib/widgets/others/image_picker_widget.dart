
import 'package:flutter/material.dart';

import '../../controller/profile/update_profile_controller.dart';
import '../../utils/dimensions.dart';

openImageSourceOptions(
    BuildContext context, UpdateProfileController controller) {
  showGeneralDialog(
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return Material(
          type: MaterialType.transparency,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              height: Dimensions.heightSize * 13,
              width: Dimensions.widthSize * 25,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Dimensions.radius)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: const Icon(
                          Icons.camera_alt,
                          size: 40.0,
                          color: Colors.blue,
                        ),
                        onTap: () {
                          controller.chooseFromCamera();
                          Navigator.of(context).pop();
                        },
                      ),
                      Text(
                        'from Camera',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: Dimensions.headingTextSize4),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: const Icon(
                          Icons.photo,
                          size: 40.0,
                          color: Colors.green,
                        ),
                        onTap: () {
                          controller.chooseFromGallery();
                          Navigator.of(context).pop();
                        },
                      ),
                      Text(
                        'From Gallery',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: Dimensions.headingTextSize4),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
              .animate(anim),
          child: child,
        );
      });
    }
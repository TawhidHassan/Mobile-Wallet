import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../custom_assets/assets.gen.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/size.dart';
import '../../../utils/strings.dart';
import '../../../views/others/custom_image_widget.dart';
import '../../text_labels/title_heading4_widget.dart';

// ignore: must_be_immutable
class DropFile extends StatefulWidget {
  DropFile({super.key, this.image});

  File? image;

  @override
  State<DropFile> createState() => _DropFileState();
}

class _DropFileState extends State<DropFile> {
  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSize * 0.3,
        vertical: Dimensions.paddingSize * 0.5,
      ),
      radius: Radius.circular(Dimensions.radius * 0.5),
      color: Theme.of(context).primaryColor.withOpacity(0.2),
      strokeWidth: 1,
      child: InkWell(
        onTap: (() {
          openImageSourceOptions(context);
        }),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radius * 0.5),
            image: DecorationImage(
                image: widget.image == null
                    ? const AssetImage("")
                    : FileImage(widget.image!) as ImageProvider,
                scale: 3),
          ),
          alignment: Alignment.center,
          height: Dimensions.heightSize * 5,
          child: widget.image == null
              ? Column(
                  mainAxisAlignment: mainCenter,
                  children: [
                    CustomImageWidget(path: Assets.icon.upload),
                    verticalSpace(Dimensions.heightSize * 0.5),
                    TitleHeading4Widget(
                      text: Strings.dropYourFile.tr,
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      fontSize: Dimensions.headingTextSize5,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                )
              : Container(),
        ),
      ),
    );
  }

  final picker = ImagePicker();

  Future chooseFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      widget.image = File(pickedFile.path);
      setState(() {});
    } else {}
  }

  Future chooseFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      widget.image = File(pickedFile.path);
      setState(() {});
    } else {}
  }

  openImageSourceOptions(
    BuildContext context,
  ) {
    showGeneralDialog(
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
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
                            chooseFromCamera();
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
                            chooseFromGallery();
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
}

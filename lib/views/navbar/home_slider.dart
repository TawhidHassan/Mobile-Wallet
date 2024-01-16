import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller/navbar/dashboard_controller.dart';


class HomeSlider extends StatelessWidget {
  HomeSlider({Key? key}) : super(key: key);
  final controller = Get.put(DashBoardController());

  @override
  Widget build(BuildContext context) {
    controller.getSlider();
    return GetBuilder<DashBoardController>(
      assignId: true,
      builder: (logic) {
        return Obx(() {
          return logic.circuler.value?
          Column(
            children: [
              Container(
                  height: 60,
                  width: 60,
                  child: CircularProgressIndicator()),
            ],
          ):Column(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                    enlargeCenterPage: true,
                    viewportFraction: 0.95,
                    enableInfiniteScroll: false,
                    autoPlay: true,
                    aspectRatio: 15 / 6,
                    // enlargeFactor: 0.3,
                    // enlargeCenterPage: true,
                    onPageChanged: (int page, css) {
                      // controller.currentIndex.value = page;
                    }
                ),
                items: logic.sliderModel.data!.map((slider) {
                  return Builder(
                    builder: (BuildContext context) {
                      return CachedNetworkImage(
                        imageUrl: slider!.imageurl!,
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator(),),
                        imageBuilder: (context, image) =>
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                      image: image,
                                      fit: BoxFit.fill
                                  )
                              ),
                            ),
                      );
                    },
                  );
                }).toList(),
              ),
              // SizedBox(height: 10.h,),
              // CarouselIndicator(
              //   height: 8.h,
              //   color: Colors.blueAccent.shade100,
              //   activeColor: Colors.blueAccent,
              //   count: logic.sliderModel.data!.length,
              //   index: 1,
              // )
            ],
          );
        });
      },
    );
  }
}
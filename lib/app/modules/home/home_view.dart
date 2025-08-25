import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animation'), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Obx(() {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (Color color in controller.currentPalette)
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,

                    width: 100,
                    height: 100,
                    color: color,
                    margin: EdgeInsets.symmetric(vertical: 3),
                  ),
                SizedBox(height: 20),
                InkWell(
                  onTap: controller.generateColorPalette,
                  child: Container(
                    decoration: BoxDecoration(
                      color: controller.currentPalette[0],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Text(
                      'Change Color',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                InkWell(
                  onTap: () {
                    controller.isExpanded.value = !controller.isExpanded.value;
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeInOut,
                    width: controller.isExpanded.value ? 150 : 100,
                    decoration: BoxDecoration(
                      color: controller.isExpanded.value
                          ? controller.currentPalette[2]
                          : controller.currentPalette[1],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: controller.isExpanded.value
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          controller.isExpanded.value
                              ? Icons.check
                              : Icons.shopping_cart,
                        ),
                        if (controller.isExpanded.value)
                          Expanded(
                            child: Text(
                              'Add To cart',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

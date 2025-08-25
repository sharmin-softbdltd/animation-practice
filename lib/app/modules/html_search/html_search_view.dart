import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import 'html_search_controller.dart';

class HtmlSearchView extends GetView<HtmlSearchController> {
  const HtmlSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent.withValues(alpha: 0.5),
        title: Text(
          'Html Search',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Obx(() {
                return TextFormField(
                  controller: controller.searchController,

                  decoration: InputDecoration(
                    hintText: 'Search...',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffix: controller.matchQueryCount.value != 0
                        ? Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(controller.matchQueryCount.value.toString()),
                        SizedBox(width: 5),
                        InkWell(
                          onTap: controller.nextMatch,
                          child: Icon(Icons.keyboard_arrow_down),
                        ),
                      ],
                    )
                        : null,
                  ),
                );
              }),
              Expanded(
                child: SingleChildScrollView(
                  controller: controller.scrollController,
                  child: Column(
                    children: [
                      Obx(() {
                        return Html(
                          data: controller.highLightedContent.value,
                          // anchorKey: controller.anchorKey,
                          doNotRenderTheseTags: {"title",},

                        );
                      }),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Get.toNamed(Routes.HOME);
                        },
                        child: Text('Go To Home'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';

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
              TextFormField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // suffix: controller.totalMatchedWord.value != 0
                  //     ? Row(
                  //         mainAxisSize: MainAxisSize.min,
                  //         mainAxisAlignment: MainAxisAlignment.end,
                  //         crossAxisAlignment: CrossAxisAlignment.center,
                  //         children: [
                  //           Text(
                  //             "${controller.currentWordCount.value}/${controller.totalMatchedWord.value}",
                  //           ),
                  //           SizedBox(width: 5),
                  //           if (controller.totalMatchedWord.value > 1)
                  //             Column(
                  //               mainAxisSize: MainAxisSize.min,
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 SizedBox(
                  //                   height: 10,
                  //                   child: Center(
                  //                     child: InkWell(
                  //                       onTap: controller.prevMatch,
                  //                       child: Icon(
                  //                         Icons.keyboard_arrow_up,
                  //                         size: 15,
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 SizedBox(
                  //                   height: 10,
                  //                   child: Center(
                  //                     child: InkWell(
                  //                       onTap: controller.nextMatch,
                  //                       child: Icon(
                  //                         Icons.keyboard_arrow_down,
                  //                         size: 15,
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //         ],
                  //       )
                  //     : null,
                ),
              ),

              Expanded(
                child: Obx(() {
                  return SingleChildScrollView(
                    controller: controller.scrollController,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(controller.blocks.length, (
                        index,
                      ) {
                        final html = controller.highlightBlock(
                          controller.blocks[index],
                          index,
                        );
                        return Container(
                          key: controller.blockKeys[index],
                          margin: const EdgeInsets.only(bottom: 12),
                          child: HtmlWidget(html),
                        );
                      }),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:get/get.dart';

import 'html_search_controller.dart';

class HtmlSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HtmlSearchController>(() => HtmlSearchController());
  }
}

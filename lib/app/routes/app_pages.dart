import 'package:get/get.dart';

import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/html_search/html_search_binding.dart';
import '../modules/html_search/html_search_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HTML_SEARCH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.HTML_SEARCH,
      page: () => const HtmlSearchView(),
      binding: HtmlSearchBinding(),
    ),
  ];
}

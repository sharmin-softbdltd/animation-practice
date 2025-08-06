import 'dart:math';
import 'dart:ui';

import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxList<Color> currentPalette = <Color>[].obs;

  @override
  void onInit() {
    generateColorPalette();
    super.onInit();
  }

  void generateColorPalette() {
    final random = Random();
    final newColorPalette = List.generate(
      5,
      (_) => Color.fromRGBO(
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
        1,
      ),
    );
    currentPalette.value = newColorPalette;
  }
}

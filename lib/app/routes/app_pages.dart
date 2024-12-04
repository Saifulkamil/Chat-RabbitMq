// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/send_mesege1/bindings/send_mesege1_binding.dart';
import '../modules/send_mesege1/views/send_mesege1_view.dart';
import '../modules/send_mesege2/bindings/send_mesege2_binding.dart';
import '../modules/send_mesege2/views/send_mesege2_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SEND_MESEGE1,
      page: () => const SendMesege1View(),
      binding: SendMesege1Binding(),
    ),
    GetPage(
      name: _Paths.SEND_MESEGE2,
      page: () => const SendMesege2View(),
      binding: SendMesege2Binding(),
    ),
  ];
}

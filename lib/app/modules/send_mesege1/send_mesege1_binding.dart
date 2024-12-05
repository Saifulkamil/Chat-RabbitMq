import 'package:get/get.dart';

import 'send_mesege1_controller.dart';

class SendMesege1Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SendMesege1Controller>(
      () => SendMesege1Controller(),
    );
  }
}

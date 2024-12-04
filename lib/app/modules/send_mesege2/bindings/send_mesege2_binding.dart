import 'package:get/get.dart';

import '../controllers/send_mesege2_controller.dart';

class SendMesege2Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SendMesege2Controller>(
      () => SendMesege2Controller(),
    );
  }
}

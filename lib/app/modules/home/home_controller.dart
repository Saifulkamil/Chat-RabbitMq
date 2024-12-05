import 'package:get/get.dart';
import 'package:rabbitmq_client/app/services/rabbitmq_service.dart';

import '../../services/backgorund_service.dart';

class HomeController extends GetxController {
  BackgroundService backgroundService = BackgroundService();

  RabbitmqService rabbitmqService = RabbitmqService();
  

}

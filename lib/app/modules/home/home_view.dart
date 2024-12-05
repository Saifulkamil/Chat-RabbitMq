import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

import 'package:get/get.dart';
import 'package:rabbitmq_client/app/routes/app_pages.dart';

import '../../data/response_call.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('HomeView'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Get.toNamed(Routes.SEND_MESEGE1);
                  },
                  child: const Text("mesege 1 >>>")),
              const SizedBox(
                height: 50,
              ),
              const SizedBox(
                height: 100,
              ),
              ElevatedButton(
                onPressed: () {
                  FlutterBackgroundService().invoke("setAsForeground");
                },
                child: const Text("Foreground service"),
              ),
              ElevatedButton(
                onPressed: () {
                  FlutterBackgroundService().invoke("setAsBackground");
                },
                child: const Text("Background service"),
              ),
              Obx(() => ElevatedButton(
                    onPressed: () async {
                      final service = FlutterBackgroundService();
                      bool isRunning = await service.isRunning();
                      if (isRunning) {
                        service.invoke("setAsStop");
                      } else {
                        service.startService();
                      }
                      if (!isRunning) {
                        controller.backgroundService.seriveText.value =
                            "Service Stop";
                        controller.rabbitmqService.rabbitmqCall =
                            ResponseCall.iddle("iddle");
                      } else {
                        controller.backgroundService.seriveText.value =
                            "Service Start";
                      }
                    },
                    child: Text(controller.backgroundService.seriveText.value),
                  )),
              ElevatedButton(
                onPressed: () {
                  // NotificationService.showNotification(
                  //     23, "haiii", "notif ini sepol", "content");
                },
                child: const Text('Tampilkan Notifikasi'),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ));
  }
}

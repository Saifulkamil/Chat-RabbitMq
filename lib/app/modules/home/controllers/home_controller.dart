import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxString seriveText = "Service stop".obs;

  Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    await service.configure(
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onServiceStart,
        onBackground: onIosBackground,
      ),
      androidConfiguration: AndroidConfiguration(
        onStart: onServiceStart,
        isForegroundMode: true,
        autoStart: false,
        // foregroundServiceTypes: [AndroidForegroundType.location]
      ),
    );
  }

  @pragma('vm:entry-point')
  Future<bool> onIosBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    return true;
  }
}

// Fungsi top-level untuk background service
@pragma('vm:entry-point')
void onServiceStart(ServiceInstance service) async {
  var text = "service background";

  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      text = "service foreground";
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
      text = "service background";
    });
  }

  service.on('setAsStop').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(
    Duration(seconds: 1),
    (timer) async {
      debugPrint(text);
      if (service is AndroidServiceInstance) {}
      debugPrint(text);
      service.invoke("update");
    },
  );
}

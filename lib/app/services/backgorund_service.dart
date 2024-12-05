import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:rabbitmq_client/app/data/local.dart';
import 'package:rabbitmq_client/app/services/rabbitmq_service.dart';


class BackgroundService {
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
  String? datadiri;
  RabbitmqService rabbitmqService = RabbitmqService();
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
  bool isConnected = false; // Variabel untuk memantau status koneksi
  Timer.periodic(
    const Duration(seconds: 1),
    (timer) async {
      debugPrint(text);
      if (service is AndroidServiceInstance) {
        debugPrint(text);

        final data = await LocalStorage.getDataMe();
        if (data.isNotEmpty) {
          datadiri = data;
          if (isConnected == true) {
            isConnected = true; // Set connected setelah berhasil terkoneksi
            await rabbitmqService.connectRabbitMQBGServer(datadiri!);
          } else {
            debugPrint("already connected");
          }
        } else {
          debugPrint("no data diri");
        }
      
      }
      debugPrint(text);
      service.invoke("update");
    },
  );
}

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:rabbitmq_client/app/modules/home/controllers/home_controller.dart';
import 'package:rabbitmq_client/permision.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PermisionMain.requestExactAlarmPermission();
  await PermisionMain.requestNotifikasiPermission();

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}

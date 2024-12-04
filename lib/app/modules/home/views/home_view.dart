import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:rabbitmq_client/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

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
                  child: Text("mesege 1 >>>")),
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                  onPressed: () {
                    Get.toNamed(Routes.SEND_MESEGE2);
                  },
                  child: Text("mesege 2 >>>")),
            ],
          ),
        ));
  }
}

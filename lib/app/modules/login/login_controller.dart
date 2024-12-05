import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rabbitmq_client/app/data/local.dart';

import '../../routes/app_pages.dart';

class LoginController extends GetxController {
  RxBool isHidden = true.obs;
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();
  String datauser = "user";
  String dataAdmin = "admin";

  Future<bool> login(String name) async {
    if (datauser == name) {
      try {
        await LocalStorage.saveDataProfile(datauser);

        Get.offAllNamed(Routes.HOME);
        return true;
      } catch (e) {
        debugPrint("$e");
      }
    } else if (dataAdmin == name) {
      try {
        await LocalStorage.saveDataProfile(dataAdmin);

        Get.offAllNamed(Routes.HOME);
        return true;
      } catch (e) {
        debugPrint("$e");
      }
    }
    return false;
  }
}

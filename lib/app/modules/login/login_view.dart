import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:rabbitmq_client/app/utils/component/custom_elevated_buttom.dart';
import 'package:rabbitmq_client/app/services/backgorund_service.dart';

import '../../utils/colors.dart';
import '../../utils/component/custom_text_form_field.dart';
import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorTransparan,
        appBar: null,
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                coklatMain,
                coklatBlackMain,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Text(
                  "Login",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: ColorApp.whiteTextStyly(context)
                      .copyWith(fontSize: 35, fontWeight: extraBold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: whiteMainColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3.5,
                        blurRadius: 7,
                        offset:
                            const Offset(1, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            "Nama",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: ColorApp.blackTextStyle(context)
                                .copyWith(fontSize: 16, fontWeight: reguler),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CustomTextFormField(
                            textEditingController: controller.emailC,
                            iconPrefix: const Icon(
                              Icons.perm_identity_rounded,
                              color: greyColor,
                            ),
                            obscure: false,
                            text: "nama"),
                        const SizedBox(
                          height: 15,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomElevatedButtom(
                    text: "MASUK",
                    fontSize: 20,
                    fontWeight: bold,
                    colorText: coklatBlackMain,
                    onPressed: () async {
                      BackgroundService backgroundService = BackgroundService();
                      await backgroundService.initializeService();

                      controller.login(controller.emailC.text);
                    },
                    colorBackgroud: coklaOpasiti,
                    borderRadius: 30,
                    colorBorder: coklatMain),
                const SizedBox(
                  height: 65,
                ),
              ],
            ),
          ),
        ));
  }
}

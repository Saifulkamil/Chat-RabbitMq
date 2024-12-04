import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/send_mesege2_controller.dart';

class SendMesege2View extends GetView<SendMesege2Controller> {
  const SendMesege2View({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Masege 2'),
        centerTitle: true,
      ),
      body: Obx(() => Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Expanded(
                    child: Obx(() => ListView.builder(
                          reverse: true,
                          itemCount: controller.receivedMessages.length +
                              (controller.typing.value ? 1 : 0),
                          itemBuilder: (context, index) {
                            // Periksa apakah ini indeks untuk "Mengetik"
                            if (controller.typing.value && index == 0) {
                              return const Row(
                                children: [
                                  Card(
                                    shadowColor:
                                        Color.fromARGB(255, 34, 128, 37),
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Mengetik..."),
                                    ),
                                  ),
                                ],
                              );
                            }

                            // Hitung indeks pesan yang benar
                            final messageIndex =
                                controller.typing.value ? index - 1 : index;
                            if (messageIndex < 0 ||
                                messageIndex >=
                                    controller.receivedMessages.length) {
                              return const SizedBox
                                  .shrink(); // Hindari error dengan widget kosong
                            }

                            final data = controller.receivedMessages[
                                controller.receivedMessages.length -
                                    1 -
                                    messageIndex];

                            return Row(
                              mainAxisAlignment: data.sender == "page2"
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Card(
                                    color: data.sender == "page2"
                                        ? const Color.fromARGB(255, 34, 128, 37)
                                        : Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data.message!,
                                            style: TextStyle(
                                              color: data.sender != "page2"
                                                  ? const Color.fromARGB(
                                                      255, 34, 128, 37)
                                                  : Colors.white,
                                            ),
                                          ),
                                          Text(
                                            'Message #${data.sender}',
                                            style: TextStyle(
                                              color: data.sender != "page2"
                                                  ? const Color.fromARGB(
                                                      255, 34, 128, 37)
                                                  : Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ))),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextFormField(
                        onTapOutside: (event) {
                          controller.typingOff();
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        onTap: () {
                          controller.typingOn();
                        },
                        focusNode: controller.focusNode,
                        controller: controller.textController,
                        decoration: InputDecoration(
                          labelText: 'Enter message',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                    Obx(() => IconButton(
                          onPressed: () async {
                            if (controller.textController.text.isNotEmpty) {
                              final result = await controller
                                  .sendMessage(controller.textController.text);
                              if (result) {
                                controller.textController.clear();
                              }
                            }
                          },
                          icon: Icon(Icons.send),
                        )),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      controller.connectRabbitMQ();
                    },
                    child: Text(controller.textConnection.value),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

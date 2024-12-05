import 'dart:convert';

import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rabbitmq_client/app/data/local.dart';

import '../../data/models/model_chat.dart';
import '../../data/response_call.dart';

class SendMesege1Controller extends GetxController {
  // final String typingQueue = "tippingqueue";

  RxBool typing = false.obs;
  TextEditingController textController = TextEditingController();
  FocusNode focusNode = FocusNode();
  RxString textConnection = "Connect".obs;
  final String exchangeName = 'notifikasi_exc';
  String? routingKey;
  String? queueName;
  final String admin = 'admin';
  final String user = 'user';
  Client? _client;
  Channel? _channel;
  Consumer? _consumer;
  int id = 1;
  bool durable = true;
  String? datadiri;
  RxList<ModelChat> receivedMessages = <ModelChat>[].obs;

  ModelChat? modelChat;
  ResponseCall rabbitmqCall = ResponseCall.iddle("iddle");

  @override
  void onInit() {
    super.onInit();
    connectRabbitMQ();
    fetchDataProfile();
  }

  Future<void> fetchDataProfile() async {
    getDetailProfile();
  }

  Future<void> getDetailProfile() async {
    try {
      final data = await LocalStorage.getDataMe();
      if (data.isNotEmpty) {
        datadiri = data;
        queueName = data;
        routingKey = data;
      }
    } catch (e) {
      debugPrint("$e");
    }
  }

  Future<bool> sendMessage(String message) async {
    if (datadiri!.isNotEmpty) {
      final int currentId = id++;
      final Map<String, dynamic> messageMap = {
        "id": currentId,
        "sender": datadiri,
        'message': message,
        'publicKey': 'publicKey',
        'status': false,
        'isRead': false // Add isRead field
      };
      try {
        final Exchange exchange = await _channel!
            .exchange(exchangeName, ExchangeType.DIRECT, durable: true);
        ModelChat chatMessage = ModelChat.fromJson(messageMap);
        receivedMessages.add(chatMessage);
        if (datadiri == "admin") {
          exchange.publish(messageMap, "$routingKey>$user");
          debugPrint('admin Sent: $messageMap');
        } else {
          exchange.publish(messageMap, "$routingKey>$admin");
          debugPrint('user Sent: $messageMap');
        }

        return true;
      } catch (e) {
        debugPrint('Error sending message: $e');
        return false;
      }
    } else {
      debugPrint('Data profile is empty. Cannot send message.');
      return false;
    }
  }

  // Add new method to mark messages as read
  Future<void> markMessageAsRead(ModelChat message) async {
    if (message.sender != datadiri) {
      receivedMessages.add(message);
      final Map<String, dynamic> readStatusMap = {
        "id": message.id,
        "sender": message.sender,
        "message": message.message,
        "publicKey": message.publicKey,
        "status": true,
        "isRead": true
      };

      final Exchange exchange = await _channel!
          .exchange(exchangeName, ExchangeType.DIRECT, durable: true);

      if (datadiri == "admin") {
        exchange.publish(readStatusMap, "$routingKey>$user");
      } else {
        exchange.publish(readStatusMap, "$routingKey>$admin");
      }
    }
  }

  Future<bool> typingOn() async {
    try {
      final Exchange exchange = await _channel!
          .exchange(exchangeName, ExchangeType.DIRECT, durable: true);

      if (datadiri == "admin") {
        exchange.publish("true", "$routingKey>$user");
        debugPrint('Sent admin: ON TYPING true');
      } else {
        exchange.publish("true", "$routingKey>$admin");
        debugPrint('Sent user: ON TYPING true');
      }

      return true;
    } catch (e) {
      debugPrint('Error sending typing: $e');
      return false;
    }
  }

  Future<bool> typingOff() async {
    try {
      final Exchange exchange = await _channel!
          .exchange(exchangeName, ExchangeType.DIRECT, durable: true);

      if (datadiri == "admin") {
        exchange.publish("false", "$routingKey>$user");
        debugPrint('Sent admin: ON TYPING false');
      } else {
        exchange.publish("false", "$routingKey>$admin");
        debugPrint('Sent user: ON TYPING false');
      }
      debugPrint('Sent: ON TYPING false');

      return true;
    } catch (e) {
      debugPrint('Error sending message: $e');
      return false;
    }
  }

  Future<bool> connectRabbitMQ() async {
    try {
      _client = Client(
          settings: ConnectionSettings(
        authProvider: const PlainAuthenticator('guest', 'guest'),
        host: '10.0.2.2',
        port: 5672,
        virtualHost: '/',
      ));
      await _client!.connect();
      _channel = await _client!.channel();

      if (_channel != null) {
        debugPrint("connected");
        rabbitmqCall = ResponseCall.completed("completed");

        textConnection.value = "Connected";
      } else {
        textConnection.value = "Failed to connect queue";
      }
      final Exchange exchange = await _channel!.exchange(
        exchangeName, // Name of the exchange
        ExchangeType.DIRECT, // Type of the exchange
        durable: true, // Make the exchange durable
      );
      debugPrint("nama exchange: ${exchange.name}");
      debugPrint("type exchange: ${exchange.type}");

      // Store queue reference
      Queue queue = await _channel!.queue(
        queueName!,
        durable: durable,
        arguments: {
          'x-queue-type': 'quorum',
        },
      );

      if (rabbitmqCall.status == Status.completed) {
        if (datadiri == "admin") {
          await queue.bind(exchange, "$user>$routingKey");
        } else {
          await queue.bind(exchange, "$admin>$routingKey");
        }

        debugPrint("queue name: ${queue.name}");

        _consumer = await queue.consume();
        _consumer!.listen(
          (AmqpMessage message) async {
            debugPrint('Received:sdfsdfsdf ${message.payloadAsString}');
            debugPrint('replyTo: ${message.properties?.replyTo}');
            if (message.payloadAsString == "true") {
              typing.value = true;
            } else if (message.payloadAsString == "false") {
              typing.value = false;
            } else {
              try {
                Map<String, dynamic> jsonData =
                    jsonDecode(message.payloadAsString);
                ModelChat receivedChatMessage = ModelChat.fromJson(jsonData);
                for (var chat in receivedMessages) {
                  chat.status!.value = true;
                  chat.isRead!.value = true;
                }

                await markMessageAsRead(receivedChatMessage);
              } catch (e) {
                debugPrint('Error decoding message: $e');
              }
            }
            // Return true jika koneksi berhasil
          },
          onDone: () {
            debugPrint('Consumer done');
          },
        );
      }
      return true;
    } catch (e) {
      textConnection.value = "Connection Failed ❌";
      debugPrint('Error connecting to RabbitMQ: $e');
      // Return true jika koneksi berhasil
      return false;
    }
  }

  @override
  void onClose() {
    super.onClose();
    _consumer?.cancel();
    _client?.close();
  }
}

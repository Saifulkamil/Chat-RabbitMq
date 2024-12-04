import 'dart:convert';

import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rabbitmq_client/app/data/local.dart';

import '../../../data/models/model_chat.dart';
import '../../../data/response_call.dart';

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
  bool durable = true;
  String? datadiri;
  RxList<ModelChat> receivedMessages = <ModelChat>[].obs;

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
      final Map<String, dynamic> messageMap = {
        "sender": datadiri,
        'message': message,
      };
      try {
        final Exchange exchange = await _channel!
            .exchange(exchangeName, ExchangeType.DIRECT, durable: true);
        ModelChat chatMessage = ModelChat.fromJson(messageMap);
        receivedMessages.add(chatMessage);
        if (datadiri == "admin") {
          exchange.publish(messageMap, "$routingKey>$user");
          debugPrint('admin Sent: $message');
        } else {
          exchange.publish(messageMap, "$routingKey>$admin");
          debugPrint('user Sent: $message');
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

  Future<void> connectRabbitMQ() async {
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
      if (datadiri == "admin") {
        await queue.bind(exchange, "$user>$routingKey");
      } else {
        await queue.bind(exchange, "$admin>$routingKey");
      }

      debugPrint("queue name: ${queue.name}");

      // Konsumsi pesan dari queue utama
      _consumer = await queue.consume();
      _consumer!.listen((AmqpMessage message) {
        debugPrint('Received: ${message.payloadAsString}');
        debugPrint('replyTo: ${message.properties?.replyTo}');

        // Jika pesan adalah "true" atau "false", tidak perlu decode JSON
        if (message.payloadAsString == "true") {
          typing.value = true; // Tampilkan "Mengetik"
        } else if (message.payloadAsString == "false") {
          typing.value = false; // Sembunyikan "Mengetik"
        } else {
          // Pesan berupa JSON yang valid, dekode pesan
          try {
            Map<String, dynamic> jsonData = jsonDecode(message.payloadAsString);
            String sender = jsonData['sender'];

            // Periksa jika sender bukan 'datadiri'
            if (datadiri != sender) {
              ModelChat chatMessage = ModelChat.fromJson(jsonData);
              receivedMessages.add(chatMessage);
            }
          } catch (e) {
            debugPrint('Error decoding message: $e');
          }
        }
      });
    } catch (e) {
      textConnection.value = "Connection Failed ❌";
      debugPrint('Error connecting to RabbitMQ: $e');
    }
  }

  @override
  void onClose() {
    super.onClose();
    _consumer?.cancel();
    _client?.close();
  }
}

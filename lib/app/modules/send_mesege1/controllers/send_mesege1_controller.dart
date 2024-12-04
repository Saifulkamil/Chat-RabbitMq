import 'dart:convert';

import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/model_chat.dart';

class SendMesege1Controller extends GetxController {
  // final String typingQueue = "tippingqueue";

  RxBool typing = false.obs;
  TextEditingController textController = TextEditingController();
  FocusNode focusNode = FocusNode();
  RxString textConnection = "Connect".obs;
  final String queueName = 'notifikasiqueue';
  final String exchangeName = 'notifikasi_exc';
  final String routingPush = 'pesan>page2';
  final String routingRecevi = 'pesan>page1';
  Client? _client;
  Channel? _channel;
  Consumer? _consumer;
  bool durable = true;
  RxList<ModelChat> receivedMessages = <ModelChat>[].obs;

  @override
  void onInit() {
    super.onInit();
    connectRabbitMQ();
  }

  Future<bool> sendMessage(String message) async {
    final Map<String, dynamic> messageMap = {
      "sender": "page1",
      'message': message,
    };
    try {
      final Exchange exchange = await _channel!
          .exchange(exchangeName, ExchangeType.DIRECT, durable: true);
      ModelChat chatMessage = ModelChat.fromJson(messageMap);
      receivedMessages.add(chatMessage);
      exchange.publish(messageMap, routingPush);

      debugPrint('Sent: $message');
      return true;
    } catch (e) {
      debugPrint('Error sending message: $e');
      return false;
    }
  }

  Future<bool> typingOn() async {
    try {
      final Exchange exchange = await _channel!
          .exchange(exchangeName, ExchangeType.DIRECT, durable: true);

      exchange.publish("true", routingPush);

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

      exchange.publish("false", routingPush);
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
        queueName,
        durable: durable,
        arguments: {
          'x-queue-type': 'quorum',
        },
      );

      await queue.bind(exchange, routingRecevi);

      debugPrint("queue name: ${queue.name}");

      // Konsumsi pesan dari queue utama
      _consumer = await queue.consume();
      _consumer!.listen((AmqpMessage message) {
        debugPrint('Received: ${message.payloadAsString}');
        debugPrint('replyTo: ${message.properties?.replyTo}');

        if (message.payloadAsString != "true" &&
            message.payloadAsString != "false") {
          Map<String, dynamic> jsonData = jsonDecode(message.payloadAsString);
          ModelChat chatMessage = ModelChat.fromJson(jsonData);
          receivedMessages.add(chatMessage);
        } else if (message.payloadAsString == "true") {
          typing.value = true; // Tampilkan "Mengetik"
        } else if (message.payloadAsString == "false") {
          typing.value = false; // Sembunyikan "Mengetik"
        } else {
          debugPrint('No reply-to property specified in the incoming message');
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

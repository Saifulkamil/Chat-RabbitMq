import 'dart:convert';

import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/local.dart';
import '../data/models/model_chat.dart';
import '../data/response_call.dart';

class RabbitmqService {
  bool isConnected = false;
  Client? _client;
  Channel? _channel;
  final String exchangeName = 'notifikasi_exc';
  Consumer? _consumer;
  String? queueName;
  bool durable = true;
  String? datadiri;
  String? routingKey;
  final String admin = 'admin';
  final String user = 'user';
  RxList<ModelChat> receivedMessages = <ModelChat>[].obs;

  ResponseCall rabbitmqCall = ResponseCall.iddle("iddle");

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

  Future<bool> connectRabbitMQBGServer(String datadiri) async {
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
        isConnected = true;
      } else {}
      final Exchange exchange = await _channel!.exchange(
        exchangeName, // Name of the exchange
        ExchangeType.DIRECT, // Type of the exchange
        durable: true, // Make the exchange durable
      );
      debugPrint("nama exchange: ${exchange.name}");
      debugPrint("type exchange: ${exchange.type}");

      // Store queue reference
      queueName = datadiri;
      Queue queue = await _channel!.queue(
        queueName!,
        durable: durable,
        arguments: {
          'x-queue-type': 'quorum',
        },
      );
      if (rabbitmqCall.status == Status.completed) {
        if (datadiri.isNotEmpty && datadiri == "admin") {
          await queue.bind(exchange, "$user>$routingKey");
        } else {
          await queue.bind(exchange, "$admin>$routingKey");
        }

        debugPrint("queue name: ${queue.name}");

        _consumer = await queue.consume();
        _consumer!.listen((AmqpMessage message) async {
          debugPrint('Received:sdfsdfsdf ${message.payloadAsString}');
          debugPrint('replyTo: ${message.properties?.replyTo}');

          try {
            Map<String, dynamic> jsonData = jsonDecode(message.payloadAsString);
            ModelChat receivedChatMessage = ModelChat.fromJson(jsonData);
            if (jsonData.isNotEmpty) {
              // NotificationService.showNotification(
              //     23, "dfgdfgd", "notif ini sepol", "content");
            }
            receivedMessages.add(receivedChatMessage);
          } catch (e) {
            debugPrint('Error decoding message: $e');
          }
        }, onError: (error) {
          debugPrint('Error: $error');
        }, onDone: () {
          isConnected = true;
          if (rabbitmqCall.status == Status.iddle) {
            _channel!.close();
            _consumer!.cancel();
          }
          debugPrint('Consumer done');
        });
      }

      return true;
    } catch (e) {
      debugPrint('Error connecting to RabbitMQ: $e');
      return false;
    }
  }
}

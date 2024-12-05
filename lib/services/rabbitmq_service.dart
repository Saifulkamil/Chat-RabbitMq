import 'dart:convert';

import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter/material.dart';

import '../app/data/local.dart';
import '../app/data/models/model_chat.dart';

class RabbitmqService {
  Client? _client;
  Channel? _channel;
  final String exchangeName = 'notifikasi_exc';
  Consumer? _consumer;
  String? queueName;
  bool durable = true;
  String? datadiri;
  String? routingKey;

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
      // if (datadiri == "admin") {
      //   await queue.bind(exchange, "$user>$routingKey");
      // } else {
      //   await queue.bind(exchange, "$admin>$routingKey");
      // }

      debugPrint("queue name: ${queue.name}");

      _consumer = await queue.consume();
      _consumer!.listen((AmqpMessage message) async {
        debugPrint('Received:sdfsdfsdf ${message.payloadAsString}');
        debugPrint('replyTo: ${message.properties?.replyTo}');

        try {
          Map<String, dynamic> jsonData = jsonDecode(message.payloadAsString);
          ModelChat receivedChatMessage = ModelChat.fromJson(jsonData);
        } catch (e) {
          debugPrint('Error decoding message: $e');
        }
      });
    } catch (e) {
      debugPrint('Error connecting to RabbitMQ: $e');
    }
  }
}

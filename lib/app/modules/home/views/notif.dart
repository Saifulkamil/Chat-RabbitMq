import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../../routes/app_pages.dart';

class NotificationService {
  static final onCliknotif = BehaviorSubject<String>();

  static void onTapNotifikasi(NotificationResponse notificationResponse) {
    onCliknotif.add(notificationResponse.payload!);
  }

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
            '@mipmap/ic_launcher'); // Use default app icon

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onTapNotifikasi);

    final details =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      final payload = details.notificationResponse?.payload;
      if (payload != null) {
        onTapNotifikasi(details.notificationResponse!);
      }
    }
  }

  static Future<void> showNotification(
      int id, String? title, String? body, String? payload) async {
    // final imageicon = await Utils.downloadFile(
    //     'https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcR2f1n0xOHEDlEMVLH0Tdv0PIYeKk3FzgG3ShEpkqrStTsxpYN4',
    //     'notification_Icon.jpg');
    // final imagePath = await Utils.downloadFile(
    //     'https://digiagri.digibizdev.online/assets/img/logo_dark.png',
    //     'notification_image.jpg');

    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      // styleInformation: BigPictureStyleInformation(
      //     FilePathAndroidBitmap(imagePath),
      //     largeIcon: FilePathAndroidBitmap(imageicon)),
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'Your channel description',
      icon: "image",
      color: Colors.green,
    );

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
    );
  }
}

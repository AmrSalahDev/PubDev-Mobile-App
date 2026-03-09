import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tapped logic here
      },
    );

    // FCM Permissions
    await _fcm.requestPermission(alert: true, badge: true, sound: true);

    // Print FCM Token for debugging
    final token = await _fcm.getToken();
    print("FCM Token: $token");

    // Handle Foreground Messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showNotification(
          id: message.hashCode,
          title: message.notification!.title ?? '',
          body: message.notification!.body ?? '',
        );
      }
    });

    // Subscribe to topics
    await _fcm.subscribeToTopic('new_packages');
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'new_packages_channel',
          'New Packages',
          channelDescription:
              'Notifications for newly published pub.dev packages',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: platformChannelSpecifics,
      payload: 'item x',
    );
  }
}

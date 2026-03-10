import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pub_dev_packages_app/core/routes/app_paths.dart';
import 'package:pub_dev_packages_app/core/routes/app_router.dart';
import 'notification_service.dart';
import 'package:pub_dev_packages_app/core/di/di.dart';

@LazySingleton()
class FCMService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init() async {
    // FCM Permissions
    await _fcm.requestPermission(alert: true, badge: true, sound: true);

    // Print FCM Token for debugging
    final token = await _fcm.getToken();
    print("FCM Token: $token");

    // Handle Foreground Messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        final String? packageName = message.data['package_name'] ??
            message.data['packageName'] ??
            message.data['package'];
        getIt<NotificationService>().showNotification(
          id: message.hashCode,
          title: message.notification!.title ?? '',
          body: message.notification!.body ?? '',
          payload: packageName,
        );
      }
    });

    // Handle Background & Terminated Message Taps
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _handleMessage(initialMessage);
      });
    }

    // Subscribe to topics
    await _fcm.subscribeToTopic('new_packages');
  }

  void _handleMessage(RemoteMessage message) {
    debugPrint('FCM message tapped: ${message.data}');
    final packageName = message.data['package_name'] ??
        message.data['packageName'] ??
        message.data['package'];

    if (packageName != null) {
      debugPrint('Navigating to packageDetail with packageName: $packageName');
      AppRouter.router.push(AppPaths.packageDetail, extra: packageName);
    } else {
      debugPrint('No package name found in FCM message data');
    }
  }

}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Handle background message
}

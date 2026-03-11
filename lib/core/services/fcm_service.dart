import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';
import 'package:pub_dev_packages_app/core/routes/app_paths.dart';
import 'package:pub_dev_packages_app/core/routes/app_router.dart';
import 'package:talker/talker.dart';
import 'notification_service.dart';
import 'package:pub_dev_packages_app/core/di/di.dart';

@lazySingleton
class FCMService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final Talker talker;

  FCMService(this.talker);

  Future<void> init() async {
    // FCM Permissions
    await _fcm.requestPermission(alert: true, badge: true, sound: true);

    // Print FCM Token for debugging
    final token = await _fcm.getToken();
    talker.log("FCM Token: $token");

    // Handle Foreground Messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      talker.log('FCM message received: ${message.data}');
      final String? packageName = message.data['package_id'];

      final String? packageDescription = message.data['description'] ??
          message.data['package_description'] ??
          message.data['desc'] ??
          message.data['summary'];

      String title = message.notification?.title ?? 'New Package';
      String body = message.notification?.body ?? '';

      if (packageDescription != null && packageDescription.isNotEmpty) {
        // Append description if available
        if (body.isEmpty) {
          body = packageDescription;
        } else if (!body.contains(packageDescription)) {
          body = "$body\n$packageDescription";
        }
      }

      // Show notification if we have a notification or package data
      if (message.notification != null || packageName != null) {
        getIt<NotificationService>().showNotification(
          id: message.hashCode,
          title: title,
          body: body,
          payload: packageName,
        );
      }
    });

    // Handle Foreground Message Taps
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    // Handle Terminated Message Taps
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Subscribe to topics
    await _fcm.subscribeToTopic('new_packages');
  }

  void _handleMessage(RemoteMessage message) {
    final packageName = message.data['package_id'];

    if (packageName != null) {
      AppRouter.router.push(AppPaths.packageDetail, extra: packageName);
    } else {
      talker.log('No package name found in FCM message data');
    }
  }

}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Handle background message
}

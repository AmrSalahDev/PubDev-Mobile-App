import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:pub_dev_packages_app/core/routes/app_router.dart';
import 'package:pub_dev_packages_app/core/routes/app_paths.dart';
import 'package:talker/talker.dart';

@lazySingleton
class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final Talker talker;

  NotificationService(this.talker);

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleNotificationClick(response.payload);
      },
    );

    // Handle initial notification if app was closed
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await _notificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      final response = notificationAppLaunchDetails!.notificationResponse;
      if (response != null) {
        _handleNotificationClick(response.payload);
      }
    }
  }

  void _handleNotificationClick(String? packageName) {
    talker.log('Notification clicked with payload: $packageName');
    if (packageName != null && packageName.isNotEmpty) {
      AppRouter.router.push(AppPaths.packageDetail, extra: packageName);
    } else {
      talker.log('Notification clicked but payload is null or empty');
    }
  }


  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'new_packages_channel',
          'New Packages',
          channelDescription:
              'Notifications for newly published pub.dev packages',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
          showWhen: true,
          when: DateTime.now().millisecondsSinceEpoch,
          styleInformation: BigTextStyleInformation(
            body,
            contentTitle: title,
          ),
        );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: platformChannelSpecifics,
      payload: payload,
    );
  }
}

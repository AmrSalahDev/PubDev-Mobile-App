import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:pub_dev_packages_app/core/l10n/generated/l10n.dart';
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
        if (response.actionId == 'dismiss') {
          talker.log('Notification dismissed via action button');
          if (response.id != null) {
            _notificationsPlugin.cancel(id: response.id!);
          }
          return;
        }
        _handleNotificationClick(response.payload);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // Handle initial notification if app was closed
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await _notificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      final response = notificationAppLaunchDetails!.notificationResponse;
      if (response != null) {
        if (response.actionId == 'dismiss') {
          talker.log('App launched via Dismiss action, doing nothing');
          return;
        }
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
    String viewDetailsLabel = 'View Details';
    String dismissLabel = 'Dismiss';

    try {
      viewDetailsLabel = AppLocalizations.current.viewDetails;
      dismissLabel = AppLocalizations.current.dismiss;
    } catch (_) {
      // Fallback to hardcoded strings if AppLocalizations is not loaded
      talker.log('Failed to load AppLocalizations, using default strings');
    }

    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'new_packages_channel_v3',
          'New Packages',
          channelDescription:
              'Notifications for newly published pub.dev packages',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
          showWhen: true,
          when: DateTime.now().millisecondsSinceEpoch,
        
          playSound: true,
          sound: RawResourceAndroidNotificationSound('new_package_notification'),
          actions: <AndroidNotificationAction>[
            AndroidNotificationAction(
              'view_details',
              viewDetailsLabel,
              showsUserInterface: true,
            ),
            AndroidNotificationAction(
              'dismiss',
              dismissLabel,
              cancelNotification: true,
            ),
          ],
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

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // You don't need to put anything in here!
  // Because you already set `cancelNotification: true` in your button,
  // just having this function allows the system to finally close it.
}

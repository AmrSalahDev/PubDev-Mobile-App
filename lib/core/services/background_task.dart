import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_client.dart';
import 'notification_service.dart';

const fetchBackgroundTask = "fetch_new_packages";

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case fetchBackgroundTask:
        try {
          final prefs = await SharedPreferences.getInstance();
          final apiClient = PubDevApiClient();
          final notificationService = NotificationService();
          await notificationService.init();

          final recentPackages = await apiClient.getTrendingPackages();

          if (recentPackages.isNotEmpty) {
            final firstPackage = recentPackages.first;
            final lastSeenPackage = prefs.getString('last_seen_package');

            if (firstPackage != lastSeenPackage) {
              final packageDetails = await apiClient.getPackageDetails(
                firstPackage,
              );

              await notificationService.showNotification(
                id: 0,
                title: 'New Package Published!',
                body:
                    '${packageDetails.name} version ${packageDetails.latestVersion} has been published.',
              );

              await prefs.setString('last_seen_package', firstPackage);
            }
          }
        } catch (err) {
          // ignore: avoid_print
          print(err.toString());
          throw Exception(err);
        }
        break;
    }
    return Future.value(true);
  });
}

class BackgroundTaskManager {
  static Future<void> init() async {
    await Workmanager().initialize(callbackDispatcher);

    await Workmanager().registerPeriodicTask(
      "1",
      fetchBackgroundTask,
      frequency: const Duration(minutes: 5),
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }
}

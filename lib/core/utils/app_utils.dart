import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:flutter/material.dart';
import 'package:pub_dev_packages_app/core/di/di.dart';
import 'package:pub_dev_packages_app/core/l10n/generated/l10n.dart';
import 'package:pub_dev_packages_app/core/services/toast_service.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchUrlInBrowser({
  required String url,
  required BuildContext context,
}) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    if (context.mounted) {
      getIt<ToastService>().showErrorToast(
        context: context,
        message: AppLocalizations.of(context).couldNotLaunchVideo,
      );
    }
  }
}

Future<void> requestBatteryExemptions() async {
  final bool? isAllOptimizationDisabled =
      await DisableBatteryOptimization.isAllBatteryOptimizationDisabled;

  if (isAllOptimizationDisabled != true) {
    await DisableBatteryOptimization.showDisableAllOptimizationsSettings(
      AppLocalizations.current.autoStartTitle,
      AppLocalizations.current.autoStartBody,
      AppLocalizations.current.manBatteryTitle,
      AppLocalizations.current.manBatteryBody,
    );
  }
}

String formatVideoDuration(Duration? duration) {
  if (duration == null) return "00:00";

  final int hours = duration.inHours;
  final int minutes = duration.inMinutes.remainder(60);
  final int seconds = duration.inSeconds.remainder(60);

  final String minutesStr = hours > 0
      ? minutes.toString().padLeft(2, '0')
      : minutes.toString();
  final String secondsStr = seconds.toString().padLeft(2, '0');

  if (hours > 0) {
    return '$hours:$minutesStr:$secondsStr';
  } else {
    return '$minutesStr:$secondsStr';
  }
}

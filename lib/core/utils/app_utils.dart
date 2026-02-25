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

import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pub_dev_packages_app/core/di/di.dart';
import 'package:pub_dev_packages_app/core/l10n/generated/l10n.dart';
import 'package:pub_dev_packages_app/core/routes/app_router.dart';
import 'package:pub_dev_packages_app/core/theme/app_colors.dart';
import 'package:pub_dev_packages_app/core/theme/dark_app_theme.dart';
import 'package:pub_dev_packages_app/core/theme/light_app_theme.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pub_dev_packages_app/core/services/notification_service.dart';
import 'package:pub_dev_packages_app/core/services/fcm_service.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  initDependencies();

  await getIt<NotificationService>().init();
  await getIt<FCMService>().init();

  Bloc.observer = TalkerBlocObserver();

  runApp(
    DevicePreview(
      //enabled: !kReleaseMode,
      enabled: false,
      builder: (context) => const PubDevApp(),
    ),
  );

  FlutterNativeSplash.remove();
}

class PubDevApp extends StatelessWidget {
  const PubDevApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      splitScreenMode: true,
      builder: (context, child) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
        title: 'Pub.dev',
        locale: DevicePreview.locale(context),

        builder: (context, child) {
          final mediaQuery = MediaQuery.of(context);

          return MediaQuery(
            data: mediaQuery.copyWith(
              textScaler: TextScaler.linear(
                mediaQuery.textScaler.scale(1).clamp(1.0, 1.3),
              ),
            ),
            child: DevicePreview.appBuilder(
              context,
              AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle(
                  statusBarColor: Theme.of(context).colorScheme.surface,
                  statusBarIconBrightness: context.isDark
                      ? Brightness.light
                      : Brightness.dark,
                  systemNavigationBarColor: Theme.of(
                    context,
                  ).colorScheme.surface,
                  systemNavigationBarIconBrightness: context.isDark
                      ? Brightness.light
                      : Brightness.dark,
                ),
                child: child!,
              ),
            ),
          );
        },
        theme: lightTheme(context),
        darkTheme: darkTheme(context),
        themeMode: ThemeMode.system,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.delegate.supportedLocales,
      ),
    );
  }
}

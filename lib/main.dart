import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pub_dev_packages_app/core/l10n/generated/l10n.dart';
import 'package:pub_dev_packages_app/core/routes/app_router.dart';
import 'package:pub_dev_packages_app/core/theme/app_colors.dart';
import 'package:pub_dev_packages_app/core/theme/dark_app_theme.dart';
import 'package:pub_dev_packages_app/core/theme/light_app_theme.dart';
import 'bloc/packages_bloc.dart';
import 'core/api_client.dart';
import 'core/background_task.dart';
import 'bloc/search_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await BackgroundTaskManager.init();

  runApp(
    DevicePreview(
      //enabled: !kReleaseMode,
      enabled: false,
      builder: (context) => const PubDevApp(),
    ),
  );
}

class PubDevApp extends StatelessWidget {
  const PubDevApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PackagesBloc(apiClient: PubDevApiClient()),
        ),
        BlocProvider(create: (context) => SearchBloc(PubDevApiClient())),
      ],
      child: ScreenUtilInit(
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
      ),
    );
  }
}

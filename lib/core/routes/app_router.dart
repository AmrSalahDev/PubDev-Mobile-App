import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pub_dev_packages_app/core/di/di.dart';
import 'package:pub_dev_packages_app/features/home/domain/entities/package_entity.dart';
import 'package:pub_dev_packages_app/features/home/presentation/bloc/packages_bloc.dart';
import 'package:pub_dev_packages_app/features/home/presentation/page/home_page.dart';
import 'package:pub_dev_packages_app/features/search/presentation/bloc/search_bloc.dart';
import 'package:pub_dev_packages_app/features/search/presentation/page/search_page.dart';
import 'package:pub_dev_packages_app/features/package_detail/presentation/page/package_detail_page.dart';
import 'app_paths.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppPaths.home,
    routes: [
      GoRoute(
        path: AppPaths.home,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<PackagesBloc>(),
          child: const HomePage(),
        ),
      ),
      GoRoute(
        path: AppPaths.search,
        builder: (context, state) {
          final query = state.extra as String?;
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => getIt<SearchBloc>()),
              BlocProvider(create: (context) => getIt<PackagesBloc>()),
            ],
            child: SearchPage(initialQuery: query ?? ''),
          );
        },
      ),
      GoRoute(
        path: AppPaths.packageDetail,
        builder: (context, state) {
          final extra = state.extra;
      
          if (extra is PackageEntity) {
            return BlocProvider(
              create: (context) => getIt<PackagesBloc>(),
              child: PackageDetailPage(packageInfo: extra),
            );
          } else if (extra is String) {
            return BlocProvider(
              create: (context) => getIt<PackagesBloc>(),
              child: PackageDetailPage(packageName: extra),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    ],
  );
}

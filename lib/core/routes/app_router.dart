import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pub_dev_packages_app/core/di/di.dart';
import 'package:pub_dev_packages_app/features/home/domain/entities/package_entity.dart';
import 'package:pub_dev_packages_app/features/home/presentation/bloc/packages_bloc.dart';
import 'package:pub_dev_packages_app/features/home/presentation/page/home_page.dart';
import 'package:pub_dev_packages_app/features/search_result/presentation/page/search_page.dart';
import 'package:pub_dev_packages_app/features/package_detail/presentation/page/package_detail_page.dart';
import 'app_paths.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
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
          return SearchPage(initialQuery: query ?? '');
        },
      ),
      GoRoute(
        path: AppPaths.packageDetail,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<PackagesBloc>(),
          child: PackageDetailPage(packageInfo: state.extra as PackageEntity),
        ),
      ),
    ],
  );
}

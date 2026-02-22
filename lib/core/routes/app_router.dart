import 'package:go_router/go_router.dart';
import 'package:pub_dev_packages_app/features/home/presentation/page/home_page.dart';
import 'package:pub_dev_packages_app/ui/search_page.dart';
import 'package:pub_dev_packages_app/ui/package_detail_page.dart';
import 'package:pub_dev_packages_app/core/api_client.dart';
import 'app_paths.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppPaths.home,
    routes: [
      GoRoute(
        path: AppPaths.home,
        builder: (context, state) => const HomePage(),
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
        builder: (context, state) => PackageDetailPage(
          package: state.extra as PubDevPackage,
        ),
      ),
    ],
  );
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pub_dev_packages_app/core/l10n/generated/l10n.dart';
import 'package:pub_dev_packages_app/features/home/domain/entities/package_entity.dart';
import 'package:pub_dev_packages_app/features/home/presentation/bloc/packages_bloc.dart';
import 'package:pub_dev_packages_app/features/home/presentation/bloc/packages_event.dart';
import 'package:pub_dev_packages_app/features/home/presentation/bloc/packages_state.dart';
import 'package:pub_dev_packages_app/features/package_detail/presentation/tabs/example_tab.dart';
import 'package:pub_dev_packages_app/features/package_detail/presentation/tabs/installing_tab.dart';
import 'package:pub_dev_packages_app/features/package_detail/presentation/tabs/readme_tab.dart';
import 'package:pub_dev_packages_app/features/package_detail/presentation/tabs/scores_tab.dart';
import 'package:pub_dev_packages_app/features/package_detail/presentation/tabs/versions_tab.dart';
import 'package:pub_dev_packages_app/features/package_detail/presentation/tabs/videos_tab.dart';
import 'package:pub_dev_packages_app/features/package_detail/presentation/tabs/github_health_tab.dart';
import 'package:pub_dev_packages_app/features/package_detail/presentation/widgets/package_details_header.dart';

class PackageDetailPage extends StatefulWidget {
  final PackageEntity packageInfo;

  const PackageDetailPage({super.key, required this.packageInfo});

  @override
  State<PackageDetailPage> createState() => _PackageDetailPageState();
}

class _PackageDetailPageState extends State<PackageDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);

    context.read<PackagesBloc>().add(
      LoadPackageInfoEvent(widget.packageInfo.name),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<PackagesBloc, PackagesState>(
      builder: (context, state) {
        if (state.isPackageInfoLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!state.isPackageInfoLoading && state.packageInfo != null) {
          final pkg = state.packageInfo!;
          return Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  PackageDetailsHeader(packageInfo: pkg),
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelColor: colorScheme.primary,
                    unselectedLabelColor: colorScheme.onSurfaceVariant,
                    dividerColor: Colors.transparent,
                    indicatorColor: colorScheme.primary,
                    tabs: [
                      Tab(text: AppLocalizations.of(context).readme),
                      Tab(text: AppLocalizations.of(context).changelog),
                      Tab(text: AppLocalizations.of(context).example),
                      Tab(text: AppLocalizations.of(context).videos),
                      Tab(text: AppLocalizations.of(context).installing),
                      Tab(text: AppLocalizations.of(context).versions),
                      Tab(text: AppLocalizations.of(context).scores),
                      Tab(text: AppLocalizations.of(context).githubHealth),
                    ],
                  ),
                  _buildTabContent(pkg),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildTabContent(PackageEntity packageInfo) {
    return Expanded(
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          ReadmeTab(packageInfo: packageInfo),
          // Changelog is missing data in entity, using placeholder
          Center(
            child: Text(
              AppLocalizations.of(context).changelogDataComingSoon,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ExampleTab(packageInfo: packageInfo),
          VideosTab(packageInfo: packageInfo),
          InstallingTab(packageInfo: packageInfo),
          VersionsTab(packageInfo: packageInfo),
          ScoresTab(packageInfo: packageInfo),
          GithubHealthTab(packageInfo: packageInfo),
        ],
      ),
    );
  }

  // Widget _buildVersionsTab(PackageEntity packageInfo) => ListView.builder(
  //   padding: const EdgeInsets.all(16),
  //   itemCount: packageInfo.versions.length,
  //   itemBuilder: (_, i) => ListTile(
  //     title: Text(
  //       packageInfo.versions[i].version,
  //       style: const TextStyle(color: Colors.white),
  //     ),
  //     trailing: packageInfo.versions[i].version == packageInfo.latest.version
  //         ? _tag('LATEST', Colors.green)
  //         : null,
  //   ),
  // );
}

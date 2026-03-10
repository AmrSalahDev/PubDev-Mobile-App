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
  final PackageEntity? packageInfo;
  final String? packageName;

  const PackageDetailPage({super.key, this.packageInfo, this.packageName});

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

    final name = widget.packageName ?? widget.packageInfo?.name;
    if (name != null) {
      context.read<PackagesBloc>().add(LoadPackageInfoEvent(name));
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final strings = AppLocalizations.of(context);

    return BlocBuilder<PackagesBloc, PackagesState>(
      builder: (context, state) {
        if (state.isPackageInfoLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!state.isPackageInfoLoading && state.packageInfo != null) {
          final packageInfo = state.packageInfo!;
          return Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  PackageDetailsHeader(packageInfo: packageInfo),
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelColor: colorScheme.primary,
                    unselectedLabelColor: colorScheme.onSurfaceVariant,
                    dividerColor: Colors.transparent,
                    indicatorColor: colorScheme.primary,
                    tabs: [
                      Tab(text: strings.readme),
                      Tab(text: strings.changelog),
                      Tab(text: strings.example),
                      Tab(text: strings.videos),
                      Tab(text: strings.installing),
                      Tab(text: strings.versions),
                      Tab(text: strings.scores),
                      Tab(text: strings.githubHealth),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: [
                        ReadmeTab(packageInfo: packageInfo),
                        // Changelog is missing data in entity, using placeholder
                        Center(
                          child: Text(
                            strings.changelogDataComingSoon,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
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
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
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

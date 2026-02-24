import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pub_dev_packages_app/features/home/presentation/bloc/packages_bloc.dart';
import 'package:pub_dev_packages_app/features/home/presentation/bloc/packages_event.dart';
import 'package:pub_dev_packages_app/features/home/presentation/bloc/packages_state.dart';
import 'package:pub_dev_packages_app/core/l10n/generated/l10n.dart';
import 'package:pub_dev_packages_app/features/home/presentation/widgets/favorites_section.dart';
import 'package:pub_dev_packages_app/features/home/presentation/widgets/grid_section.dart';
import 'package:pub_dev_packages_app/features/home/presentation/widgets/home_header.dart';
import 'package:pub_dev_packages_app/features/home/presentation/widgets/section_header.dart';
import 'package:pub_dev_packages_app/features/home/presentation/widgets/view_all_button.dart';
import 'package:pub_dev_packages_app/features/home/presentation/widgets/youtube_videos_section.dart';
import 'package:visibility_detector/visibility_detector.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<PackagesBloc>().add(LoadFavoritesEvent());
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);

    return Scaffold(
      body: BlocBuilder<PackagesBloc, PackagesState>(
        builder: (context, state) {
          return CustomScrollView(
            clipBehavior: Clip.none,
            slivers: [
              SliverToBoxAdapter(
                child: Column(children: [HomeHeader(), 30.verticalSpace]),
              ),

              SliverToBoxAdapter(
                child: SectionHeader(
                  title: strings.flutterFavorites,
                  subtitle: strings.flutterFavoritesSubtitle,
                ),
              ),
              SliverToBoxAdapter(
                child: FavoritesSection(packages: state.favorites),
              ),
              SliverToBoxAdapter(child: ViewAllButton(onTap: () {})),

              SliverToBoxAdapter(child: 24.verticalSpace),

              // trending packages section
              SliverToBoxAdapter(
                child: VisibilityDetector(
                  key: const Key('trending-section'),
                  onVisibilityChanged: (info) {
                    final visiblePercentage = info.visibleFraction * 100;

                    if (visiblePercentage > 70 && state.trending.isEmpty) {
                      context.read<PackagesBloc>().add(LoadTrendingEvent());
                    }
                  },
                  child: SectionHeader(
                    title: strings.trendingPackages,
                    subtitle: strings.trendingPackagesSubtitle,
                  ),
                ),
              ),
              SliverToBoxAdapter(child: GridSection(packages: state.trending)),
              SliverToBoxAdapter(child: ViewAllButton(onTap: () {})),

              SliverToBoxAdapter(child: 24.verticalSpace),

              // top flutter packages section
              SliverToBoxAdapter(
                child: VisibilityDetector(
                  key: const Key('top-flutter-section'),
                  onVisibilityChanged: (info) {
                    final visiblePercentage = info.visibleFraction * 100;

                    if (visiblePercentage > 70 && state.topFlutter.isEmpty) {
                      context.read<PackagesBloc>().add(LoadTopFlutterEvent());
                    }
                  },
                  child: SectionHeader(
                    title: strings.topFlutterPackages,
                    subtitle: strings.topFlutterPackagesSubtitle,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: GridSection(packages: state.topFlutter),
              ),
              SliverToBoxAdapter(child: ViewAllButton(onTap: () {})),

              SliverToBoxAdapter(child: 24.verticalSpace),

              // top dart packages section
              SliverToBoxAdapter(
                child: VisibilityDetector(
                  key: const Key('top-dart-section'),
                  onVisibilityChanged: (info) {
                    final visiblePercentage = info.visibleFraction * 100;

                    if (visiblePercentage > 70 && state.topDart.isEmpty) {
                      context.read<PackagesBloc>().add(LoadTopDartEvent());
                    }
                  },
                  child: SectionHeader(
                    title: strings.topDartPackages,
                    subtitle: strings.topDartPackagesSubtitle,
                  ),
                ),
              ),
              SliverToBoxAdapter(child: GridSection(packages: state.topDart)),
              SliverToBoxAdapter(child: ViewAllButton(onTap: () {})),

              SliverToBoxAdapter(child: 24.verticalSpace),

              // package of the week section
              SliverToBoxAdapter(
                child: VisibilityDetector(
                  key: const Key('package-of-the-week-section'),
                  onVisibilityChanged: (info) {
                    final visiblePercentage = info.visibleFraction * 100;

                    if (visiblePercentage > 50 && state.youtubeVideos.isEmpty) {
                      context.read<PackagesBloc>().add(
                        LoadYoutubeVideosEvent(),
                      );
                    }
                  },
                  child: SectionHeader(
                    title: strings.packageOfTheWeek,
                    subtitle: strings.packageOfTheWeekSubtitle,
                  ),
                ),
              ),
              SliverToBoxAdapter(child: YoutubeVideosSection()),
              SliverToBoxAdapter(
                child: ViewAllButton(title: strings.viewPlaylist, onTap: () {}),
              ),
              SliverToBoxAdapter(child: 50.verticalSpace),
            ],
          );
        },
      ),
    );
  }
}

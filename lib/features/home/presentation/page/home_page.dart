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

              // Flutter Favorites section
              _HomeSection(
                sectionKey: 'flutter-favorites-section',
                title: strings.flutterFavorites,
                subtitle: strings.flutterFavoritesSubtitle,
                onVisible: () {
                  context.read<PackagesBloc>().add(LoadFavoritesEvent());
                },
                isEmpty: state.favorites.isEmpty,
                content: FavoritesSection(packages: state.favorites),
                buttonTitle: strings.viewAll,
              ),

              // Trending packages section
              _HomeSection(
                sectionKey: 'trending-section',
                title: strings.trendingPackages,
                subtitle: strings.trendingPackagesSubtitle,
                onVisible: () {
                  context.read<PackagesBloc>().add(LoadTrendingEvent());
                },
                isEmpty: state.trending.isEmpty,
                content: GridSection(packages: state.trending),
                buttonTitle: strings.viewAll,
              ),

              // Top Flutter packages section
              _HomeSection(
                sectionKey: 'top-flutter-section',
                title: strings.topFlutterPackages,
                subtitle: strings.topFlutterPackagesSubtitle,
                onVisible: () {
                  context.read<PackagesBloc>().add(LoadTopFlutterEvent());
                },
                isEmpty: state.topFlutter.isEmpty,
                content: GridSection(packages: state.topFlutter),
                buttonTitle: strings.viewAll,
              ),

              // Top Dart packages section
              _HomeSection(
                sectionKey: 'top-dart-section',
                title: strings.topDartPackages,
                subtitle: strings.topDartPackagesSubtitle,
                onVisible: () {
                  context.read<PackagesBloc>().add(LoadTopDartEvent());
                },
                isEmpty: state.topDart.isEmpty,
                content: GridSection(packages: state.topDart),
                buttonTitle: strings.viewAll,
              ),

              // Package of the week section
              _HomeSection(
                sectionKey: 'package-of-the-week-section',
                title: strings.packageOfTheWeek,
                subtitle: strings.packageOfTheWeekSubtitle,
                onVisible: () {
                  context.read<PackagesBloc>().add(
                    LoadPackageOfTheWeekVideosEvent(),
                  );
                },
                isEmpty: state.packageOfTheWeekVideos.isEmpty,
                content: YoutubeVideosSection(
                  playlist: state.packageOfTheWeekVideos,
                  isLoading: state.isPackageOfTheWeekVideosLoading,
                ),
                buttonTitle: strings.viewPlaylist,
              ),

              // widget of the week section
              _HomeSection(
                sectionKey: 'widget-of-the-week-section',
                title: strings.widgetOfTheWeek,
                subtitle: strings.widgetOfTheWeekSubtitle,
                onVisible: () {
                  context.read<PackagesBloc>().add(
                    LoadWidgetOfTheWeekVideosEvent(),
                  );
                },
                isEmpty: state.widgetOfTheWeekVideos.isEmpty,

                content: YoutubeVideosSection(
                  playlist: state.widgetOfTheWeekVideos,
                  isLoading: state.isWidgetOfTheWeekVideosLoading,
                ),
                buttonTitle: strings.viewPlaylist,
              ),

              // observable flutter section
              _HomeSection(
                sectionKey: 'observable-flutter-section',
                title: strings.observableFlutter,
                subtitle: strings.observableFlutterSubtitle,
                onVisible: () {
                  context.read<PackagesBloc>().add(LoadObservableVideosEvent());
                },
                isEmpty: state.observableVideos.isEmpty,
                content: YoutubeVideosSection(
                  playlist: state.observableVideos,
                  isLoading: state.isObservableVideosLoading,
                ),
                buttonTitle: strings.viewPlaylist,
              ),

              SliverToBoxAdapter(child: 30.verticalSpace),
            ],
          );
        },
      ),
    );
  }
}

class _HomeSection extends StatelessWidget {
  final String sectionKey;
  final String title;
  final String subtitle;
  final VoidCallback onVisible;
  final bool isEmpty;
  final Widget content;
  final String buttonTitle;

  const _HomeSection({
    required this.sectionKey,
    required this.title,
    required this.subtitle,
    required this.onVisible,
    required this.isEmpty,
    required this.content,
    required this.buttonTitle,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(bottom: 16.h),
      sliver: SliverMainAxisGroup(
        slivers: [
          SliverToBoxAdapter(
            child: VisibilityDetector(
              key: Key(sectionKey),
              onVisibilityChanged: (info) {
                if (info.visibleFraction > 0.1 && isEmpty) {
                  onVisible();
                }
              },
              child: SectionHeader(title: title, subtitle: subtitle),
            ),
          ),
          SliverToBoxAdapter(child: content),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: ViewAllButton(title: buttonTitle, onTap: () {}),
            ),
          ),
        ],
      ),
    );
  }
}

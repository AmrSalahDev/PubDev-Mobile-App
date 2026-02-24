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
import 'package:pub_dev_packages_app/features/home/presentation/widgets/youtube_video_card.dart';
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
              if (state.isFavoritesLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else ...[
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
                SliverToBoxAdapter(
                  child: GridSection(packages: state.trending),
                ),
                SliverToBoxAdapter(child: ViewAllButton(onTap: () {})),

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
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: "Package of the week",
                    subtitle:
                        "Package of the Week is a series of quick, animated videos, each of which covers a particular package",
                  ),
                ),
                SliverToBoxAdapter(
                  child: BlocBuilder<PackagesBloc, PackagesState>(
                    builder: (context, state) {
                      if (state.isYoutubeVideosLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state.youtubeVideos.isNotEmpty) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: SizedBox(
                            height: 250,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.youtubeVideos.length,
                              itemBuilder: (context, index) {
                                final video = state.youtubeVideos[index];
                                return YoutubeVideoCard(
                                  title: video.title,
                                  // Use the high-res thumbnail from the video object
                                  thumbnail: video.thumbnails.highResUrl,
                                );
                              },
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
                SliverToBoxAdapter(child: 50.verticalSpace),
              ],
            ],
          );
        },
      ),
    );
  }
}

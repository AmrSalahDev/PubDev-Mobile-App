import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pub_dev_packages_app/features/home/presentation/widgets/favorites_section.dart';
import 'package:pub_dev_packages_app/features/home/presentation/widgets/grid_section.dart';
import 'package:pub_dev_packages_app/features/home/presentation/widgets/home_app_bar.dart';
import 'package:pub_dev_packages_app/features/home/presentation/widgets/home_header.dart';
import 'package:pub_dev_packages_app/features/home/presentation/widgets/section_header.dart';
import 'package:pub_dev_packages_app/features/home/presentation/widgets/view_all_button.dart';
import '../../../../bloc/packages_bloc.dart';
import '../../../../bloc/packages_event.dart';
import '../../../../bloc/packages_state.dart';
import '../../../../core/api_client.dart';
import '../../../../ui/package_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<PackagesBloc>().add(LoadPackages());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      body: BlocBuilder<PackagesBloc, PackagesState>(
        builder: (context, state) {
          return CustomScrollView(
            clipBehavior: Clip.none,
            slivers: [
              SliverToBoxAdapter(child: HomeHeader()),
              if (state is PackagesLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state is PackagesError)
                SliverFillRemaining(child: _buildError(context, state.message))
              else if (state is PackagesLoaded) ...[
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'Flutter Favorites',
                    subtitle:
                        'Some of the packages that demonstrate the highest levels of quality, selected by the Flutter Ecosystem Committee',
                  ),
                ),
                SliverToBoxAdapter(
                  child: FavoritesSection(packages: state.favorites),
                ),
                SliverToBoxAdapter(child: ViewAllButton(onTap: () {})),

               
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'Trending packages',
                    subtitle: 'Top trending packages in the last 30 days',
                  ),
                ),
                SliverToBoxAdapter(
                  child: GridSection(packages: state.trending),
                ),
                SliverToBoxAdapter(child: ViewAllButton(onTap: () {})),

                
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'Top Flutter packages',
                    subtitle:
                        'Some of the top packages that extend Flutter with new features',
                  ),
                ),
                SliverToBoxAdapter(
                  child: GridSection(packages: state.topFlutter),
                ),
                SliverToBoxAdapter(child: ViewAllButton(onTap: () {})),

               
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'Top Dart packages',
                    subtitle:
                        'Some of the top packages for any Dart-based app or program',
                  ),
                ),
                SliverToBoxAdapter(child: GridSection(packages: state.topDart)),
                SliverToBoxAdapter(child: ViewAllButton(onTap: () {})),

               
                SliverToBoxAdapter(child: SizedBox(height: 50.h)),
              ],
            ],
          );
        },
      ),
    );
  }

  // ── Error widget ─────────────────────────────────────────────────────────────
  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
          const SizedBox(height: 16),
          Text(
            'Error: $message',
            textAlign: TextAlign.center,
            style: const TextStyle(),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(foregroundColor: Colors.black),
            onPressed: () =>
                context.read<PackagesBloc>().add(RefreshPackages()),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

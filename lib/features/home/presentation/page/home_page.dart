import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pub_dev_packages_app/features/home/presentation/widgets/home_header.dart';
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
      appBar: AppBar(
        title: const Text('Pub.dev'),
      
        actions: [
          IconButton(icon: const Icon(Icons.light_mode), onPressed: () {}),
        ],
      ),

      body: BlocBuilder<PackagesBloc, PackagesState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              // ── Search Header ────────────────────────────────────────────
              SliverToBoxAdapter(child: HomeHeader()),

              if (state is PackagesLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state is PackagesError)
                SliverFillRemaining(child: _buildError(context, state.message))
              else if (state is PackagesLoaded) ...[
                // Search results overlay
                // Search results overlay removed - favoring dedicated SearchPage
                if (state.isSearching || state.searchQuery.isNotEmpty)
                  const SliverToBoxAdapter(child: SizedBox.shrink())
                else ...[
                  // ── Flutter Favorites ─────────────────────────────────────
                  SliverToBoxAdapter(
                    child: _buildSectionHeader(
                      'Flutter Favorites',
                      'Some of the packages that demonstrate the highest levels of quality,\nselected by the Flutter Ecosystem Committee',
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _buildFavoritesRow(state.favorites),
                  ),
                  SliverToBoxAdapter(child: _buildViewAll()),

                  // ── Trending packages ─────────────────────────────────────
                  SliverToBoxAdapter(
                    child: _buildSectionHeader(
                      'Trending packages',
                      'Top trending packages in the last 30 days',
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _buildTwoColumnGrid(state.trending),
                  ),
                  SliverToBoxAdapter(child: _buildViewAll()),

                  // ── Top Flutter packages ──────────────────────────────────
                  SliverToBoxAdapter(
                    child: _buildSectionHeader(
                      'Top Flutter packages',
                      'Some of the top packages that extend Flutter with new features',
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _buildTwoColumnGrid(state.topFlutter),
                  ),
                  SliverToBoxAdapter(child: _buildViewAll()),

                  // ── Top Dart packages ─────────────────────────────────────
                  SliverToBoxAdapter(
                    child: _buildSectionHeader(
                      'Top Dart packages',
                      'Some of the top packages for any Dart-based app or program',
                    ),
                  ),
                  SliverToBoxAdapter(child: _buildTwoColumnGrid(state.topDart)),
                  SliverToBoxAdapter(child: _buildViewAll()),

                  // ── Bottom padding ────────────────────────────────────────
                  const SliverToBoxAdapter(child: SizedBox(height: 40)),
                ],
              ],
            ],
          );
        },
      ),
    );
  }

  // ── Section Header ────────────────────────────────────────────────────────────
  Widget _buildSectionHeader(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle( fontSize: 13),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // ── Flutter Favorites: horizontal scrolling row ───────────────────────────────
  Widget _buildFavoritesRow(List<PubDevPackage> packages) {
    if (packages.isEmpty) {
      return const SizedBox(
        height: 130,
        child: Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }
    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: packages.length,
        itemBuilder: (context, index) {
          return Container(
            width: 185,
            margin: const EdgeInsets.only(right: 12),
            child: PackageTile(package: packages[index]),
          );
        },
      ),
    );
  }

  // ── 2-column grid ─────────────────────────────────────────────────────────────
  Widget _buildTwoColumnGrid(List<PubDevPackage> packages) {
    if (packages.isEmpty) {
      return const SizedBox(
        height: 100,
        child: Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    // Limit to 6 items (3 rows × 2 cols)
    final items = packages.take(6).toList();
    final rowCount = (items.length / 2).ceil();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate(rowCount, (rowIndex) {
          final left = rowIndex * 2;
          final right = left + 1;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 120,
                    child: PackageTile(package: items[left]),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: right < items.length
                      ? SizedBox(
                          height: 120,
                          child: PackageTile(package: items[right]),
                        )
                      : const SizedBox(),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ── Search Results ────────────────────────────────────────────────────────────
  Widget _buildSearchResults(PackagesLoaded state) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            state.searchQuery.isNotEmpty
                ? 'Results for "${state.searchQuery}"'
                : 'Search results',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          if (state.searchResults.isEmpty && state.isSearching)
            const Center(child: CircularProgressIndicator()),
          if (state.searchResults.isEmpty && !state.isSearching)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text(
                  'No packages found.',
                  style: TextStyle(),
                ),
              ),
            ),
          ...state.searchResults.map(
            (pkg) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildListTile(pkg),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(PubDevPackage pkg) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pkg.name,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            pkg.description,
            style: const TextStyle( fontSize: 13),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (pkg.publisher.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.verified, size: 12),
                const SizedBox(width: 4),
                Text(
                  pkg.publisher,
                  style: const TextStyle( fontSize: 11),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ── "VIEW ALL" link ───────────────────────────────────────────────────────────
  Widget _buildViewAll() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {},
          child: const Text(
            'VIEW ALL',
            style: TextStyle(
              
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
        ),
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
            style: ElevatedButton.styleFrom(
             
              foregroundColor: Colors.black,
            ),
            onPressed: () =>
                context.read<PackagesBloc>().add(RefreshPackages()),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

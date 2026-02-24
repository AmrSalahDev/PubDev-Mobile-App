import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pub_api_client/pub_api_client.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import 'widgets/search_package_tile.dart';

class SearchPage extends StatefulWidget {
  final String initialQuery;
  final SearchOrder initialSort;

  const SearchPage({
    super.key,
    this.initialQuery = '',
    this.initialSort = SearchOrder.top,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  SearchOrder _currentSort = SearchOrder.top;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initialQuery;
    _currentSort = widget.initialSort;

    _scrollController.addListener(_onScroll);

    // Initial search
    context.read<SearchBloc>().add(
      PerformSearch(query: widget.initialQuery, sort: widget.initialSort),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<SearchBloc>().add(LoadMoreResults());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onSearch(String query) {
    context.read<SearchBloc>().add(
      PerformSearch(query: query, sort: _currentSort),
    );
  }

  void _onSortChanged(SearchOrder? sort) {
    if (sort != null) {
      setState(() => _currentSort = sort);
      context.read<SearchBloc>().add(
        PerformSearch(query: _searchController.text, sort: sort),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12202C),
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onSubmitted: _onSearch,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search packages',
            hintStyle: TextStyle(color: Color(0xFFB0BEC5)),
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _onSearch(_searchController.text),
          ),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar - Hide on small screens for simplicity or use Drawer
          if (MediaQuery.of(context).size.width > 800)
            Container(
              width: 250,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                border: Border(right: BorderSide(color: Color(0xFF263545))),
              ),
              child: _buildSidebar(),
            ),

          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF4EAFF7)),
                  );
                }

                if (state is SearchError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  );
                }

                if (state is SearchLoaded) {
                  return Column(
                    children: [
                      _buildHeader(state.packages.length),
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: state.hasReachedMax
                              ? state.packages.length
                              : state.packages.length + 1, 
                          itemBuilder: (context, index) {
                            if (index >= state.packages.length) {
                              return const Padding(
                                padding: EdgeInsets.all(32.0),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF4EAFF7),
                                  ),
                                ),
                              );
                            }
                            // return SearchPackageTile(
                            //   package: state.packages[index],
                            // );
                            return SizedBox.shrink();
                          },
                        ),
                      ),
                    ],
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(int count) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF263545))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'RESULTS $count packages',
            style: const TextStyle(
              color: Color(0xFFB0BEC5),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          _buildSortDropdown(),
        ],
      ),
    );
  }

  Widget _buildSortDropdown() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'SORT BY ',
          style: TextStyle(
            color: Color(0xFFB0BEC5),
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        Theme(
          data: ThemeData.dark().copyWith(canvasColor: const Color(0xFF1C2834)),
          child: DropdownButton<SearchOrder>(
            value: _currentSort,
            underline: const SizedBox(),
            icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF4EAFF7)),
            style: const TextStyle(
              color: Color(0xFF4EAFF7),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            onChanged: _onSortChanged,
            items: const [
              DropdownMenuItem(value: SearchOrder.top, child: Text('DEFAULT')),
              DropdownMenuItem(
                value: SearchOrder.popularity,
                child: Text('POPULARITY'),
              ),
              DropdownMenuItem(
                value: SearchOrder.points,
                child: Text('POINTS'),
              ),
              DropdownMenuItem(
                value: SearchOrder.updated,
                child: Text('RECENTLY UPDATED'),
              ),
              DropdownMenuItem(
                value: SearchOrder.created,
                child: Text('NEWEST PACKAGE'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSidebar() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sidebarSection('Platforms', [
            'Android',
            'iOS',
            'Linux',
            'macOS',
            'Web',
            'Windows',
          ]),
          _sidebarSection('SDKs', ['Dart', 'Flutter']),
          _sidebarSection('License', ['OSI-approved']),
        ],
      ),
    );
  }

  Widget _sidebarSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_up,
              color: Color(0xFFB0BEC5),
              size: 16,
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF4EAFF7)),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  item,
                  style: const TextStyle(
                    color: Color(0xFFB0BEC5),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 24),
      ],
    );
  }
}

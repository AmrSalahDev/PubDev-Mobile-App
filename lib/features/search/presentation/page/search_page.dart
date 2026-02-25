import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pub_api_client/pub_api_client.dart';
import 'package:pub_dev_packages_app/core/l10n/generated/l10n.dart';
import 'package:pub_dev_packages_app/features/search/widgets/search_header.dart';
import 'package:pub_dev_packages_app/features/widgets/custom_search_bar.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../../widgets/search_package_tile.dart';

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
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final strings = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: CustomSearchBar(
          searchController: _searchController,
          textTheme: textTheme,
          colorScheme: colorScheme,
          strings: strings,
          onSubmitted: _onSearch,
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                      SearchHeader(
                        count: state.packages.length,
                        currentSort: _currentSort,
                        onSortChanged: _onSortChanged,
                      ),
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
                            return SearchPackageTile(
                              packageInfo: state.packages[index],
                            );
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
}

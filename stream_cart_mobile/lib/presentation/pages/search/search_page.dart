import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/dependency_injection.dart';
import '../../../core/routing/app_router.dart';
import '../../blocs/search/search_bloc.dart';
import '../../blocs/search/search_event.dart';
import '../../blocs/search/search_state.dart';
import '../../widgets/common/custom_search_bar.dart';
import '../../widgets/search/search_results.dart';
import '../../widgets/search/search_history.dart';

class SearchPage extends StatefulWidget {
  final String? initialQuery;

  const SearchPage({
    super.key,
    this.initialQuery,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController;
  late SearchBloc _searchBloc;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchBloc = getIt<SearchBloc>();
    
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      _searchController.text = widget.initialQuery!;
      _searchBloc.add(SearchSubmittedEvent(widget.initialQuery!));
    } else {
      _searchBloc.add(const SearchHistoryLoadedEvent());
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(
      create: (context) => _searchBloc,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: const Color(0xFF202328),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFFB0F847)),
            onPressed: () => Navigator.pop(context),
          ),
          title: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              return CustomSearchBar(
                controller: _searchController,
                hintText: 'Tìm kiếm sản phẩm, danh mục...',
                onChanged: (query) {
                  context.read<SearchBloc>().add(SearchQueryChangedEvent(query));
                },
                onSubmitted: () {
                  final query = _searchController.text.trim();
                  if (query.isNotEmpty) {
                    context.read<SearchBloc>().add(SearchSubmittedEvent(query));
                  }
                },
              );
            },
          ),
          actions: [
            // Advanced Search Button
            IconButton(
              icon: const Icon(Icons.tune, color: Color(0xFFB0F847)),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRouter.advancedSearch,
                  arguments: _searchController.text,
                );
              },
              tooltip: 'Tìm kiếm nâng cao',
            ),
            BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (_searchController.text.isNotEmpty) {
                  return IconButton(
                    icon: const Icon(Icons.clear, color: Color(0xFFB0F847)),
                    onPressed: () {
                      _searchController.clear();
                      context.read<SearchBloc>().add(const ClearSearchEvent());
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocConsumer<SearchBloc, SearchState>(
          listener: (context, state) {
            // Handle any side effects if needed
          },
          builder: (context, state) {
            return _buildBody(context, state);
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, SearchState state) {
    if (state is SearchLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is SearchError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Có lỗi xảy ra',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final query = _searchController.text.trim();
                if (query.isNotEmpty) {
                  context.read<SearchBloc>().add(SearchSubmittedEvent(query));
                }
              },
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (state is SearchEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Không tìm thấy kết quả',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Không có sản phẩm nào cho "${state.query}"',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Hãy thử tìm kiếm với từ khóa khác',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    if (state is SearchLoaded) {
      return SearchResults(
        query: state.query,
        products: state.products,
        categories: state.categories,
        shops: state.shops,
        productImages: state.productImages,
        hasMoreProducts: state.hasMoreProducts,
      );
    }

    if (state is SearchInitial) {
      return SearchHistory(
        historyItems: state.searchHistory,
        onHistoryItemTap: (query) {
          _searchController.text = query;
          context.read<SearchBloc>().add(SearchHistoryItemSelectedEvent(query));
        },
        onClearHistory: () {
          context.read<SearchBloc>().add(const SearchHistoryLoadedEvent());
        },
      );
    }

    return const SizedBox.shrink();
  }
}

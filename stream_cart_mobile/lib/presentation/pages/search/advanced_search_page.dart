import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/search_filters.dart';
import '../../../domain/entities/category_entity.dart';
import '../../blocs/search/advanced_search_bloc.dart';
import '../../blocs/search/advanced_search_event.dart' as search_events;
import '../../blocs/search/advanced_search_state.dart';
import '../../blocs/home/home_bloc.dart';
import '../../blocs/home/home_event.dart' as home_events;
import '../../blocs/home/home_state.dart';
import '../../widgets/search/search_filters_widget.dart';
import '../../widgets/search/advanced_search_results.dart';

class AdvancedSearchPage extends StatefulWidget {
  final String? initialQuery;

  const AdvancedSearchPage({
    super.key,
    this.initialQuery,
  });

  @override
  State<AdvancedSearchPage> createState() => _AdvancedSearchPageState();
}

class _AdvancedSearchPageState extends State<AdvancedSearchPage> {
  late TextEditingController _searchController;
  SearchFilters _currentFilters = const SearchFilters();
  List<CategoryEntity> _categories = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery ?? '');
    
    // Load search history
    context.read<AdvancedSearchBloc>().add(search_events.LoadSearchHistoryEvent());
    
    // Search immediately if initial query is provided
    if (widget.initialQuery?.isNotEmpty == true) {
      Future.microtask(() {
        context.read<AdvancedSearchBloc>().add(
          search_events.SearchProductsEvent(searchTerm: widget.initialQuery!),
        );
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      context.read<AdvancedSearchBloc>().add(
        search_events.SearchProductsEvent(
          searchTerm: query,
          filters: _currentFilters,
        ),
      );
    }
  }

  void _onFiltersChanged(SearchFilters filters) {
    setState(() {
      _currentFilters = filters;
    });
    
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      context.read<AdvancedSearchBloc>().add(
        search_events.ApplyFiltersEvent(
          searchTerm: query,
          filters: filters,
        ),
      );
    }
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SearchFiltersWidget(
          initialFilters: _currentFilters,
          categories: _categories,
          onFiltersChanged: _onFiltersChanged,
          onClose: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _currentFilters = const SearchFilters();
    });
    
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      context.read<AdvancedSearchBloc>().add(
        search_events.ClearFiltersEvent(query),
      );
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _currentFilters = const SearchFilters();
    });
    context.read<AdvancedSearchBloc>().add(search_events.ClearSearchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Tìm kiếm nâng cao', style: TextStyle(color: Colors.white)),
        elevation: 0,
        backgroundColor: Color(0xFF4CAF50),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search Bar and Filters
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              children: [
                // Search Input
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Tìm kiếm sản phẩm...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  onPressed: _clearSearch,
                                  icon: const Icon(Icons.clear),
                                )
                              : null,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        onSubmitted: (_) => _performSearch(),
                        onChanged: (value) => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Search Button
                    IconButton(
                      onPressed: _performSearch,
                      icon: const Icon(Icons.search),
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Filters Row
                Row(
                  children: [
                    // Filter Button
                    OutlinedButton.icon(
                      onPressed: _showFilters,
                      icon: Icon(
                        Icons.tune,
                        color: _currentFilters.hasActiveFilters 
                            ? Theme.of(context).primaryColor 
                            : null,
                      ),
                      label: Text(
                        _currentFilters.hasActiveFilters 
                            ? 'Bộ lọc (${_currentFilters.activeFiltersCount})'
                            : 'Bộ lọc',
                        style: TextStyle(
                          color: _currentFilters.hasActiveFilters 
                              ? Theme.of(context).primaryColor 
                              : null,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: _currentFilters.hasActiveFilters 
                              ? Theme.of(context).primaryColor 
                              : Colors.grey,
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 8),
                    
                    // Clear Filters Button
                    if (_currentFilters.hasActiveFilters)
                      TextButton(
                        onPressed: _clearFilters,
                        child: const Text('Xóa bộ lọc'),
                      ),
                  ],
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Search Results
          Expanded(
            child: MultiBlocListener(
              listeners: [
                BlocListener<AdvancedSearchBloc, AdvancedSearchState>(
                  listener: (context, state) {
                    if (state is SearchError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
                BlocListener<HomeBloc, HomeState>(
                  listener: (context, homeState) {
                    if (homeState is HomeLoaded) {
                      setState(() {
                        _categories = homeState.categories;
                      });
                    }
                  },
                ),
              ],
              child: BlocBuilder<AdvancedSearchBloc, AdvancedSearchState>(
                builder: (context, state) {
                  print('[AdvancedSearchPage] Current state: ${state.runtimeType}');
                  
                  // Load categories from home bloc when needed
                  if (_categories.isEmpty) {
                    context.read<HomeBloc>().add(home_events.LoadHomeDataEvent());
                  }
                  
                  return _buildSearchContent(state);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchContent(AdvancedSearchState state) {
    if (state is SearchLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is SearchSuccess) {
      return AdvancedSearchResults(
        searchResponse: state.searchResponse,
        filters: state.filters,
        allProducts: state.allProducts,
        isLoadingMore: state.isLoadingMore,
        onLoadMore: () {
          final query = _searchController.text.trim();
          if (query.isNotEmpty) {
            context.read<AdvancedSearchBloc>().add(
              search_events.LoadMoreProductsEvent(
                searchTerm: query,
                filters: state.filters,
              ),
            );
          }
        },
      );
    }

    if (state is SearchEmpty) {
      return _buildEmptyState(state);
    }

    if (state is SearchError) {
      return _buildErrorState(state);
    }

    if (state is SearchInitial || state is SearchHistoryLoaded) {
      return _buildInitialState(state);
    }

    return const SizedBox.shrink();
  }

  Widget _buildEmptyState(SearchEmpty state) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Không tìm thấy kết quả',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Không có sản phẩm nào cho "${state.searchTerm}"',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (state.suggestedKeywords.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Có thể bạn đang tìm:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: state.suggestedKeywords.map((keyword) {
                return ActionChip(
                  label: Text(keyword),
                  onPressed: () {
                    _searchController.text = keyword;
                    _performSearch();
                  },
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_currentFilters.hasActiveFilters) {
                _clearFilters();
              } else {
                _clearSearch();
              }
            },
            child: Text(
              _currentFilters.hasActiveFilters 
                  ? 'Xóa bộ lọc và thử lại'
                  : 'Thử từ khóa khác',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(SearchError state) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
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
            onPressed: _performSearch,
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState(AdvancedSearchState state) {
    final searchHistory = state is SearchInitial 
        ? state.searchHistory 
        : state is SearchHistoryLoaded 
            ? state.searchHistory 
            : <String>[];

    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (searchHistory.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tìm kiếm gần đây',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AdvancedSearchBloc>().add(search_events.ClearSearchHistoryEvent());
                  },
                  child: const Text('Xóa tất cả'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: searchHistory.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final query = searchHistory[index];
                return ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(query),
                  onTap: () {
                    _searchController.text = query;
                    _performSearch();
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.north_west),
                    onPressed: () {
                      _searchController.text = query;
                    },
                  ),
                );
              },
            ),
          ] else ...[
            const Spacer(),
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.search,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tìm kiếm sản phẩm',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Nhập từ khóa để tìm kiếm sản phẩm yêu thích',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ],
      ),
    );
  }
}

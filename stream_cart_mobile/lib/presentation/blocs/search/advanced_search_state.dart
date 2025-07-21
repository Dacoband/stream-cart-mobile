import 'package:equatable/equatable.dart';
import '../../../domain/entities/search_response_entity.dart';
import '../../../domain/entities/search_filters.dart';

abstract class AdvancedSearchState extends Equatable {
  const AdvancedSearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends AdvancedSearchState {
  final List<String> searchHistory;

  const SearchInitial({this.searchHistory = const []});

  @override
  List<Object?> get props => [searchHistory];
}

class SearchLoading extends AdvancedSearchState {}

class SearchLoadingMore extends AdvancedSearchState {
  final SearchResponseEntity currentResults;
  final SearchFilters filters;

  const SearchLoadingMore({
    required this.currentResults,
    required this.filters,
  });

  @override
  List<Object?> get props => [currentResults, filters];
}

class SearchSuccess extends AdvancedSearchState {
  final SearchResponseEntity searchResponse;
  final SearchFilters filters;
  final bool isLoadingMore;
  final List<SearchProductEntity> allProducts;

  const SearchSuccess({
    required this.searchResponse,
    required this.filters,
    this.isLoadingMore = false,
    this.allProducts = const [],
  });

  SearchSuccess copyWith({
    SearchResponseEntity? searchResponse,
    SearchFilters? filters,
    bool? isLoadingMore,
    List<SearchProductEntity>? allProducts,
  }) {
    return SearchSuccess(
      searchResponse: searchResponse ?? this.searchResponse,
      filters: filters ?? this.filters,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      allProducts: allProducts ?? this.allProducts,
    );
  }

  @override
  List<Object?> get props => [searchResponse, filters, isLoadingMore, allProducts];
}

class SearchEmpty extends AdvancedSearchState {
  final String searchTerm;
  final SearchFilters filters;
  final List<String> suggestedKeywords;

  const SearchEmpty({
    required this.searchTerm,
    required this.filters,
    this.suggestedKeywords = const [],
  });

  @override
  List<Object?> get props => [searchTerm, filters, suggestedKeywords];
}

class SearchError extends AdvancedSearchState {
  final String message;
  final String searchTerm;
  final SearchFilters filters;

  const SearchError({
    required this.message,
    required this.searchTerm,
    required this.filters,
  });

  @override
  List<Object?> get props => [message, searchTerm, filters];
}

class SearchHistoryLoaded extends AdvancedSearchState {
  final List<String> searchHistory;

  const SearchHistoryLoaded(this.searchHistory);

  @override
  List<Object?> get props => [searchHistory];
}

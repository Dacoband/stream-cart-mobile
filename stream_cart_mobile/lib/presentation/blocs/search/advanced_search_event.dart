import 'package:equatable/equatable.dart';
import '../../../domain/entities/search_filters.dart';

abstract class AdvancedSearchEvent extends Equatable {
  const AdvancedSearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchProductsEvent extends AdvancedSearchEvent {
  final String searchTerm;
  final SearchFilters? filters;

  const SearchProductsEvent({
    required this.searchTerm,
    this.filters,
  });

  @override
  List<Object?> get props => [searchTerm, filters];
}

class LoadMoreProductsEvent extends AdvancedSearchEvent {
  final String searchTerm;
  final SearchFilters filters;

  const LoadMoreProductsEvent({
    required this.searchTerm,
    required this.filters,
  });

  @override
  List<Object?> get props => [searchTerm, filters];
}

class ApplyFiltersEvent extends AdvancedSearchEvent {
  final String searchTerm;
  final SearchFilters filters;

  const ApplyFiltersEvent({
    required this.searchTerm,
    required this.filters,
  });

  @override
  List<Object?> get props => [searchTerm, filters];
}

class ClearFiltersEvent extends AdvancedSearchEvent {
  final String searchTerm;

  const ClearFiltersEvent(this.searchTerm);

  @override
  List<Object?> get props => [searchTerm];
}

class ClearSearchEvent extends AdvancedSearchEvent {}

class SaveSearchHistoryEvent extends AdvancedSearchEvent {
  final String searchTerm;

  const SaveSearchHistoryEvent(this.searchTerm);

  @override
  List<Object?> get props => [searchTerm];
}

class LoadSearchHistoryEvent extends AdvancedSearchEvent {}

class ClearSearchHistoryEvent extends AdvancedSearchEvent {}

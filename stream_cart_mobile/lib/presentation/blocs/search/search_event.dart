import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchQueryChangedEvent extends SearchEvent {
  final String query;

  const SearchQueryChangedEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class SearchSubmittedEvent extends SearchEvent {
  final String query;

  const SearchSubmittedEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class ClearSearchEvent extends SearchEvent {
  const ClearSearchEvent();
}

class SearchHistoryLoadedEvent extends SearchEvent {
  const SearchHistoryLoadedEvent();
}

class SearchHistoryItemSelectedEvent extends SearchEvent {
  final String query;

  const SearchHistoryItemSelectedEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class ClearSearchHistoryEvent extends SearchEvent {
  const ClearSearchHistoryEvent();
}

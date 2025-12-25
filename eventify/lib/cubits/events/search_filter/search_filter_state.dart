import 'package:equatable/equatable.dart';
import 'package:eventify/components/top_picks.dart';

class SearchFilterState extends Equatable {
  final String searchQuery;
  final String selectedFilter; // 'All', 'Recent', 'Closest'
  final List<TopPicks> filteredEvents;

  const SearchFilterState({
    this.searchQuery = '',
    this.selectedFilter = 'All',
    this.filteredEvents = const [],
  });

  SearchFilterState copyWith({
    String? searchQuery,
    String? selectedFilter,
    List<TopPicks>? filteredEvents,
  }) {
    return SearchFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      filteredEvents: filteredEvents ?? this.filteredEvents,
    );
  }

  @override
  List<Object?> get props => [searchQuery, selectedFilter, filteredEvents];
}

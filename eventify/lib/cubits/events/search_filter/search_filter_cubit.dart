import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventify/repositories/events_repository.dart';
import 'package:eventify/components/top_picks.dart';
import 'package:eventify/cubits/events/search_filter/search_filter_state.dart';

class SearchFilterCubit extends Cubit<SearchFilterState> {
  final EventsRepository _eventsRepository;
  final String userCity;

  SearchFilterCubit(this._eventsRepository, {this.userCity = 'Algiers'})
      : super(const SearchFilterState());

  // Update search query and apply filters
  Future<void> updateSearchQuery(String query, List<TopPicks> allEvents) async {
    final filtered = await _applyFilters(
      allEvents,
      query,
      state.selectedFilter,
    );

    emit(state.copyWith(
      searchQuery: query,
      filteredEvents: filtered,
    ));
  }

  // Set filter type and apply
  Future<void> setFilter(String filter, List<TopPicks> allEvents) async {
    final filtered = await _applyFilters(
      allEvents,
      state.searchQuery,
      filter,
    );

    emit(state.copyWith(
      selectedFilter: filter,
      filteredEvents: filtered,
    ));
  }

  // Apply all filters (search + filter type)
  Future<void> applyFilters(List<TopPicks> allEvents) async {
    final filtered = await _applyFilters(
      allEvents,
      state.searchQuery,
      state.selectedFilter,
    );

    emit(state.copyWith(filteredEvents: filtered));
  }

  // Private method to combine search and filter logic
  Future<List<TopPicks>> _applyFilters(
    List<TopPicks> events,
    String searchQuery,
    String filter,
  ) async {
    // First apply filter
    List<TopPicks> filtered = await _eventsRepository.filterEvents(
      filter,
      userCity,
    );

    // Then apply search if query exists
    if (searchQuery.isNotEmpty) {
      filtered = await _eventsRepository.searchEvents(searchQuery);
    }

    return filtered;
  }

  // Reset to initial state
  void reset(List<TopPicks> allEvents) {
    emit(SearchFilterState(filteredEvents: allEvents));
  }
}
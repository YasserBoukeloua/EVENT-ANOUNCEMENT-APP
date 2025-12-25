import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventify/repositories/events_repository.dart';
import 'package:eventify/cubits/events/events_state.dart';

class EventsCubit extends Cubit<EventsState> {
  final EventsRepository _eventsRepository;

  EventsCubit(this._eventsRepository) : super(const EventsInitial());

  // Load all events
  Future<void> loadEvents() async {
    emit(const EventsLoading());

    try {
      final events = await _eventsRepository.getEvents();
      emit(EventsLoaded(events));
    } catch (e) {
      emit(EventsError(e.toString()));
    }
  }

  // Refresh events
  Future<void> refreshEvents() async {
    try {
      final events = await _eventsRepository.refreshEvents();
      emit(EventsLoaded(events));
    } catch (e) {
      emit(EventsError(e.toString()));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventify/repositories/events_repository.dart';
import 'package:eventify/cubits/events/event_details/event_details_state.dart';
import 'package:eventify/components/top_picks.dart';

class EventDetailsCubit extends Cubit<EventDetailsState> {
  final EventsRepository _eventsRepository;

  EventDetailsCubit(this._eventsRepository) : super(const EventDetailsInitial());

  // Load event details by ID
  Future<void> loadEventDetails(int eventId) async {
    emit(const EventDetailsLoading());

    try {
      final event = await _eventsRepository.getEventById(eventId);
      emit(EventDetailsLoaded(event));
    } catch (e) {
      emit(EventDetailsError(e.toString()));
    }
  }

  // Load event details directly with event object
  void loadEvent(TopPicks event) {
    emit(EventDetailsLoaded(event));
  }

  // Reset to initial state
  void reset() {
    emit(const EventDetailsInitial());
  }
}

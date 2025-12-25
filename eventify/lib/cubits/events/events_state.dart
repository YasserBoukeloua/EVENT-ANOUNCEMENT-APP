import 'package:equatable/equatable.dart';
import 'package:eventify/components/top_picks.dart';

abstract class EventsState extends Equatable {
  const EventsState();

  @override
  List<Object?> get props => [];
}

class EventsInitial extends EventsState {
  const EventsInitial();
}

class EventsLoading extends EventsState {
  const EventsLoading();
}

class EventsLoaded extends EventsState {
  final List<TopPicks> events;

  const EventsLoaded(this.events);

  @override
  List<Object?> get props => [events];
}

class EventsError extends EventsState {
  final String error;

  const EventsError(this.error);

  @override
  List<Object?> get props => [error];
}

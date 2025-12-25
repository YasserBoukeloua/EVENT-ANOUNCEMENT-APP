import 'package:equatable/equatable.dart';
import 'package:eventify/components/top_picks.dart';

abstract class EventDetailsState extends Equatable {
  const EventDetailsState();

  @override
  List<Object?> get props => [];
}

class EventDetailsInitial extends EventDetailsState {
  const EventDetailsInitial();
}

class EventDetailsLoading extends EventDetailsState {
  const EventDetailsLoading();
}

class EventDetailsLoaded extends EventDetailsState {
  final TopPicks? event;

  const EventDetailsLoaded(this.event);

  @override
  List<Object?> get props => [event];
}

class EventDetailsError extends EventDetailsState {
  final String error;

  const EventDetailsError(this.error);

  @override
  List<Object?> get props => [error];
}

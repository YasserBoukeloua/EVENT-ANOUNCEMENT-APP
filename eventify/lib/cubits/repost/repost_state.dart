import 'package:equatable/equatable.dart';
import 'package:eventify/components/top_picks.dart'; // Import TopPicks

abstract class RepostState extends Equatable {
  const RepostState();

  @override
  List<Object?> get props => [];
}

class RepostInitial extends RepostState {
  const RepostInitial();
}

class RepostLoading extends RepostState {
  const RepostLoading();
}

class RepostLoaded extends RepostState {
  final List<TopPicks> reposts; // Use TopPicks instead of Repost

  const RepostLoaded(this.reposts);

  @override
  List<Object?> get props => [reposts];
}

class RepostError extends RepostState {
  final String errorMessage; // Keep errorMessage

  const RepostError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
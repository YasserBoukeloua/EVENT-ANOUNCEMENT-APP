import 'package:eventify/components/top_picks.dart';
import 'event_repository.dart';

abstract class EventRepositoryBase {
  Future<List<TopPicks>> getEvents();
  Future<TopPicks?> getEventById(int id);
  Future<List<TopPicks>> searchEvents(String query);
  Future<List<TopPicks>> filterEvents(String filter, String userCity);

  static EventRepositoryBase? _instance;

  static EventRepositoryBase getInstance() {
    _instance ??= EventRepository();
    return _instance!;
  }
}

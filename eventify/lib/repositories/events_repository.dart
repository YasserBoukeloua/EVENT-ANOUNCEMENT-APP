import 'package:eventify/data/repo/event/event_repository.dart';
import 'package:eventify/components/top_picks.dart';

class EventsRepository extends EventRepository {
  Future<List<TopPicks>> refreshEvents() async {
    return await getEvents();
  }
}

import 'package:eventify/components/top_picks.dart';
import 'package:eventify/data/databases/db_events.dart';
import 'event_repo_abstract.dart';

class EventRepository extends EventRepositoryBase {
  final _dbEvents = DBEventsTable();

  // Convert database record to TopPicks model
  TopPicks _convertToTopPicks(Map<String, dynamic> record) {
    return TopPicks(
      record['id'],
      record['date'] != null ? DateTime.parse(record['date']) : null,
      record['title'],
      record['photo_path'],
      record['location'],
      record['publisher'],
      record['is_free'] == 1,
      record['category'],
      description: record['description'],
    );
  }

  @override
  Future<List<TopPicks>> getEvents() async {
    try {
      final records = await _dbEvents.getRecords();
      return records.map((record) => _convertToTopPicks(record)).toList();
    } catch (e) {
      print('Get events error: $e');
      return [];
    }
  }

  @override
  Future<TopPicks?> getEventById(int id) async {
    try {
      final record = await _dbEvents.getRecordById(id);
      
      if (record == null) {
        return null;
      }

      return _convertToTopPicks(record);
    } catch (e) {
      print('Get event by ID error: $e');
      return null;
    }
  }

  @override
  Future<List<TopPicks>> searchEvents(String query) async {
    try {
      final events = await getEvents();
      
      if (query.isEmpty) {
        return events;
      }

      final lowercaseQuery = query.toLowerCase();
      return events.where((event) {
        final name = (event.nameOfevent ?? '').toLowerCase();
        final location = (event.location ?? '').toLowerCase();
        return name.contains(lowercaseQuery) || location.contains(lowercaseQuery);
      }).toList();
    } catch (e) {
      print('Search events error: $e');
      return [];
    }
  }

  @override
  Future<List<TopPicks>> filterEvents(String filter, String userCity) async {
    try {
      List<TopPicks> events = await getEvents();

      int _distanceScore(TopPicks event) {
        final loc = (event.location ?? '').toLowerCase();
        final city = userCity.toLowerCase();
        return loc.contains(city) ? 0 : 1;
      }

      double _preferenceScore(TopPicks event) {
        final cat = event.category.toLowerCase();
        if (cat.contains('technology') || cat.contains('education')) return 1.0;
        if (cat.contains('business')) return 0.7;
        return 0.4;
      }

      switch (filter) {
        case 'Recent':
          events.sort((a, b) =>
              (b.date ?? DateTime.now()).compareTo(a.date ?? DateTime.now()));
          break;
        case 'Closest':
          events.sort((a, b) => _distanceScore(a).compareTo(_distanceScore(b)));
          break;
        case 'All':
        default:
          events.sort((a, b) {
            final now = DateTime.now();
            final aDays = a.date != null ? a.date!.difference(now).inDays.abs() : 365;
            final bDays = b.date != null ? b.date!.difference(now).inDays.abs() : 365;
            final aScore = (365 - aDays) * 0.4 + (1 - _distanceScore(a)) * 0.3 + _preferenceScore(a) * 0.3;
            final bScore = (365 - bDays) * 0.4 + (1 - _distanceScore(b)) * 0.3 + _preferenceScore(b) * 0.3;
            return bScore.compareTo(aScore);
          });
          break;
      }

      return events;
    } catch (e) {
      print('Filter events error: $e');
      return [];
    }
  }
}

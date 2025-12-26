import 'package:eventify/data/databases/db_users.dart';
import 'package:eventify/data/databases/db_events.dart';

class DatabaseSeeder {
  final DBUsersTable _dbUsers = DBUsersTable();
  final DBEventsTable _dbEvents = DBEventsTable();

  Future<void> seedDatabase() async {
    await _seedUsers();
    await _seedEvents();
  }

  Future<void> _seedUsers() async {
    final users = await _dbUsers.getRecords();
    
    // Check if verified user exists
    final verifiedUserExists = users.any((u) => u['email'] == 'john.creator@eventify.com');
    if (!verifiedUserExists) {
      await _dbUsers.insertRecord({
        'email': 'john.creator@eventify.com',
        'username': 'johncreator',
        'password': 'password123',
        'name': 'John',
        'lastname': 'Creator',
        'is_certified': 1,
        'created_at': DateTime.now().toIso8601String(),
      });
      print('Seeded verified user: John Creator');
    }

    // Check if normal user exists
    final normalUserExists = users.any((u) => u['email'] == 'mary.user@eventify.com');
    if (!normalUserExists) {
      await _dbUsers.insertRecord({
        'email': 'mary.user@eventify.com',
        'username': 'maryuser',
        'password': 'password123',
        'name': 'Mary',
        'lastname': 'User',
        'is_certified': 0,
        'created_at': DateTime.now().toIso8601String(),
      });
      print('Seeded normal user: Mary User');
    }
  }

  Future<void> _seedEvents() async {
    final events = await _dbEvents.getRecords();
    
    // Check if events exist
    if (events.isEmpty) {
      // Event 1
      await _dbEvents.insertRecord({
        'title': 'Tech Innovation Summit 2025',
        'description': 'Join us for the biggest tech conference of the year featuring AI, blockchain, and cloud computing innovations.',
        'date': '2025-02-15 09:00:00',
        'location': 'Algiers Convention Center, Algiers',
        'category': 'Technology',
        'publisher': 'johncreator',
        'is_free': 0,
        'photo_path': 'lib/assets/event1.webp',
        'created_at': DateTime.now().toIso8601String(),
      });

      // Event 2
      await _dbEvents.insertRecord({
        'title': 'Summer Music Festival',
        'description': 'Experience an unforgettable night with top artists from around the world. Live performances, food, and entertainment.',
        'date': '2025-03-20 18:00:00',
        'location': 'National Park, Oran',
        'category': 'Music',
        'publisher': 'johncreator',
        'is_free': 0,
        'photo_path': 'lib/assets/event2.webp',
        'created_at': DateTime.now().toIso8601String(),
      });

      // Event 3
      await _dbEvents.insertRecord({
        'title': 'Mobile App Development Workshop',
        'description': 'Learn Flutter and build your first mobile app in this hands-on workshop. Perfect for beginners and intermediate developers.',
        'date': '2025-01-30 14:00:00',
        'location': 'University of Algiers, Algiers',
        'category': 'Education',
        'publisher': 'johncreator',
        'is_free': 1,
        'photo_path': 'lib/assets/event3.webp',
        'created_at': DateTime.now().toIso8601String(),
      });
      
      print('Seeded 3 test events');
    }
  }
}

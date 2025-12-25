import 'package:shared_preferences/shared_preferences.dart';
import 'db_users.dart';
import 'db_events.dart';
import 'db_comments.dart';
import 'db_repost.dart'; // NEW

class DatabaseSeeder {
  static const String _keySeeded = 'database_seeded_v3'; // Updated for reposts

  // Check if database has been seeded
  static Future<bool> isSeeded() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keySeeded) ?? false;
  }

  // Mark database as seeded
  static Future<void> markAsSeeded() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keySeeded, true);
  }

  // Seed the database with initial data
  static Future<void> seedDatabase() async {
    if (await isSeeded()) {
      print('Database already seeded, skipping...');
      return;
    }

    print('Seeding database with initial data...');

    // Create default user
    final usersTable = DBUsersTable();
    await usersTable.insertRecord({
      'email': 'demo@eventify.com',
      'username': 'demo',
      'password': 'demo123',
      'name': 'Demo',
      'lastname': 'User',
      'date_of_birth': '1995-01-01',
      'is_certified': 1,
      'photo': null,
      'created_at': DateTime.now().toIso8601String(),
    });

    // Create sample events
    final eventsTable = DBEventsTable();
    
    await eventsTable.insertRecord({
      'title': 'Tech Conference 2025',
      'description': 'Join us for the biggest technology conference of the year.',
      'date': '2025-01-11',
      'location': 'ENSIA, Algiers',
      'category': 'Technology',
      'publisher': 'TechEvents Inc',
      'is_free': 1,
      'photo_path': 'lib/assets/event4.jpg',
      'created_at': DateTime.now().toIso8601String(),
    });

    // ... (other events as before)

    // Add sample reposts
    final repostsTable = DBRepostsTable();
    
    await repostsTable.insertRecord({
      'event_id': 1,
      'user_id': 1,
      'caption': 'This looks amazing! Sharing with my network.',
      'created_at': DateTime.now().toIso8601String(),
    });

    await repostsTable.insertRecord({
      'event_id': 2,
      'user_id': 1,
      'caption': 'Great opportunity for networking!',
      'created_at': DateTime.now().toIso8601String(),
    });

    // ... (comments as before)

    await markAsSeeded();
    print('Database seeded successfully!');
  }
}
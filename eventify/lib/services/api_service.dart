import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Production Railway backend
  static const String baseUrl =
      'https://event-anouncement-app-production.up.railway.app';

  // GET request helper
  Future<dynamic> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception(
          'Failed to post data: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ===== Authentication Endpoints =====

  // Login user
  Future<dynamic> loginUser(String email, String password) async {
    return await post('/auth/login/', {'email': email, 'password': password});
  }

  // Create/Signup user
  Future<dynamic> signupUser(Map<String, dynamic> userData) async {
    return await post('/users/create/', userData);
  }

  // ===== User Endpoints =====

  Future<List<dynamic>> getUsers() async {
    return await get('/users/');
  }

  // Fetch single user
  Future<dynamic> getUser(int id) async {
    return await get('/users/$id/');
  }

  // Update user
  Future<dynamic> updateUser(int id, Map<String, dynamic> data) async {
    return await post('/users/$id/update/', data);
  }

  // ===== Event Endpoints =====

  // Fetch all events
  Future<List<dynamic>> getEvents() async {
    return await get('/events/');
  }

  // Fetch single event
  Future<dynamic> getEvent(int id) async {
    return await get('/events/$id/');
  }

  // Create event
  Future<dynamic> createEvent(Map<String, dynamic> eventData) async {
    return await post('/events/create/', eventData);
  }

  // Update event
  Future<dynamic> updateEvent(int id, Map<String, dynamic> data) async {
    return await post('/events/$id/update/', data);
  }

  // Delete event
  Future<dynamic> deleteEvent(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/events/$id/delete/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        return {'message': 'Event deleted successfully'};
      } else {
        throw Exception('Failed to delete event: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ===== Post Endpoints =====

  // Fetch all posts
  Future<List<dynamic>> getPosts() async {
    return await get('/posts/');
  }

  // Fetch single post
  Future<dynamic> getPost(int id) async {
    return await get('/posts/$id/');
  }

  // Create post
  Future<dynamic> createPost(Map<String, dynamic> postData) async {
    return await post('/posts/create/', postData);
  }

  // ===== Favorite Endpoints =====

  // Get favorites
  Future<List<dynamic>> getFavorites() async {
    return await get('/favorites/');
  }

  // Add favorite
  Future<dynamic> addFavorite(int eventId) async {
    return await post('/favorites/create/', {'event_id': eventId});
  }

  // Remove favorite
  Future<dynamic> removeFavorite(int favoriteId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/favorites/$favoriteId/delete/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        return {'message': 'Favorite removed successfully'};
      } else {
        throw Exception('Failed to remove favorite: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

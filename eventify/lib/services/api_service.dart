import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Change this to your Django backend URL
  static const String baseUrl = 'http://127.0.0.1:8000'; // For Android emulator


  // GET request helper
  Future<dynamic> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
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
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<dynamic>> getUsers() async {
    return await get('/users/');
  }

  // Fetch single user
  Future<dynamic> getUser(int id) async {
    return await get('/users/$id/');
  }

  // Fetch all events
  Future<List<dynamic>> getEvents() async {
    return await get('/events/');
  }

  // Fetch single event
  Future<dynamic> getEvent(int id) async {
    return await get('/events/$id/');
  }

  // Fetch all posts
  Future<List<dynamic>> getPosts() async {
    return await get('/posts/');
  }

  // Create a new user
  Future<dynamic> createUser(Map<String, dynamic> userData) async {
    return await post('/users/create/', userData);
  }

  // Create a new event
  Future<dynamic> createEvent(Map<String, dynamic> eventData) async {
    return await post('/events/create/', eventData);
  }
}

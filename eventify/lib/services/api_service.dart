import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Production API URL
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
        final errorBody = json.decode(response.body);
        throw Exception(
          errorBody['error'] ?? 'Failed to post data: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to update data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<bool> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
      );

      return response.statusCode == 204 || response.statusCode == 200;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ========== USER ENDPOINTS ==========

  Future<List<dynamic>> getUsers() async {
    return await get('/users/');
  }

  Future<dynamic> getUser(int id) async {
    return await get('/users/$id/');
  }

  Future<dynamic> createUser(Map<String, dynamic> userData) async {
    return await post('/users/create/', userData);
  }

  Future<dynamic> updateUser(int id, Map<String, dynamic> userData) async {
    return await put('/users/$id/update/', userData);
  }

  Future<bool> deleteUser(int id) async {
    return await delete('/users/$id/delete/');
  }

  // ========== EVENT ENDPOINTS ==========

  Future<List<dynamic>> getEvents() async {
    return await get('/events/');
  }

  Future<dynamic> getEvent(int id) async {
    return await get('/events/$id/');
  }

  Future<dynamic> createEvent(Map<String, dynamic> eventData) async {
    return await post('/events/create/', eventData);
  }

  Future<dynamic> updateEvent(int id, Map<String, dynamic> eventData) async {
    return await put('/events/$id/update/', eventData);
  }

  Future<bool> deleteEvent(int id) async {
    return await delete('/events/$id/delete/');
  }

  // ========== POST ENDPOINTS ==========

  Future<List<dynamic>> getPosts() async {
    return await get('/posts/');
  }

  Future<dynamic> getPost(int id) async {
    return await get('/posts/$id/');
  }

  Future<dynamic> createPost(Map<String, dynamic> postData) async {
    return await post('/posts/create/', postData);
  }

  Future<dynamic> updatePost(int id, Map<String, dynamic> postData) async {
    return await put('/posts/$id/update/', postData);
  }

  Future<bool> deletePost(int id) async {
    return await delete('/posts/$id/delete/');
  }

  Future<dynamic> likePost(int id) async {
    return await post('/posts/$id/like/', {});
  }

  // ========== COMMENT ENDPOINTS ==========

  Future<List<dynamic>> getComments() async {
    return await get('/comments/');
  }

  Future<dynamic> createComment(Map<String, dynamic> commentData) async {
    return await post('/comments/create/', commentData);
  }

  // ========== FAVORITE ENDPOINTS ==========

  Future<List<dynamic>> getFavorites() async {
    return await get('/favorites/');
  }

  Future<dynamic> createFavorite(int eventId) async {
    return await post('/favorites/create/', {'event_id': eventId});
  }

  Future<bool> deleteFavorite(int id) async {
    return await delete('/favorites/$id/delete/');
  }

  // ========== PHOTO ENDPOINTS ==========

  Future<List<dynamic>> getPhotos() async {
    return await get('/photos/');
  }

  Future<dynamic> getPhoto(int id) async {
    return await get('/photos/$id/');
  }

  // ========== REPOST ENDPOINTS ==========

  Future<List<dynamic>> getReposts() async {
    return await get('/reposts/');
  }

  Future<List<dynamic>> getRepostsByUser(int userId) async {
    return await get('/reposts/user/$userId/');
  }

  Future<dynamic> getRepost(int id) async {
    return await get('/reposts/$id/');
  }

  Future<dynamic> createRepost(
    int userId,
    int eventId, {
    String? caption,
  }) async {
    return await post('/reposts/create/', {
      'user_id': userId,
      'event_id': eventId,
      'caption': caption ?? '',
    });
  }

  Future<bool> deleteRepost(int id) async {
    return await delete('/reposts/$id/delete/');
  }

  Future<bool> removeRepost(int userId, int eventId) async {
    return await delete('/reposts/remove/$userId/$eventId/');
  }

  Future<bool> hasReposted(int userId, int eventId) async {
    final response = await get('/reposts/check/$userId/$eventId/');
    return response['reposted'] ?? false;
  }
}

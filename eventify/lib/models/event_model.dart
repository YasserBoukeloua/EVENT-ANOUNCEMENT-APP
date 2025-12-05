// lib/models/event_model.dart
import 'user_model.dart';
import 'package:eventify/services/api_service.dart';

class Photo {
  final int id;
  final String contentType;
  final String image; // This will be the full URL from Django
  final String uploadedAt;
  final int? eventId;
  final int? postId;

  Photo({
    required this.id,
    required this.contentType,
    required this.image,
    required this.uploadedAt,
    this.eventId,
    this.postId,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      contentType: json['content_type'],
      image: json['image'], // Django serializer returns full URL
      uploadedAt: json['uploaded_at'],
      eventId: json['event'],
      postId: json['post'],
    );
  }
  String getFullImageUrl(String baseUrl) {
    if (image.startsWith('http')) {
      return image;
    }
    if (!baseUrl.endsWith('/') && !image.startsWith('/')) {
      return '$baseUrl/$image';
    }
    return '$baseUrl$image';
  }
}

class Event {
  final int id;
  final User creator;
  final List<Photo> photos;
  final String title;
  final String description;
  final String date;
  final String location;
  final String createdAt;
  final String updatedAt;

  Event({
    required this.id,
    required this.creator,
    required this.photos,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      creator: User.fromJson(json['creator']),
      photos: (json['photos'] as List?)
              ?.map((photo) => Photo.fromJson(photo))
              .toList() ??
          [],
      title: json['title'],
      description: json['description'],
      date: json['date'],
      location: json['location'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  String get firstPhotoUrl {
    if (photos.isEmpty) return '';
    return photos.first.getFullImageUrl(ApiService.baseUrl);
  }

  bool get hasPhotos => photos.isNotEmpty;
}

import 'package:flutter/material.dart';

class Event {
  final String title;
  final String location;
  final String date;
  final String imageUrl;
  bool isFavorite;

  Event({
    required this.title,
    required this.location,
    required this.date,
    required this.imageUrl,
    this.isFavorite = true,
  });
}

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final List<Event> events = [
    Event(
      title: 'Technology\nEvent',
      location: 'ensia, Algiers',
      date: '12 Nov. 2025',
      imageUrl:
          'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=400',
    ),
    Event(
      title: 'Workshop of\nMobile',
      location: 'ensia, Algiers',
      date: '12 Nov. 2025',
      imageUrl:
          'https://images.unsplash.com/photo-1475721027785-f74eccf877e2?w=400',
    ),
    Event(
      title: 'Workshop of\nMobile',
      location: 'ensia, Algiers',
      date: '12 Nov. 2025',
      imageUrl:
          'https://images.unsplash.com/photo-1511578314322-379afb476865?w=400',
    ),
    Event(
      title: 'Workshop of\nMobile',
      location: 'ensia, Algiers',
      date: '12 Nov. 2025',
      imageUrl:
          'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=400',
    ),
    Event(
      title: 'Workshop of\nMobile',
      location: 'ensia, Algiers',
      date: '12 Nov. 2025',
      imageUrl:
          'https://images.unsplash.com/photo-1475721027785-f74eccf877e2?w=400',
    ),
  ];

  void _removeFavorite(int index) {
    setState(() {
      events.removeAt(index);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Removed from favorites'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF6C5CE7),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            // Backend would handle undo functionality
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D1B4E),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with back button
          SafeArea(
            bottom: false,
            child: Container(
              color: const Color(0xFF2D1B4E),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Favorites',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'JosefinSans',
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Event count
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 20.0),
                    child: Text(
                      '${events.length} Event${events.length != 1 ? 's' : ''}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'JosefinSans',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Events List
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFD1D1D6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: events.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.star_border,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No favorites yet',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                              fontFamily: 'JosefinSans',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Start adding events to your favorites',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontFamily: 'JosefinSans',
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        return EventCard(
                          event: events[index],
                          onRemove: () => _removeFavorite(index),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onRemove;

  const EventCard({
    Key? key,
    required this.event,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Navigate to event details - functionality can be added later
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Event Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    event.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFF6C5CE7).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.event,
                          color: Color(0xFF6C5CE7),
                          size: 32,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 16),

                // Event Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.2,
                          fontFamily: 'JosefinSans',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: Color(0xFF6C5CE7),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              event.location,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                                fontFamily: 'JosefinSans',
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Color(0xFF6C5CE7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            event.date,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                              fontFamily: 'JosefinSans',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Favorite Button
                IconButton(
                  icon: const Icon(Icons.star, color: Color(0xFF6C5CE7)),
                  onPressed: onRemove,
                  tooltip: 'Remove from favorites',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
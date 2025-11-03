import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF2D1B4E),
        fontFamily: 'SF Pro',
      ),
      home: const FavoritesScreen(),
    );
  }
}

class Event {
  final String title;
  final String location;
  final String date;
  final String imageUrl;

  Event({
    required this.title,
    required this.location,
    required this.date,
    required this.imageUrl,
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

  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                'Favorites',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    return EventCard(event: events[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A0F2E),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, 0),
              _buildNavItem(Icons.calendar_today_outlined, 1),
              _buildNavItem(Icons.star_outline, 2),
              _buildNavItem(Icons.person_outline, 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6C5CE7) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E5EA),
        borderRadius: BorderRadius.circular(20),
      ),
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
                  color: const Color(0xFF6C5CE7),
                  child: const Icon(Icons.event, color: Colors.white),
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
                    Text(
                      event.location,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6C5CE7),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      event.date,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6C5CE7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Favorite Button
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFF6C5CE7),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.star, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }
}

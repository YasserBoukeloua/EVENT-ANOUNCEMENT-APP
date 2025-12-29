import 'package:flutter/material.dart';
import 'package:eventify/constants/app_colors.dart';
import 'package:eventify/localization/app_language.dart';
import 'package:eventify/data/databases/db_events.dart';
import 'package:eventify/data/databases/db_repost.dart';
import 'package:intl/intl.dart';

class VisibleProfilePage extends StatefulWidget {
  final String username;
  final String? fullName;

  const VisibleProfilePage({Key? key, required this.username, this.fullName})
    : super(key: key);

  @override
  State<VisibleProfilePage> createState() => _VisibleProfilePageState();
}

class _VisibleProfilePageState extends State<VisibleProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DBEventsTable _dbEvents = DBEventsTable();
  final DBRepostsTable _dbReposts = DBRepostsTable();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayName = widget.fullName != null && widget.fullName!.isNotEmpty
        ? widget.fullName!
        : widget.username;
    final userScore = 1250; // Placeholder
    final eventsCreated = 3; // Placeholder

    return Scaffold(
      backgroundColor: AppColors.backgroundMedium,
      body: Column(
        children: [
          // Header with gradient
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                child: Column(
                  children: [
                    // Back button at top
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        Text(
                          'Profile',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'JosefinSans',
                          ),
                        ),
                        const SizedBox(
                          width: 48,
                        ), // Spacer to balance back button
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 45,
                            color: AppColors.primaryMedium,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'JosefinSans',
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '@${widget.username}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontFamily: 'JosefinSans',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // User Score Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildScoreItem(
                            icon: Icons.star,
                            label: AppLanguage.t('profile_score'),
                            value: userScore.toString(),
                            color: Colors.amber,
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.white.withOpacity(0.3),
                          ),
                          _buildScoreItem(
                            icon: Icons.add_circle_outline,
                            label: AppLanguage.t('profile_created'),
                            value: eventsCreated.toString(),
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Tab bar
          Material(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primaryDark,
              labelColor: AppColors.primaryDark,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: 'Posted Events', icon: Icon(Icons.event)),
                Tab(text: 'Reposts', icon: Icon(Icons.repeat)),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Posted Events Tab
                _buildPostedEventsTab(),
                // Reposts Tab
                _buildRepostsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostedEventsTab() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _dbEvents.getEventsByPublisher(widget.username),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryDark),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error loading events',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        final events = snapshot.data ?? [];

        if (events.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_note, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 20),
                Text(
                  'No Events Posted',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                    fontFamily: 'JosefinSans',
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'This user hasn\'t posted any events yet',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[500],
                    fontFamily: 'JosefinSans',
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return _buildEventCard(event);
          },
        );
      },
    );
  }

  Widget _buildRepostsTab() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _dbReposts.getRepostsByUsername(widget.username),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryDark),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error loading reposts',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        final reposts = snapshot.data ?? [];

        if (reposts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.repeat, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 20),
                Text(
                  'No Reposts',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                    fontFamily: 'JosefinSans',
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'This user hasn\'t shared any events yet',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[500],
                    fontFamily: 'JosefinSans',
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: reposts.length,
          itemBuilder: (context, index) {
            final repost = reposts[index];
            return _buildRepostCard(repost);
          },
        );
      },
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    final title = event['title'] ?? 'Event';
    final location = event['location'] ?? 'Location';
    final date = event['date'];
    final photoPath = event['photo_path'] ?? 'lib/assets/event1.webp';
    final description = event['description'] ?? '';

    String formattedDate = 'Date not set';
    if (date != null) {
      try {
        final eventDate = DateTime.parse(date);
        formattedDate = DateFormat('dd MMM yyyy').format(eventDate);
      } catch (e) {
        formattedDate = date.toString();
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event image
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(photoPath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Event info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'JosefinSans',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontFamily: 'JosefinSans',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          location,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontFamily: 'JosefinSans',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                        fontFamily: 'JosefinSans',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRepostCard(Map<String, dynamic> repost) {
    final eventTitle = repost['event_title'] ?? 'Event';
    final eventLocation = repost['event_location'] ?? 'Location';
    final eventDate = repost['event_date'];
    final eventPhotoPath =
        repost['event_photo_path'] ?? 'lib/assets/event1.webp';

    String formattedEventDate = 'Date not set';
    if (eventDate != null) {
      try {
        final date = DateTime.parse(eventDate);
        formattedEventDate = DateFormat('dd MMM yyyy').format(date);
      } catch (e) {
        formattedEventDate = eventDate.toString();
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Repost badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryDark.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.repeat, size: 14, color: AppColors.primaryDark),
                  const SizedBox(width: 6),
                  const Text(
                    'Shared Event',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primaryDark,
                      fontFamily: 'JosefinSans',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Event preview image and info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  // Event image
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage(eventPhotoPath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Event info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          eventTitle,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'JosefinSans',
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 12,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                eventLocation,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontFamily: 'JosefinSans',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 12,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              formattedEventDate,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontFamily: 'JosefinSans',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'JosefinSans',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
            fontFamily: 'JosefinSans',
          ),
        ),
      ],
    );
  }
}

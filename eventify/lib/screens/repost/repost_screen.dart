import 'package:eventify/data/databases/db_repost.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventify/constants/app_colors.dart';
import 'package:eventify/cubits/repost/repost_cubit.dart';
import 'package:eventify/cubits/repost/repost_state.dart';
import 'package:eventify/cubits/profile/profile_cubit.dart';
import 'package:eventify/cubits/profile/profile_state.dart';
import 'package:eventify/screens/login/login_prompt_screen.dart';
import 'package:eventify/data/databases/db_repost.dart';
import 'package:intl/intl.dart';

class RepostScreen extends StatelessWidget {
  const RepostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, profileState) {
        // Check if user is authenticated
        final isAuthenticated = profileState.user != null;

        if (!isAuthenticated) {
          // Show login prompt for unauthenticated users
          return const LoginPromptScreen(
            featureName: 'Reposts',
            description: 'Please log in or sign up to view and share event reposts',
          );
        }

        // Show normal repost screen for authenticated users
        return Scaffold(
          backgroundColor: AppColors.primaryDark,
          body: Column(
            children: [
              // Header
              SafeArea(
                bottom: false,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  color: AppColors.primaryDark,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Reposts Feed',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'JosefinSans',
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'See what events people are sharing',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontFamily: 'JosefinSans',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFD1D1D6),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _getAllRepostsWithUsers(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryDark,
                          ),
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
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
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
                              const Icon(
                                Icons.repeat,
                                size: 80,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'No Reposts Yet',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Be the first to share an event!',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
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
                          return RepostCard(repostData: repost);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> _getAllRepostsWithUsers() async {
    try {
      final dbReposts = DBRepostsTable();
      return await dbReposts.getAllReposts();
    } catch (e) {
      print('Error getting reposts: $e');
      return [];
    }
  }
}

class RepostCard extends StatelessWidget {
  final Map<String, dynamic> repostData;

  const RepostCard({
    Key? key,
    required this.repostData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract data from the map
    final eventTitle = repostData['event_title'] ?? 'Event';
    final eventImage = repostData['event_photo_path'] ?? 'lib/assets/event4.jpg';
    final eventLocation = repostData['event_location'] ?? 'Location';
    final eventDate = repostData['event_date'];
    final username = repostData['user_username'] ?? 'User';
    final userName = repostData['user_name'] as String?;
    final userLastName = repostData['user_lastname'] as String?;
    final userPhoto = repostData['user_photo'] as String?;
    final caption = repostData['caption'] as String?;
    final repostTime = repostData['created_at'];

    // Create display name
    String displayName = username;
    if (userName != null && userName.isNotEmpty) {
      displayName = userLastName != null && userLastName.isNotEmpty
          ? '$userName $userLastName'
          : userName;
    }

    // Format repost time
    String timeAgo = 'Just now';
    if (repostTime != null) {
      try {
        final repostDate = DateTime.parse(repostTime);
        timeAgo = _calculateTimeAgo(repostDate);
      } catch (e) {
        print('Error parsing repost time: $e');
      }
    }

    // Format event date
    String formattedEventDate = 'Date not set';
    if (eventDate != null) {
      try {
        final date = DateTime.parse(eventDate);
        formattedEventDate = DateFormat('dd/MM/yyyy').format(date);
      } catch (e) {
        formattedEventDate = eventDate.toString();
      }
    }

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
            // Navigate to event details
            // Navigator.push(context, MaterialPageRoute(builder: (context) => PostDetails(event: ...)));
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User info row
                Row(
                  children: [
                    // User avatar
                    _buildUserAvatar(userPhoto, displayName),
                    const SizedBox(width: 12),
                    
                    // User name and repost info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(
                                Icons.repeat,
                                size: 14,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Shared $timeAgo',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Repost icon
                    Icon(
                      Icons.repeat,
                      color: AppColors.primaryDark,
                      size: 20,
                    ),
                  ],
                ),
                
                // Caption if available
                if (caption != null && caption.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      caption,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                
                // Event preview
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(),
                  ),
                  child: Row(
                    children: [
                      // Event image
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage(eventImage),
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
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    eventLocation,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
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
                                const Icon(
                                  Icons.calendar_today,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  formattedEventDate,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
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
                
                // Actions row (optional - add like, comment buttons)
                const SizedBox(height: 12),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        // Like repost
                      },
                      icon: const Icon(
                        Icons.favorite_border,
                        size: 20,
                        color: Colors.grey,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      '0',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: () {
                        // Comment on repost
                      },
                      icon: const Icon(
                        Icons.comment_outlined,
                        size: 20,
                        color: Colors.grey,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      '0',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        // Share repost
                      },
                      icon: const Icon(
                        Icons.share_outlined,
                        size: 20,
                        color: Colors.grey,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserAvatar(String? userPhoto, String displayName) {
    if (userPhoto != null && userPhoto.isNotEmpty) {
      // If user has a photo
      return CircleAvatar(
        radius: 20,
        backgroundImage: AssetImage(userPhoto), // Use NetworkImage for URLs
        backgroundColor: AppColors.primaryDark,
      );
    } else {
      // If no photo, show initial
      return CircleAvatar(
        radius: 20,
        backgroundColor: AppColors.primaryDark,
        child: Text(
          displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }

  String _calculateTimeAgo(DateTime repostDate) {
    final now = DateTime.now();
    final difference = now.difference(repostDate);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}
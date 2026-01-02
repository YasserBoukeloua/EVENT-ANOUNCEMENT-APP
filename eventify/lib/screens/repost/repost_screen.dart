import 'package:eventify/data/databases/db_repost.dart';
import 'package:eventify/screens/repost/repost_comments_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventify/constants/app_colors.dart';
import 'package:eventify/cubits/repost/repost_cubit.dart';
import 'package:eventify/cubits/repost/repost_state.dart';
import 'package:eventify/cubits/profile/profile_cubit.dart';
import 'package:eventify/cubits/profile/profile_state.dart';
import 'package:eventify/screens/login/login_prompt_screen.dart';
import 'package:eventify/screens/profile/visible_profile.dart';
import 'package:eventify/screens/post_details/post_details_screen.dart';
import 'package:eventify/components/top_picks.dart';
import 'package:eventify/data/repo/comment/comment_repository.dart';
import 'package:eventify/services/session_service.dart';
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
            description:
                'Please log in or sign up to view and share event reposts',
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
                              const Icon(
                                Icons.error_outline,
                                size: 60,
                                color: Colors.red,
                              ),
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

class RepostCard extends StatefulWidget {
  final Map<String, dynamic> repostData;

  const RepostCard({Key? key, required this.repostData}) : super(key: key);

  @override
  State<RepostCard> createState() => _RepostCardState();
}

class _RepostCardState extends State<RepostCard> {
  final CommentRepositoryBase _commentRepo =
      CommentRepositoryBase.getInstance();
  bool _isLiked = false;
  int _likeCount = 0;
  int _commentCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInteractionData();
  }

  Future<void> _loadInteractionData() async {
    try {
      final repostId = widget.repostData['id'];
      if (repostId != null) {
        final dbReposts = DBRepostsTable();

        // Get repost like count
        _likeCount = await dbReposts.getRepostLikeCount(repostId);

        // Get repost comment count (NOT event comments)
        _commentCount = await dbReposts.getRepostCommentCount(repostId);

        // Check if current user liked this repost
        final userId = await SessionService.getUserId();
        if (userId != null) {
          _isLiked = await dbReposts.hasUserLikedRepost(userId, repostId);
        }
      }
    } catch (e) {
      print('Error loading interaction data: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _toggleLike() async {
    final userId = await SessionService.getUserId();
    if (userId == null) {
      _showLoginPrompt();
      return;
    }

    final repostId = widget.repostData['id'];
    if (repostId == null) return;

    final dbReposts = DBRepostsTable();
    final success = await dbReposts.toggleRepostLike(userId, repostId);

    if (success) {
      setState(() {
        _isLiked = !_isLiked;
        _likeCount = _isLiked ? _likeCount + 1 : _likeCount - 1;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isLiked ? 'Liked repost!' : 'Removed like',
            style: const TextStyle(fontFamily: 'InterTight'),
          ),
          duration: const Duration(seconds: 1),
          backgroundColor: _isLiked ? AppColors.success : Colors.grey,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to update like'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _navigateToComments() async {
    final userId = await SessionService.getUserId();
    if (userId == null) {
      _showLoginPrompt();
      return;
    }

    // Navigate and wait for the result (comment count)
    final updatedCount = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RepostCommentsScreen(repostData: widget.repostData),
      ),
    );

    // Update the comment count if we got a result back
    if (updatedCount != null && mounted) {
      setState(() {
        _commentCount = updatedCount;
      });
    }
  }

  void _showLoginPrompt() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Please log in to interact with posts',
          style: TextStyle(fontFamily: 'InterTight'),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.primaryDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'Login',
          textColor: Colors.white,
          onPressed: () {
            // Navigate to login screen
            // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
          },
        ),
      ),
    );
  }

  void _navigateToEventDetails() {
    final event = TopPicks(
      widget.repostData['event_id'],
      widget.repostData['event_date'] != null
          ? DateTime.parse(widget.repostData['event_date'])
          : null,
      widget.repostData['event_title'] ?? 'Event',
      widget.repostData['event_photo_path'] ?? 'lib/assets/event4.jpg',
      widget.repostData['event_location'] ?? 'Location',
      widget.repostData['event_publisher'] ?? 'Publisher',
      widget.repostData['event_is_free'] == 1,
      widget.repostData['event_category'] ?? 'Category',
      description: widget.repostData['event_description'],
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostDetails(event: event)),
    );
  }

  void _navigateToUserProfile() {
    final username = widget.repostData['user_username'] ?? 'User';
    final userName = widget.repostData['user_name'] as String?;
    final userLastName = widget.repostData['user_lastname'] as String?;

    String displayName = username;
    if (userName != null && userName.isNotEmpty) {
      displayName = userLastName != null && userLastName.isNotEmpty
          ? '$userName $userLastName'
          : userName;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VisibleProfilePage(
          username: username,
          fullName: displayName != username ? displayName : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
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
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.primaryDark),
        ),
      );
    }

    // Extract data from the map
    final eventTitle = widget.repostData['event_title'] ?? 'Event';
    final eventImage =
        widget.repostData['event_photo_path'] ?? 'lib/assets/event4.jpg';
    final eventLocation = widget.repostData['event_location'] ?? 'Location';
    final eventDate = widget.repostData['event_date'];
    final username = widget.repostData['user_username'] ?? 'User';
    final userName = widget.repostData['user_name'] as String?;
    final userLastName = widget.repostData['user_lastname'] as String?;
    final userPhoto = widget.repostData['user_photo'] as String?;
    final caption = widget.repostData['caption'] as String?;
    final repostTime = widget.repostData['created_at'];

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info row
            Padding(
              padding: const EdgeInsets.all(16).copyWith(
                bottom: caption != null && caption.isNotEmpty ? 8 : 16,
              ),
              child: Row(
                children: [
                  // User avatar - tappable to go to user profile
                  GestureDetector(
                    onTap: _navigateToUserProfile,
                    child: _buildUserAvatar(userPhoto, displayName),
                  ),
                  const SizedBox(width: 12),

                  // User name and repost info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: _navigateToUserProfile,
                          child: Text(
                            displayName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryDark,
                            ),
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
                  Icon(Icons.repeat, color: AppColors.primaryDark, size: 20),
                ],
              ),
            ),

            // Caption if available
            if (caption != null && caption.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    caption,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Event preview - tappable to go to event details
            GestureDetector(
              onTap: _navigateToEventDetails,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
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
              ),
            ),

            // Actions row - UPDATED: Working like and comment buttons, removed share
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Like button
                  IconButton(
                    onPressed: _toggleLike,
                    icon: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      size: 22,
                      color: _isLiked ? Colors.red : Colors.grey,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _likeCount.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _isLiked ? Colors.red : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 24),

                  // Comment button
                  IconButton(
                    onPressed: _navigateToComments,
                    icon: const Icon(
                      Icons.comment_outlined,
                      size: 22,
                      color: Colors.grey,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _commentCount.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),

                  const Spacer(),

                  // Add delete button if this is current user's repost
                  FutureBuilder<bool>(
                    future: _isCurrentUserRepost(),
                    builder: (context, snapshot) {
                      if (snapshot.data == true) {
                        return IconButton(
                          onPressed: _deleteRepost,
                          icon: const Icon(
                            Icons.delete_outline,
                            size: 22,
                            color: Colors.red,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          tooltip: 'Delete repost',
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _isCurrentUserRepost() async {
    final userId = await SessionService.getUserId();
    final repostUserId = widget.repostData['user_id'];
    return userId != null && repostUserId == userId;
  }

  Future<void> _deleteRepost() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Repost'),
        content: const Text('Are you sure you want to delete this repost?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final userId = await SessionService.getUserId();
        final eventId = widget.repostData['event_id'];

        if (userId != null && eventId != null) {
          final dbReposts = DBRepostsTable();
          await dbReposts.removeRepost(userId, eventId);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Repost deleted successfully'),
              backgroundColor: AppColors.success,
            ),
          );

          // You might want to refresh the repost list here
          // Could use a callback or Bloc to update the parent
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting repost: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildUserAvatar(String? userPhoto, String displayName) {
    if (userPhoto != null && userPhoto.isNotEmpty) {
      return CircleAvatar(
        radius: 20,
        backgroundImage: AssetImage(userPhoto),
        backgroundColor: AppColors.primaryDark,
      );
    } else {
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

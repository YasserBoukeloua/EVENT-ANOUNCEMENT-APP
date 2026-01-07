import 'package:flutter/material.dart';
import 'package:eventify/constants/app_colors.dart';
import 'package:eventify/data/databases/db_repost.dart';
import 'package:eventify/services/session_service.dart';
import 'package:intl/intl.dart';

class RepostCommentsScreen extends StatefulWidget {
  final Map<String, dynamic> repostData;

  const RepostCommentsScreen({Key? key, required this.repostData})
    : super(key: key);

  @override
  _RepostCommentsScreenState createState() => _RepostCommentsScreenState();
}

class _RepostCommentsScreenState extends State<RepostCommentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  List<Map<String, dynamic>> _comments = [];
  bool _isLoading = true;
  bool _isPosting = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    try {
      final repostId = widget.repostData['id'];
      if (repostId != null) {
        final dbReposts = DBRepostsTable();
        final newComments = await dbReposts.getRepostComments(repostId);

        // Use setState to update the comments list
        if (mounted) {
          setState(() {
            _comments = newComments;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error loading comments: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _postComment() async {
    if (_commentController.text.trim().isEmpty) return;

    final userId = await SessionService.getUserId();
    final repostId = widget.repostData['id'];

    if (userId == null || repostId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please log in to comment')));
      return;
    }

    setState(() => _isPosting = true);

    try {
      final dbReposts = DBRepostsTable();
      final success = await dbReposts.addRepostComment(
        repostId,
        userId,
        _commentController.text.trim(),
      );

      if (success) {
        _commentController.clear();
        await _loadComments(); // Refresh comments

        // Scroll to show new comment
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });

        FocusScope.of(context).unfocus();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to post comment')));
      }
    } catch (e) {
      print('Error posting comment: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) {
        setState(() => _isPosting = false);
      }
    }
  }

  Widget _buildRepostHeader() {
    final username = widget.repostData['user_username'] ?? 'User';
    final userPhoto = widget.repostData['user_photo'];
    final caption = widget.repostData['caption'];
    final repostTime = widget.repostData['created_at'];
    final eventTitle = widget.repostData['event_title'] ?? 'Event';
    final eventImage =
        widget.repostData['event_photo_path'] ?? 'lib/assets/event4.jpg';
    final eventLocation = widget.repostData['event_location'] ?? 'Location';
    final eventDate = widget.repostData['event_date'];

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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info row
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primaryDark,
                backgroundImage: userPhoto != null && userPhoto.isNotEmpty
                    ? AssetImage(userPhoto) as ImageProvider
                    : null,
                child: userPhoto == null || userPhoto.isEmpty
                    ? Text(
                        username.isNotEmpty ? username[0].toUpperCase() : 'U',
                        style: const TextStyle(color: Colors.white),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Shared $timeAgo',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.repeat, color: AppColors.primaryDark, size: 20),
            ],
          ),

          // Caption
          if (caption != null && caption.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(caption, style: const TextStyle(fontSize: 14)),
            ),
          ],

          // Event preview
          const SizedBox(height: 12),
          Container(
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eventTitle,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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

          // Comments header
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          Text(
            'Comments (${_comments.length})',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(Map<String, dynamic> comment, int index) {
    final username = comment['user_username'] ?? 'User';
    final userName = comment['user_name'] as String?;
    final userLastName = comment['user_lastname'] as String?;
    final content = comment['content'] ?? '';
    final createdAt = comment['created_at'];
    final userPhoto = comment['user_photo'];

    // Create display name
    String displayName = username;
    if (userName != null && userName.isNotEmpty) {
      displayName = userLastName != null && userLastName.isNotEmpty
          ? '$userName $userLastName'
          : userName;
    }

    String timeAgo = 'Just now';
    if (createdAt != null) {
      try {
        final date = DateTime.parse(createdAt);
        timeAgo = _calculateTimeAgo(date);
      } catch (e) {
        print('Error parsing comment time: $e');
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: index.isEven ? Colors.white : Colors.grey[50],
        border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primaryDark,
            backgroundImage: userPhoto != null && userPhoto.isNotEmpty
                ? AssetImage(userPhoto) as ImageProvider
                : null,
            child: userPhoto == null || userPhoto.isEmpty
                ? Text(
                    displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U',
                    style: const TextStyle(color: Colors.white),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '· $timeAgo',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(content, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _calculateTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(_comments.length);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: const Text(
              'Comments',
              style: TextStyle(color: Colors.white),
            ),
          ),
          backgroundColor: AppColors.primaryDark,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 25,
            ),
            onPressed: () {
              // Return the comment count when going back
              Navigator.of(context).pop(_comments.length);
            },
          ),
          // Remove automaticallyImplyLeading or set it to false
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            // Repost header (fixed height)
            _buildRepostHeader(),

            // Comments list (scrollable)
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _comments.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.comment_outlined,
                          size: 60,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No comments yet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Be the first to comment on this repost!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      reverse: true, // Newest comments at bottom
                      itemCount: _comments.length,
                      itemBuilder: (context, index) {
                        // Reverse index to show newest first
                        final reversedIndex = _comments.length - 1 - index;
                        return _buildCommentItem(
                          _comments[reversedIndex],
                          reversedIndex,
                        );
                      },
                    ),
            ),

            // Comment input (fixed at bottom)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey[300]!)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: 'Write a comment...',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          suffixIcon: _commentController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 20),
                                  onPressed: () => _commentController.clear(),
                                )
                              : null,
                        ),
                        maxLines: 3,
                        minLines: 1,
                        onSubmitted: (_) => _postComment(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryDark,
                    ),
                    child: IconButton(
                      onPressed: _postComment,
                      icon: _isPosting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 20,
                            ),
                      padding: const EdgeInsets.all(8),
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

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

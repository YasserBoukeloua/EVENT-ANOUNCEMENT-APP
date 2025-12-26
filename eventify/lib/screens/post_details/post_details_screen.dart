import 'package:eventify/cubits/favorites/favorites_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventify/constants/app_colors.dart';
import 'package:eventify/cubits/favorites/favorites_cubit.dart';
import 'package:eventify/cubits/profile/profile_cubit.dart';
import 'package:eventify/cubits/repost/repost_cubit.dart'; // NEW: Import repost cubit
import 'package:eventify/data/repo/comment/comment_repository.dart';
import 'package:eventify/services/session_service.dart';
import 'package:intl/intl.dart';
import 'package:eventify/screens/profile/visible_profile.dart';

class PostDetails extends StatefulWidget {
  final dynamic event;

  const PostDetails({super.key, required this.event});

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  bool _showCommentInput = false;
  final _scrollController = ScrollController();
  final _commentController = TextEditingController();
  final _focusNode = FocusNode();
  final _commentRepo = CommentRepositoryBase.getInstance();

  List<Map<String, dynamic>> _comments = [];
  bool _isLoadingComments = true;

  @override
  void initState() {
    super.initState();
    _loadComments();
    _scrollController.addListener(() {
      final show =
          _scrollController.offset >=
          _scrollController.position.maxScrollExtent - 100;
      if (_showCommentInput != show) setState(() => _showCommentInput = show);
    });
  }

  Future<void> _loadComments() async {
    final comments = await _commentRepo.getCommentsByEventId(widget.event.id);
    setState(() {
      _comments = comments;
      _isLoadingComments = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  _buildImageHeader(),
                  _buildEventDetails(),
                  _buildCommentsSection(),
                  const SizedBox(height: 120),
                ],
              ),
            ),
            Align(alignment: Alignment.bottomCenter, child: _buildBottomBar()),
          ],
        ),
      ),
    );
  }

  Widget _buildImageHeader() => Stack(
    children: [
      Container(
        height: 380,
        width: double.infinity,
        margin: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        clipBehavior: Clip.hardEdge,
        child: Image.asset(
          widget.event.pathToImg ?? 'lib/assets/event1.webp',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: Colors.grey[800],
            child: const Center(
              child: Icon(Icons.event, size: 80, color: Colors.white54),
            ),
          ),
        ),
      ),
      Positioned(
        top: 35,
        left: 35,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: CircleAvatar(
            backgroundColor: Colors.grey.withOpacity(0.6),
            radius: 25,
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
    ],
  );

  Widget _buildEventDetails() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: [
        _buildInfoCard(),
        const SizedBox(height: 20),
        _buildAboutCard(),
        const SizedBox(height: 20),
      ],
    ),
  );

  Widget _buildInfoCard() => _roundedCard(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Creator Info
        GestureDetector(
          onTap: () {
            final publisher = widget.event.publisher;
            if (publisher != null && publisher.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VisibleProfilePage(username: publisher),
                ),
              );
            }
          },
          child: Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primaryDark,
                child: Icon(Icons.person, size: 20, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Text(
                widget.event.publisher ?? 'Unknown',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                  fontFamily: 'InterTight',
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.verified,
                size: 16,
                color: AppColors.primaryDark,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          widget.event.nameOfevent ?? 'Event',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: 'InterTight',
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: AppColors.primaryDark,
                    size: 22,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      widget.event.location ?? 'Location',
                      style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  widget.event.date != null
                      ? DateFormat('dd MMM. yyyy').format(widget.event.date!)
                      : 'Date',
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: (widget.event.isFree ?? false)
                        ? AppColors.success
                        : AppColors.error,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    (widget.event.isFree ?? false) ? 'Free' : 'Paid',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'InterTight',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );

  Widget _buildAboutCard() => _roundedCard(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About event',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'InterTight',
          ),
        ),
        const SizedBox(height: 12),
        Text(
          widget.event.description ??
              'No description available for this event. Check back later for more details!',
          style: const TextStyle(
            fontSize: 16,
            height: 1.5,
            fontFamily: 'InterTight',
          ),
        ),
      ],
    ),
  );

  Widget _buildCommentsSection() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: _roundedCard(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Comments',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'InterTight',
                ),
              ),
              Text(
                '${_comments.length}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isLoadingComments)
            const Center(child: CircularProgressIndicator())
          else if (_comments.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'No comments yet. Be the first to comment!',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _comments.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, i) => _buildCommentItem(_comments[i], i),
            ),
          if (_showCommentInput) ...[
            const SizedBox(height: 16),
            _buildCommentInput(),
          ],
        ],
      ),
    ),
  );

  Widget _buildCommentItem(Map<String, dynamic> comment, int i) {
    final username = comment['username'] ?? 'Anonymous';
    final commentText = comment['comment'] ?? '';
    final isLiked = comment['is_liked'] == 1;
    final createdAt = comment['created_at'];

    // Calculate time ago
    String timeAgo = 'just now';
    if (createdAt != null) {
      try {
        final date = DateTime.parse(createdAt);
        final diff = DateTime.now().difference(date);
        if (diff.inDays > 0) {
          timeAgo = '${diff.inDays}d';
        } else if (diff.inHours > 0) {
          timeAgo = '${diff.inHours}h';
        } else if (diff.inMinutes > 0) {
          timeAgo = '${diff.inMinutes}m';
        }
      } catch (_) {}
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.primaryDark,
          child: Text(
            username[0].toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      username,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'InterTight',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    timeAgo,
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                commentText,
                style: const TextStyle(fontSize: 15, height: 1.3),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () async {
            final commentId = comment['id'];
            if (commentId != null) {
              await _commentRepo.toggleLike(commentId);
              _loadComments();
            }
          },
          // CHANGED: Purple color for star icons
          child: Icon(
            isLiked ? Icons.star : Icons.star_border,
            color: isLiked ? AppColors.primaryDark : Colors.grey[700],
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    color: AppColors.backgroundLight,
    child: Row(
      children: [
        // Repost Button
        CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.primaryDark,
          child: IconButton(
            onPressed: _navigateToRepostPage,
            icon: const Icon(Icons.repeat, color: Colors.white, size: 26),
            tooltip: 'Repost',
          ),
        ),
        const SizedBox(width: 12),

        Expanded(
          child: ElevatedButton(
            onPressed: _register,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text(
              'Register Now',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'InterTight',
                color: AppColors.divider,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Using Stateful approach with BlocBuilder
        BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, state) {
            return FutureBuilder<bool>(
              future: context.read<FavoritesCubit>().isFavorite(
                widget.event.id,
              ),
              builder: (context, snapshot) {
                final isFavorite = snapshot.data ?? false;

                return CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primaryDark,
                  child: IconButton(
                    onPressed: () async {
                      await _toggleFavorite();
                      // Force a rebuild of the BlocBuilder
                      context.read<FavoritesCubit>().loadFavorites();
                    },
                    icon: Icon(
                      isFavorite ? Icons.star : Icons.star_border,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    ),
  );

  Widget _buildCommentInput() => Row(
    children: [
      Expanded(
        child: TextField(
          controller: _commentController,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: 'Add a comment...',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            filled: true,
            fillColor: Colors.white,
          ),
          textInputAction: TextInputAction.send,
          onSubmitted: (_) => _sendComment(),
        ),
      ),
      const SizedBox(width: 8),
      CircleAvatar(
        radius: 22,
        backgroundColor: AppColors.primaryDark,
        child: IconButton(
          icon: const Icon(Icons.send, color: Colors.white, size: 20),
          onPressed: _sendComment,
        ),
      ),
    ],
  );

  Widget _roundedCard(Widget child) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: AppColors.divider,
      borderRadius: BorderRadius.circular(15),
    ),
    child: child,
  );

  // NEW: Navigate to Repost Page
  void _navigateToRepostPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateRepostScreen(event: widget.event),
      ),
    );
  }

  Future<void> _sendComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final profileState = context.read<ProfileCubit>().state;
    String username = 'Anonymous';
    int userId = 1;

    if (profileState.user != null) {
      username = profileState.user!.name.isNotEmpty
          ? profileState.user!.name
          : profileState.user!.username;
      userId = profileState.user!.id;
    }

    // Try to get user ID from session if not in profile
    final sessionUserId = await SessionService.getUserId();
    if (sessionUserId != null) {
      userId = sessionUserId;
    }

    await _commentRepo.addComment(
      eventId: widget.event.id,
      userId: userId,
      username: username,
      comment: text,
    );

    _commentController.clear();
    _focusNode.unfocus();
    _showSnack('Comment posted!');
    _loadComments(); // Reload comments from database
  }

  void _register() => _showSnack('Registration initiated!');

  Future<void> _toggleFavorite() async {
    final cubit = context.read<FavoritesCubit>();
    final isFavorite = await cubit.isFavorite(widget.event.id);
    await cubit.toggleFavorite(widget.event.id);

    // Refresh the favorites list to trigger UI update
    cubit.loadFavorites();

    _showSnack(isFavorite ? 'Removed from favorites!' : 'Added to favorites!');
  }

  void _showSnack(String msg) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg, style: const TextStyle(fontFamily: 'InterTight')),
      duration: const Duration(seconds: 2),
      backgroundColor: AppColors.primaryDark,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}

// NEW: Create Repost Screen Widget
class CreateRepostScreen extends StatefulWidget {
  final dynamic event;

  const CreateRepostScreen({super.key, required this.event});

  @override
  State<CreateRepostScreen> createState() => _CreateRepostScreenState();
}

class _CreateRepostScreenState extends State<CreateRepostScreen> {
  final TextEditingController _captionController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        title: const Text(
          'Create Repost',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'InterTight',
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_isSubmitting)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Preview Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: AppColors.primaryDark.withOpacity(0.2),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Image
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(
                          widget.event.pathToImg ?? 'lib/assets/event1.webp',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Event Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.event.nameOfevent ?? 'Event',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'InterTight',
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 16,
                              color: AppColors.primaryDark,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                widget.event.location ?? 'Location',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.primaryDark,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.event.date != null
                              ? DateFormat(
                                  'dd MMM. yyyy',
                                ).format(widget.event.date!)
                              : 'Date not set',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Caption Input
            const Text(
              'Add a caption (optional)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'InterTight',
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: AppColors.primaryDark.withOpacity(0.2),
                ),
              ),
              child: TextField(
                controller: _captionController,
                maxLines: 5,
                maxLength: 500,
                decoration: const InputDecoration(
                  hintText: 'Share your thoughts about this event...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                  counterStyle: TextStyle(color: Colors.grey),
                ),
                style: const TextStyle(fontSize: 16, fontFamily: 'InterTight'),
              ),
            ),

            const SizedBox(height: 10),
            Text(
              '${_captionController.text.length}/500',
              style: TextStyle(
                fontSize: 12,
                color: _captionController.text.length > 500
                    ? Colors.red
                    : Colors.grey,
              ),
              textAlign: TextAlign.right,
            ),

            const SizedBox(height: 40),

            // Repost Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _createRepost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: _isSubmitting
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Sharing...',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'InterTight',
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    : const Text(
                        'Share Repost',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'InterTight',
                          color: Colors.white,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            // Cancel Button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'InterTight',
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createRepost() async {
    if (_captionController.text.length > 500) {
      _showError('Caption cannot exceed 500 characters');
      return;
    }

    // Check if user is logged in
    final isLoggedIn = await SessionService.isLoggedIn();
    if (!isLoggedIn) {
      _showError('Please log in to repost events');
      Navigator.pop(context); // Close repost screen
      // You might want to navigate to login screen here
      return;
    }

    // Get current user ID
    final userId = await SessionService.getUserId();
    if (userId == null) {
      _showError('User session not found. Please log in again.');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Get the RepostCubit from context
      final repostCubit = context.read<RepostCubit>();

      // Create the repost with current user ID
      await repostCubit.addRepost(
        widget.event.id,
        caption: _captionController.text.trim(),
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Event reposted successfully!',
            style: TextStyle(fontFamily: 'InterTight'),
          ),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      // Navigate back
      Navigator.pop(context);
    } catch (e) {
      _showError('Failed to repost: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'InterTight'),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

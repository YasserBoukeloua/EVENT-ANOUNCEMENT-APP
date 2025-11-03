import 'package:flutter/material.dart';

class PostDetails extends StatefulWidget {
  const PostDetails({super.key});

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  bool isFavorite = false;
  bool _showCommentInput = false;
  final _scrollController = ScrollController();
  final _commentController = TextEditingController();
  final _focusNode = FocusNode();

  final comments = [
    Comment('louai mahfoud', 'This looks amazing! Can\'t wait to attend', '2h'),
    
    Comment('louai mahfoud', 'This looks amazing! Can\'t wait to attend', '2h', true),
    Comment('louai mahfoud', 'This looks amazing! Can\'t wait to attend', '2h'),
    Comment('louai mahfoud', 'This looks amazing! Can\'t wait to attend', '2h'),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final show = _scrollController.offset >=
          _scrollController.position.maxScrollExtent - 100;
      if (_showCommentInput != show) setState(() => _showCommentInput = show);
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
      backgroundColor: const Color(0xFFACADBC),
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

  Widget _buildImageHeader() => Stack(children: [
        Container(
          height: 380,
          width: double.infinity,
          margin: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          clipBehavior: Clip.hardEdge,
          child: Image.asset(
            'assets/images/etcode.jpg',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey[800],
              child: const Center(
                  child: Icon(Icons.event, size: 80, color: Colors.white54)),
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
              child: const Icon(Icons.arrow_back_ios_new,
                  color: Colors.white, size: 20),
            ),
          ),
        ),
      ]);

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
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('ETCode',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'InterTight')),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Row(children: [
              Icon(Icons.location_on, color: Color(0xFF230C33), size: 22),
              SizedBox(width: 6),
              Text('ensia, Algiers',
                  style: TextStyle(color: Color(0xFF230C33), fontSize: 16)),
            ]),
            const Text('12 Nov. 2025',
                style: TextStyle(color: Color(0xFF230C33), fontSize: 16))
          ]),
        ]),
      );

  Widget _buildAboutCard() => _roundedCard(const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('About event',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'InterTight')),
          SizedBox(height: 12),
          Text(
            'Join us for the Mobile Development Event, where innovation meets creativity! \n\n'
            'Discover the latest trends in app design, cross-platform tools, and mobile AI integration.\n\n'
            'Collaborate with passionate developers to build impactful mobile solutions.',
            style: TextStyle(fontSize: 16, height: 1.5, fontFamily: 'InterTight'),
          )
        ],
      ));

  Widget _buildCommentsSection() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: _roundedCard(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Comments',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'InterTight')),
              Text('${comments.length}',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF230C33))),
            ]),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: comments.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, i) => _buildCommentItem(comments[i], i),
            ),
            if (_showCommentInput) ...[
              const SizedBox(height: 16),
              _buildCommentInput(),
            ]
          ],
        )),
      );

  Widget _buildCommentItem(Comment c, int i) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF230C33),
              child: Text(c.username[0].toUpperCase(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Row(children: [
                  Text(c.username,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'InterTight')),
                  const SizedBox(width: 8),
                  Text(c.timeAgo,
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]))
                ]),
                const SizedBox(height: 4),
                Text(c.comment,
                    style: const TextStyle(fontSize: 15, height: 1.3)),
              ])),
          const SizedBox(width: 8),
          GestureDetector(
              onTap: () => setState(() => c.isLiked = !c.isLiked),
              child: Icon(c.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: c.isLiked ? Colors.red : Colors.grey[700], size: 20))
        ],
      );

  Widget _buildBottomBar() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        color: const Color(0xFFACADBC),
        child: Row(children: [
          Expanded(
              child: ElevatedButton(
            onPressed: _register,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF230C33),
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
            ),
            child: const Text(
              'Register Now',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'InterTight',
                color: Color(0xFFD9D9D9), // 🔹 unified color
              ),
            ),
          )),
          const SizedBox(width: 16),
          CircleAvatar(
            radius: 32,
            backgroundColor: const Color(0xFF230C33),
            child: IconButton(
              onPressed: _toggleFavorite,
              icon: Icon(
                  isFavorite ? Icons.star : Icons.star_border,
                  color: Colors.white,
                  size: 30),
            ),
          )
        ]),
      );

  Widget _buildCommentInput() => Row(children: [
        Expanded(
          child: TextField(
            controller: _commentController,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: 'Add a comment...',
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
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
            backgroundColor: const Color(0xFF230C33),
            child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: _sendComment))
      ]);

  Widget _roundedCard(Widget child) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(15),
        ),
        child: child,
      );

  void _sendComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      comments.insert(0, Comment('you', text, 'now'));
      _commentController.clear();
    });
    _focusNode.unfocus();
    _showSnack('Comment posted!');
  }

  void _register() => _showSnack('Registration initiated!');
  void _toggleFavorite() {
    setState(() => isFavorite = !isFavorite);
    _showSnack(isFavorite ? 'Added to favorites!' : 'Removed from favorites!');
  }

  void _showSnack(String msg) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(msg, style: const TextStyle(fontFamily: 'InterTight')),
          duration: const Duration(seconds: 2),
          backgroundColor: const Color(0xFF230C33),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
}

class Comment {
  final String username, comment, timeAgo;
  bool isLiked;
  Comment(this.username, this.comment, this.timeAgo, [this.isLiked = false]);
}

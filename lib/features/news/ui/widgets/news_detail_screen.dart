import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:travel_map/features/news/domain/models/news_post.dart';
import 'package:travel_map/shared/theme/app_colors.dart';
import 'package:travel_map/shared/theme/app_typography.dart';

class NewsDetailScreen extends StatefulWidget {
  const NewsDetailScreen({required this.post, super.key});

  final NewsPost post;

  static const routeName = 'news-detail';
  static const routePath = '/news/detail';

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  bool _showReactionPicker = false;
  String? _selectedReactionEmoji;
  String _selectedReactionLabel = 'Thả tim';
  Color _selectedReactionColor = AppColors.mutedForeground;
  IconData _selectedReactionIcon = LucideIcons.heart;
  late int _likesCount;

  @override
  void initState() {
    super.initState();
    _likesCount = widget.post.likesCount;
  }

  void _onSelectReaction(
    String emoji,
    String label,
    Color color,
    IconData icon,
  ) {
    setState(() {
      if (_selectedReactionEmoji == emoji) {
        _selectedReactionEmoji = null;
        _selectedReactionLabel = 'Thả tim';
        _selectedReactionColor = AppColors.mutedForeground;
        _selectedReactionIcon = LucideIcons.heart;
        _likesCount--;
      } else {
        if (_selectedReactionEmoji == null) {
          _likesCount++;
        }
        _selectedReactionEmoji = emoji;
        _selectedReactionLabel = label;
        _selectedReactionColor = color;
        _selectedReactionIcon = icon;
      }
      _showReactionPicker = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final isVideo = post.id == '3'; // CLB Du Lịch Trải Nghiệm is treated as a video post

    // Mock comments matching React sampleComments
    final mockComments = [
      {
        'name': 'Nguyễn Thị Hoa',
        'avatar': 'NH',
        'time': '1 giờ trước',
        'text': 'Năm nay đi hội sớm quá, ai đi cùng không cả nhà ơi 🥰',
      },
      {
        'name': 'Trần Văn Minh',
        'avatar': 'TM',
        'time': '45 phút trước',
        'text': 'Mình chụp được tấm này hôm qua, đẹp quá nên gửi mọi người xem!',
      },
      {
        'name': 'Phạm Thu Hằng',
        'avatar': 'PH',
        'time': '2 giờ trước',
        'text': 'Ảnh đẹp quá. Cuối tuần này em cũng phải rủ gia đình đi check-in mới được.',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.card,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 52,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.chevronLeft,
                  size: 18,
                  color: AppColors.foreground,
                ),
              ),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bài viết',
              style: TextStyle(
                fontSize: AppTypography.s14,
                fontWeight: FontWeight.bold,
                color: AppColors.foreground,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              post.authorName,
              style: TextStyle(
                fontSize: AppTypography.s10,
                color: AppColors.mutedForeground,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(LucideIcons.moreHorizontal, size: 20, color: AppColors.foreground),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(
            color: AppColors.border.withValues(alpha: 0.4),
            height: 0.5,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Author Info Row
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(post.authorAvatar),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.authorName,
                              style: TextStyle(
                                fontSize: AppTypography.s13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.foreground,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Text(
                                  post.timeAgo,
                                  style: TextStyle(
                                    fontSize: AppTypography.s10,
                                    color: AppColors.mutedForeground,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '·',
                                  style: TextStyle(
                                    fontSize: AppTypography.s10,
                                    color: AppColors.mutedForeground,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    post.category,
                                    style: TextStyle(
                                      fontSize: AppTypography.s9,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Post content
                  Text(
                    post.content,
                    style: TextStyle(
                      fontSize: AppTypography.s14,
                      height: 1.45,
                      color: AppColors.foreground,
                    ),
                  ),

                  // Post Media
                  if (post.imageUrls.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MediaViewerScreen(
                              src: post.imageUrls.first,
                              type: isVideo ? 'video' : 'image',
                              duration: isVideo ? '0:42' : null,
                            ),
                          ),
                        );
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              post.imageUrls.first,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                              color: isVideo ? Colors.black.withValues(alpha: 0.15) : null,
                              colorBlendMode: isVideo ? BlendMode.darken : null,
                            ),
                          ),
                          if (isVideo) ...[
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.9),
                                shape: BoxShape.circle,
                                boxShadow: AppColors.softShadow,
                              ),
                              child: const Center(
                                child: Icon(
                                  LucideIcons.play,
                                  size: 24,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.7),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '0:42',
                                  style: TextStyle(
                                    fontSize: AppTypography.s10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),

                  // Reaction Summary & Stateful Actions Row
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  _buildReactionBadge(AppColors.primary, LucideIcons.heart),
                                  _buildReactionBadge(const Color(0xFF1877F2), LucideIcons.thumbsUp),
                                  _buildReactionBadge(AppColors.gold, LucideIcons.laugh),
                                  const SizedBox(width: 6),
                                  Text(
                                    '$_likesCount',
                                    style: TextStyle(
                                      fontSize: AppTypography.s11,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.foreground,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${post.commentsCount} bình luận · 12 chia sẻ',
                                style: TextStyle(
                                  fontSize: AppTypography.s10,
                                  color: AppColors.mutedForeground,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Actions row
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: AppColors.border.withValues(alpha: 0.4), width: 0.5),
                                bottom: BorderSide(color: AppColors.border.withValues(alpha: 0.4), width: 0.5),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      if (_selectedReactionEmoji != null) {
                                        _onSelectReaction(
                                          '❤️',
                                          'Thả tim',
                                          AppColors.mutedForeground,
                                          LucideIcons.heart,
                                        );
                                      } else {
                                        _onSelectReaction(
                                          '❤️',
                                          'Yêu thích',
                                          AppColors.primary,
                                          LucideIcons.heart,
                                        );
                                      }
                                    },
                                    onLongPress: () {
                                      setState(() {
                                        _showReactionPicker = !_showReactionPicker;
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          if (_selectedReactionEmoji != null)
                                            Text(
                                              _selectedReactionEmoji!,
                                              style: TextStyle(fontSize: AppTypography.s16),
                                            )
                                          else
                                            Icon(
                                              _selectedReactionIcon,
                                              size: 16,
                                              color: _selectedReactionColor,
                                            ),
                                          const SizedBox(width: 6),
                                          Text(
                                            _selectedReactionLabel,
                                            style: TextStyle(
                                              fontSize: AppTypography.s11,
                                              fontWeight: FontWeight.bold,
                                              color: _selectedReactionColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: _buildActionTab(
                                    icon: LucideIcons.messageCircle,
                                    label: 'Bình luận',
                                  ),
                                ),
                                Expanded(
                                  child: _buildActionTab(
                                    icon: LucideIcons.share2,
                                    label: 'Chia sẻ',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Facebook-style Animated Reaction Selector Bar
                      if (_showReactionPicker)
                        Positioned(
                          bottom: 44,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.18),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _ReactionPickerItem(
                                  emoji: '👍',
                                  label: 'Thích',
                                  color: const Color(0xFF1877F2),
                                  icon: LucideIcons.thumbsUp,
                                  onTap: () => _onSelectReaction(
                                    '👍',
                                    'Thích',
                                    const Color(0xFF1877F2),
                                    LucideIcons.thumbsUp,
                                  ),
                                ),
                                _ReactionPickerItem(
                                  emoji: '❤️',
                                  label: 'Yêu thích',
                                  color: AppColors.primary,
                                  icon: LucideIcons.heart,
                                  onTap: () => _onSelectReaction(
                                    '❤️',
                                    'Yêu thích',
                                    AppColors.primary,
                                    LucideIcons.heart,
                                  ),
                                ),
                                _ReactionPickerItem(
                                  emoji: '😆',
                                  label: 'Haha',
                                  color: AppColors.gold,
                                  icon: LucideIcons.laugh,
                                  onTap: () => _onSelectReaction(
                                    '😆',
                                    'Haha',
                                    AppColors.gold,
                                    LucideIcons.laugh,
                                  ),
                                ),
                                _ReactionPickerItem(
                                  emoji: '😮',
                                  label: 'Bất ngờ',
                                  color: Colors.purple,
                                  icon: LucideIcons.partyPopper,
                                  onTap: () => _onSelectReaction(
                                    '😮',
                                    'Bất ngờ',
                                    Colors.purple,
                                    LucideIcons.partyPopper,
                                  ),
                                ),
                                _ReactionPickerItem(
                                  emoji: '😢',
                                  label: 'Buồn',
                                  color: Colors.blueGrey,
                                  icon: LucideIcons.frown,
                                  onTap: () => _onSelectReaction(
                                    '😢',
                                    'Buồn',
                                    Colors.blueGrey,
                                    LucideIcons.frown,
                                  ),
                                ),
                                _ReactionPickerItem(
                                  emoji: '😡',
                                  label: 'Phẫn nộ',
                                  color: Colors.redAccent,
                                  icon: LucideIcons.angry,
                                  onTap: () => _onSelectReaction(
                                    '😡',
                                    'Phẫn nộ',
                                    Colors.redAccent,
                                    LucideIcons.angry,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Comments section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bình luận nổi bật',
                        style: TextStyle(
                          fontSize: AppTypography.s12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.foreground,
                        ),
                      ),
                      Text(
                        'Xem tất cả',
                        style: TextStyle(
                          fontSize: AppTypography.s11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...mockComments.map((comment) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: AppColors.secondary,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                comment['avatar']!,
                                style: TextStyle(
                                  fontSize: AppTypography.s10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.foreground,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary,
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(16),
                                      bottomLeft: Radius.circular(16),
                                      bottomRight: Radius.circular(16),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        comment['name']!,
                                        style: TextStyle(
                                          fontSize: AppTypography.s11,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.foreground,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        comment['text']!,
                                        style: TextStyle(
                                          fontSize: AppTypography.s11,
                                          color: AppColors.foreground,
                                          height: 1.35,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      comment['time']!,
                                      style: TextStyle(
                                        fontSize: AppTypography.s9,
                                        color: AppColors.mutedForeground,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Text(
                                        'Thích',
                                        style: TextStyle(
                                          fontSize: AppTypography.s9,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.mutedForeground,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Text(
                                        'Trả lời',
                                        style: TextStyle(
                                          fontSize: AppTypography.s9,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.mutedForeground,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          
          // Bottom Compose comment input bar
          Container(
            padding: EdgeInsets.fromLTRB(
              16,
              8,
              16,
              MediaQuery.of(context).padding.bottom + 8,
            ),
            decoration: BoxDecoration(
              color: AppColors.card,
              border: Border(
                top: BorderSide(color: AppColors.border.withValues(alpha: 0.4), width: 0.5),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      style: TextStyle(fontSize: AppTypography.s12),
                      decoration: InputDecoration(
                        hintText: 'Viết bình luận…',
                        hintStyle: TextStyle(
                          fontSize: AppTypography.s12,
                          color: AppColors.mutedForeground,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    LucideIcons.send,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReactionBadge(Color bg, IconData icon) {
    return Container(
      width: 18,
      height: 18,
      margin: const EdgeInsets.only(right: 2),
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: Center(
        child: Icon(
          _getFilledIcon(icon),
          size: 9,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildActionTab({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: AppColors.mutedForeground),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: AppTypography.s11,
              fontWeight: FontWeight.bold,
              color: AppColors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getFilledIcon(IconData outlineIcon) {
    if (outlineIcon == LucideIcons.heart) return Icons.favorite;
    if (outlineIcon == LucideIcons.thumbsUp) return Icons.thumb_up;
    if (outlineIcon == LucideIcons.laugh) return Icons.sentiment_very_satisfied;
    if (outlineIcon == LucideIcons.partyPopper) return Icons.celebration;
    if (outlineIcon == LucideIcons.frown) return Icons.sentiment_dissatisfied;
    if (outlineIcon == LucideIcons.angry) return Icons.mood_bad;
    return outlineIcon;
  }
}

class MediaViewerScreen extends StatelessWidget {
  const MediaViewerScreen({
    required this.src,
    required this.type,
    this.duration,
    super.key,
  });

  final String src;
  final String type; // 'image' or 'video'
  final String? duration;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Media display
          Positioned.fill(
            child: InteractiveViewer(
              child: Image.network(
                src,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  LucideIcons.image,
                  size: 48,
                  color: Colors.white24,
                ),
              ),
            ),
          ),

          if (type == 'video')
            Positioned.fill(
              child: Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      LucideIcons.play,
                      size: 28,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),

          // Top buttons
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 12,
            right: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.x,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.share2,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.moreHorizontal,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bottom seek bar for video
          if (type == 'video' && duration != null)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 24,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  Text(
                    '0:00',
                    style: TextStyle(
                      fontSize: AppTypography.s10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: 0.25,
                        minHeight: 3,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    duration!,
                    style: TextStyle(
                      fontSize: AppTypography.s10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ReactionPickerItem extends StatefulWidget {
  const _ReactionPickerItem({
    required this.emoji,
    required this.label,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  @override
  State<_ReactionPickerItem> createState() => _ReactionPickerItemState();
}

class _ReactionPickerItemState extends State<_ReactionPickerItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: AnimatedScale(
            scale: _isHovered ? 1.35 : 1.0,
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOutBack,
            child: Text(
              widget.emoji,
              style: TextStyle(fontSize: AppTypography.s24),
            ),
          ),
        ),
      ),
    );
  }
}
